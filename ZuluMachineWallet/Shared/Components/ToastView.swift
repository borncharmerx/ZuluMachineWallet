//
//  ToastView.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import SwiftUI

public struct ToastView: View {
    
    public let text: String
    public init(_ text: String) { self.text = text }

    public var body: some View {
        Text(text)
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .shadow(radius: 8)
            .accessibilityLabel(text)
    }
}


