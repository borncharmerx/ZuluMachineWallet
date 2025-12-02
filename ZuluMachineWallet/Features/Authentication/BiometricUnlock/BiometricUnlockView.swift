//
//  BiometricUnlockView.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import SwiftUI

public struct BiometricUnlockView: View {
    
    @StateObject public var viewModel: BiometricUnlockViewModel
    public var onUnlock: () -> Void

    public init(viewModel: BiometricUnlockViewModel, onUnlock: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel); self.onUnlock = onUnlock
    }

    public var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "faceid").font(.system(size: 80)).foregroundColor(.blue)
                .scaleEffect(1.0)
                .animation(.spring(), value: 1.0)
            Text("unlock_wallet".localized).font(.title2)
            if let err = viewModel.errorMessage { Text(err).foregroundColor(.red) }
            Button {
                Task {
                    await viewModel.unlock()
                    if viewModel.errorMessage == nil { onUnlock() }
                }
            } label: {
                Text("login_faceid".localized)
            }.buttonStyle(PrimaryButtonStyle()).disabled(!BiometricAuthService().canAuthenticate())
        }.padding().task { await viewModel.unlockAutomatically(); if viewModel.errorMessage==nil { onUnlock() } }
    }
}


