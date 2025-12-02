//
//  Theme.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import SwiftUI

public enum ZuluPalette {
    
    public static let primary = Color("ZuluPrimary")
    public static let accent = Color("ZuluAccent")
    public static let background = Color(uiColor: .systemGroupedBackground)
}

public struct PrimaryButtonStyle: ButtonStyle {
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12).fill(ZuluPalette.primary))
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}


