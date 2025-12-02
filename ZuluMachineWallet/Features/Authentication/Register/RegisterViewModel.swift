//
//  RegisterViewModel.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation
import Combine

@MainActor
public final class RegisterViewModel: ObservableObject {
    
    @Published public var email = ""
    @Published public var password = ""
    @Published public var confirmPassword = ""
    @Published public var errorMessage: String?
    @Published public var router: AppRouter
    @Published public var isPresented: Bool

    private let useCase: RegisterUseCase

    public init(useCase: RegisterUseCase, router: AppRouter, isPresented: Bool) {
        self.useCase = useCase
        self.router = router
        self.isPresented = isPresented
    }

    public func register() async {
        guard password == confirmPassword else { errorMessage = "Passwords do not match"; return }
        do {
            try await useCase.register(email: email, password: password)
            Haptics.success()
            isPresented = false
            router.isUnlocked = true
        } catch {
            errorMessage = error.localizedDescription
            Haptics.error()
        }
    }
}


