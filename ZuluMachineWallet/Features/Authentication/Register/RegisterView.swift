//
//  RegisterView.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import SwiftUI

public struct RegisterView: View {
    
    @StateObject public var viewModel: RegisterViewModel
    
    public init(viewModel: RegisterViewModel) { _viewModel = StateObject(wrappedValue: viewModel) }
    
    public var body: some View {
        VStack(spacing: 16) {
            Text("register".localized).font(.largeTitle.bold())
            TextField("email".localized, text: $viewModel.email).textFieldStyle(.roundedBorder).autocapitalization(.none)
            SecureField("password".localized, text: $viewModel.password).textFieldStyle(.roundedBorder)
            SecureField("confirm_password".localized, text: $viewModel.confirmPassword).textFieldStyle(.roundedBorder)
            if let err = viewModel.errorMessage { Text(err).foregroundColor(.red) }
            Button(action: { Task { await viewModel.register() } }) { Text("register".localized) }.buttonStyle(PrimaryButtonStyle())
            Spacer()
        }.padding()
    }
}


