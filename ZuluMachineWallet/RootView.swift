//
//  RootView.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import SwiftUI

public struct RootView: View {
    
    @StateObject var router = AppRouter()
    public init() {}

    public var body: some View {
        Group {
            if router.isUnlocked {
                let apiKey = Bundle.main.object(forInfoDictionaryKey: "FIXER_API_KEY") as? String ?? ""
                let repo = DefaultWalletRatesRepository(apiKey: apiKey)
                let uc = DefaultWalletFetchRatesUseCase(repo: repo)
                WalletView(viewModel: WalletViewModel(useCase: uc))
            } else {
                let authRepo = DefaultAuthRepository()
                let loginUC = DefaultLoginUseCase(repo: authRepo)
                let loginVM = LoginViewModel(useCase: loginUC, router: router)
                LoginView(viewModel: loginVM)
            }
        }.environmentObject(router)
    }
}
