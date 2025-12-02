//
//  LoginView.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import SwiftUI

public struct LoginView: View {
    
    @StateObject public var viewModel: LoginViewModel
    @State private var showRegister = false

    public init(viewModel: LoginViewModel) { _viewModel = StateObject(wrappedValue: viewModel) }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Text("welcome_back".localized).font(.largeTitle.bold())
                VStack(spacing: 12) {
                    TextField("email".localized, text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                    SecureField("password".localized, text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                }
                if let err = viewModel.errorMessage { Text(err).foregroundColor(.red) }
                Button(action: { Task { await viewModel.login() } }) {
                    Text("login".localized)
                }.buttonStyle(PrimaryButtonStyle())
                Button(action: { Task { await viewModel.loginWithBiometrics() } }) {
                    Text("login_faceid".localized)
                }.disabled(!BiometricAuthService().canAuthenticate())
                Spacer()
                Button("create_account".localized) { showRegister = true }
                .sheet(isPresented: $showRegister) {
                    let repo = DefaultAuthRepository()
                    let uc = DefaultRegisterUseCase(repo: repo)
                    RegisterView(viewModel: RegisterViewModel(useCase: uc, router: viewModel.router, isPresented: showRegister))
                }
            }.padding()
        }
    }
}
