//
//  WalletRatesRepository.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation

public protocol WalletRatesRepository {
    
    func latest(base: String, symbols: [String], force: Bool) async throws -> FixerLatestResponse
    func fluctuation(start: String, end: String, base: String, symbols: [String], force: Bool) async throws -> FixerFluctuationResponse
}

public final class DefaultWalletRatesRepository: WalletRatesRepository {
    
    private let client = NetworkClient()
    private let cache = CacheManager()
    private let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    public func latest(base: String, symbols: [String], force: Bool) async throws -> FixerLatestResponse {
        if !force, let cached = cache.loadLatestResponse() {
            return cached
        }
        
        var comps = URLComponents(string: "https://api.apilayer.com/fixer/latest")!
        comps.queryItems = [
            URLQueryItem(name: "base", value: base),
            URLQueryItem(name: "symbols", value: symbols.joined(separator: ","))
        ]
        let data = try await client.get(url: comps.url!, headers: ["apikey": apiKey])
        
        let latestResponse = try JSONDecoder().decode(FixerLatestResponse.self, from: data)
        cache.saveLatestResponse(latestResponse)
        
        return latestResponse
    }

    public func fluctuation(start: String, end: String,base: String, symbols: [String], force: Bool) async throws -> FixerFluctuationResponse {
        if !force, let cached = cache.loadFluctuationResponse() {
            return cached
        }
        
        var comps = URLComponents(string: "https://api.apilayer.com/fixer/fluctuation")!
        comps.queryItems = [
            URLQueryItem(name: "start_date", value: start),
            URLQueryItem(name: "end_date", value: end),
            URLQueryItem(name: "base", value: base),
            URLQueryItem(name: "symbols", value: symbols.joined(separator: ","))
        ]
        let data = try await client.get(url: comps.url!, headers: ["apikey": apiKey])
        let fluctuationResponse = try JSONDecoder().decode(FixerFluctuationResponse.self, from: data)
        cache.saveFluctuationResponse(fluctuationResponse)
        
        return fluctuationResponse
    }
}

// MARK: - Cache Manager

private class CacheManager {
    
    static let shared = CacheManager()
    private let cachedKeyFixerLatest = "cachedFixerLatestResponse"
    private let cachedKeyFluctuation = "cachedFixerFluctuationResponse"
    
    func saveLatestResponse(_ latestResponse: FixerLatestResponse) {
        if let encoded = try? JSONEncoder().encode(latestResponse) {
            UserDefaults.standard.set(encoded, forKey: cachedKeyFixerLatest)
        }
    }
    
    func loadLatestResponse() -> FixerLatestResponse? {
        guard let data = UserDefaults.standard.data(forKey: cachedKeyFixerLatest),
              let latestResponse = try? JSONDecoder().decode(FixerLatestResponse.self, from: data) else {
            return nil
        }
        
        return latestResponse
    }
    
    func saveFluctuationResponse(_ fluctuationResponse: FixerFluctuationResponse) {
        if let encoded = try? JSONEncoder().encode(fluctuationResponse) {
            UserDefaults.standard.set(encoded, forKey: cachedKeyFluctuation)
        }
    }
    
    func loadFluctuationResponse() -> FixerFluctuationResponse? {
        guard let data = UserDefaults.standard.data(forKey: cachedKeyFluctuation),
              let fluctuationResponse = try? JSONDecoder().decode(FixerFluctuationResponse.self, from: data) else {
            return nil
        }
        
        return fluctuationResponse
    }
    
    func clearCache() {
        UserDefaults.standard.removeObject(forKey: cachedKeyFixerLatest)
        UserDefaults.standard.removeObject(forKey: cachedKeyFluctuation)
    }
}

