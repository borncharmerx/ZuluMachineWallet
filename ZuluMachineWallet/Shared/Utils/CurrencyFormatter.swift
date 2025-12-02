//
//  CurrencyFormatter.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation

public struct CurrencyFormatter {
    
    public static func format(number: NSDecimalNumber, currency: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        if currency == "BTC" {
            numberFormatter.maximumFractionDigits = 8
            numberFormatter.currencySymbol = "BTC "
            return numberFormatter.string(from: number) ?? number.stringValue
        }
        numberFormatter.currencyCode = currency
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter.string(from: number) ?? number.stringValue
    }
}


