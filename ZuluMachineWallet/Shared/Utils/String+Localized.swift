//
//  String+Localized.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation

public extension String {
    
    var localized: String { NSLocalizedString(self, comment: "") }
}


