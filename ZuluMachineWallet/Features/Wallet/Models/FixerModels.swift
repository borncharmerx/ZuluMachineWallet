//
//  FixerModels.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation

public struct FixerLatestResponse: Codable {
    
    public let success: Bool?
    public let timestamp: Int?
    public let base: String
    public let date: String
    public let rates: [String: Double]
}

public struct FixerFluctuationResponse: Codable {
    
    public let success: Bool?
    public let start_date: String?
    public let end_date: String?
    public let base: String
    public let rates: [String: FixerFluctuationRate]
}

public struct FixerFluctuationRate: Codable {
    
    public let start_rate: Double?
    public let end_rate: Double?
    public let change: Double?
    public let change_pct: Double?
}


