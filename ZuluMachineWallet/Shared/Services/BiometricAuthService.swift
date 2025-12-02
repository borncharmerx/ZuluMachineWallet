//
//  BiometricAuthService.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import Foundation
import LocalAuthentication
import Combine

public final class BiometricAuthService {
    public init() {}

    public func canAuthenticate() -> Bool {
        var err: NSError?
        return LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &err)
    }

    public func authenticate(reason: String = "Unlock ZuluMachine Wallet") async throws {
        let context = LAContext()
        return try await withCheckedThrowingContinuation { cont in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { ok, err in
                if ok {
                    cont.resume()
                } else {
                    cont.resume(throwing: err ?? NSError())
                }
            }
        }
    }
}


