//
//  RegisterUseCase.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation

public protocol RegisterUseCase {
    
    func register(email:String, password:String) async throws
}

public final class DefaultRegisterUseCase: RegisterUseCase {
    
    private let repo: AuthRepository
    public init(repo: AuthRepository) {
        self.repo = repo
    }
    
    public func register(email: String, password: String) async throws {
        try await repo.register(email: email, password: password)
    }
}


