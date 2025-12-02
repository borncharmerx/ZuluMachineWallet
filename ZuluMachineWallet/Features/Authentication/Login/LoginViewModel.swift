//
//  LoginViewModel.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation
import Combine

@MainActor
public final class LoginViewModel: ObservableObject {
    
    @Published public var email = ""
    @Published public var password = ""
    @Published public var errorMessage: String?
    @Published public var router: AppRouter

    private let useCase: LoginUseCase
    private let biometric = BiometricAuthService()

    public init(useCase: LoginUseCase, router: AppRouter) {
        self.useCase = useCase
        self.router = router
    }

    public func login() async {
        do {
            let ok = try await useCase.login(email: email, password: password)
            if !ok { errorMessage = "invalid_credentials".localized }
            else {
                Haptics.success()
                router.isUnlocked = true
            }
        } catch {
            errorMessage = error.localizedDescription
            Haptics.error()
        }
    }

    public func loginWithBiometrics() async {
        do {
            try await biometric.authenticate()
            if let password = SecureStore.shared.getPassword(for: email) {
                guard try await useCase.login(email: email, password: password) else {
                    errorMessage = "invalid_credentials".localized
                    Haptics.error()
                    return
                }
                Haptics.success()
                router.isUnlocked = true
            } else {
                errorMessage = "no_credentials".localized
                Haptics.error()
            }
        } catch {
            errorMessage = error.localizedDescription
            Haptics.error()
        }
    }
}


