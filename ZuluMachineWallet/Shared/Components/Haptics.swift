//
//  Haptics.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import UIKit

public struct Haptics {
    
    public static func success() { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
    public static func error() { UINotificationFeedbackGenerator().notificationOccurred(.error) }
}


