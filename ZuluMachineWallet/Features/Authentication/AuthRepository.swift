//
//  AuthRepository.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation

public protocol AuthRepository {
    
    func register(email: String, password: String) async throws
    func login(email: String, password: String) async throws -> Bool
}

public final class DefaultAuthRepository: AuthRepository {
    
    public func register(email: String, password: String) async throws {
        let ok = SecureStore.shared.savePassword(password, for: email)
        if !ok { throw NSError(domain:"AuthRepo", code:-1, userInfo:[NSLocalizedDescriptionKey:"Failed to save"]) }
    }
    
    public func login(email: String, password: String) async throws -> Bool {
        guard let stored = SecureStore.shared.getPassword(for: email) else { return false }
        return stored == password
    }
}


