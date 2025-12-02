//
//  WalletViewModelTests.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import XCTest
@testable import ZuluMachineWallet

@MainActor
final class WalletViewModelTests: XCTestCase {
    
    func testDisplayItemsPopulated() async throws {
        let uc = MockWalletUseCase()
        let vm = WalletViewModel(useCase: uc)
        vm.btcAmount = "0.1"
        await vm.load(force: true)
        XCTAssertTrue(vm.displayItems.count >= 1)
    }
}
