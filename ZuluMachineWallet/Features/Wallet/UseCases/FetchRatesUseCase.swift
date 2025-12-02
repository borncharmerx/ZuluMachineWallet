//
//  FetchRatesUseCase.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation

public protocol WalletFetchRatesUseCase {
    
    func latest(base: String, symbols: [String], force: Bool) async throws -> FixerLatestResponse
    func fluctuation(start: String, end: String, base: String, symbols: [String], force: Bool) async throws -> FixerFluctuationResponse
}

public final class DefaultWalletFetchRatesUseCase: WalletFetchRatesUseCase {
    
    private let repo: WalletRatesRepository
    
    public init(repo: WalletRatesRepository) {
        self.repo = repo
    }
    
    public func latest(base: String, symbols: [String], force: Bool) async throws -> FixerLatestResponse {
        try await repo.latest(base: base, symbols: symbols, force: force)
    }
    
    public func fluctuation(start: String,
                            end: String,
                            base: String,
                            symbols: [String],
                            force: Bool) async throws -> FixerFluctuationResponse {
        try await repo.fluctuation(start: start, end: end, base: base, symbols: symbols, force: force)
    }
}


