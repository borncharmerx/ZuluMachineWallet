//
//  SecureStore.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation
import Security

public final class SecureStore {
    
    public static let shared = SecureStore()

    public func savePassword(_ password: String, for email: String) -> Bool {
        guard let data = password.data(using: .utf8) else { return false }
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    public func getPassword(for email: String) -> String? {
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var res: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &res)
        if status == errSecSuccess, let data = res as? Data { return String(decoding: data, as: UTF8.self) }
        return nil
    }
}
