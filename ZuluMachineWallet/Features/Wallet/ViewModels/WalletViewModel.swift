//
//  WalletViewModel.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation
import SwiftUI
import Combine

public struct CurrencyDisplayItem: Identifiable {
    
    public let id = UUID()
    public let currency: String
    public var formatted: String
    public var changePct: Double?
    public var increased: Bool?
}

@MainActor
public final class WalletViewModel: ObservableObject {
    
    @Published public var btcAmount: String = "0.0"
    @Published public var baseCurrency: String = "BTC"
    @Published public var displayItems: [CurrencyDisplayItem] = []
    @Published public var lastUpdatedDate: String?
    @Published public var isLoading: Bool = false
    @Published public var toastText: String? = nil
    @Published public var errorMessage: String?

    private let useCase: WalletFetchRatesUseCase
    private let storageKey = "zulumachine_btc_v1"
    private let currencies = ["ZAR","USD","AUD"]

    public init(useCase: WalletFetchRatesUseCase) {
        self.useCase = useCase
        self.btcAmount = UserDefaults.standard.string(forKey: storageKey) ?? "0.0"
    }

    public func savePersisted() {
        UserDefaults.standard.setValue(btcAmount, forKey: storageKey)
        toastText = "Saved".localized
        Haptics.success()
    }

    private var btcDecimal: Decimal { Decimal(string: btcAmount) ?? Decimal(0) }

    public func load(force: Bool) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let latest = try await useCase.latest(base: baseCurrency, symbols: currencies, force: force)
            buildDisplay(from: latest)
            
            // fluctuation
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate]
            let end = formatter.string(from: Date())
            let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            let start = formatter.string(from: yesterday)
            
            let fluctuationResponse = try await useCase.fluctuation(
                start: start,
                end: end,
                base: baseCurrency,
                symbols: currencies,
                force: force)
            
            applyFluctuation(fluctuationResponse)
        } catch {
            errorMessage = error.localizedDescription
            toastText = error.localizedDescription
            Haptics.error()
        }
    }

    private func buildDisplay(from resp: FixerLatestResponse) {
        var items: [CurrencyDisplayItem] = []
        items.append(CurrencyDisplayItem(currency: baseCurrency, formatted: "\(btcAmount) \(baseCurrency)", changePct: nil, increased: nil))
        for currency in currencies {
            if let rate = resp.rates[currency] {
                let decimal = NSDecimalNumber(decimal: btcDecimal).multiplying(by: NSDecimalNumber(value: rate))
                let formatted = CurrencyFormatter.format(number: decimal, currency: currency)
                items.append(CurrencyDisplayItem(currency: currency, formatted: formatted, changePct: nil, increased: nil))
            } else {
                items.append(CurrencyDisplayItem(currency: currency, formatted: "--", changePct: nil, increased: nil))
            }
        }
        withAnimation { displayItems = items }
    }

    private func applyFluctuation(_ fluctuationResponse: FixerFluctuationResponse) {
        lastUpdatedDate = "Last updated on: \(fluctuationResponse.end_date ?? "")"
        var map = [String: FixerFluctuationRate]()
        for (key,value) in fluctuationResponse.rates { map[key] = value }
        var updated = displayItems
        for i in 0..<updated.count {
            let currency = updated[i].currency
            if let fr = map[currency], let percentage = fr.change_pct {
                updated[i].changePct = percentage
                updated[i].increased = (fr.change ?? 0) > 0
            }
        }
        withAnimation { displayItems = updated }
    }
}


