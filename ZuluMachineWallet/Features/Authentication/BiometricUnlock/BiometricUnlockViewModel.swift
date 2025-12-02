//
//  BiometricUnlockViewModel.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation
import Combine

@MainActor
public final class BiometricUnlockViewModel: ObservableObject {
    
    @Published public var errorMessage: String?
    private let biometric = BiometricAuthService()
    private let loginUseCase: LoginUseCase
    private let email: String

    public init(email: String, loginUseCase: LoginUseCase) {
        self.email = email
        self.loginUseCase = loginUseCase
    }

    public func unlock() async {
        do {
            try await biometric.authenticate()
            if let pw = SecureStore.shared.getPassword(for: email) {
                _ = try await loginUseCase.login(email: email, password: pw)
            } else {
                errorMessage = "no_credentials".localized
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    public func unlockAutomatically() async {
        if biometric.canAuthenticate() {
            await unlock()
        }
    }
}


