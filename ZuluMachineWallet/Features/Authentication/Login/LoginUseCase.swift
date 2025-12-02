//
//  LoginUseCase.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation

public protocol LoginUseCase {
    
    func login(email:String, password:String) async throws -> Bool
}

public final class DefaultLoginUseCase: LoginUseCase {
    
    private let repo: AuthRepository
    
    public init(repo: AuthRepository) {
        self.repo = repo
    }
    
    public func login(email: String, password: String) async throws -> Bool {
        try await repo.login(email: email, password: password)
    }
}


