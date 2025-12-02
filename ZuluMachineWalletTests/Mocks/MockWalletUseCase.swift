//
//  MockWalletUseCase.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation
@testable import ZuluMachineWallet

final class MockWalletUseCase: WalletFetchRatesUseCase {

    func latest(base: String, symbols: [String], force: Bool) async throws -> FixerLatestResponse {
        return FixerLatestResponse(
            success: true,
            timestamp: 0,
            base: "BTC",
            date: "2025-01-01",
            rates: ["USD": 50000, "ZAR": 950000, "AUD": 78000, "BTC": 1]
        )
    }
    
    func fluctuation(start: String, end: String, base: String, symbols: [String], force: Bool) async throws -> FixerFluctuationResponse {
        return FixerFluctuationResponse(
            success: true,
            start_date: nil,
            end_date: nil,
            base: "BTC",
            rates: [:]
        )
    }
}
