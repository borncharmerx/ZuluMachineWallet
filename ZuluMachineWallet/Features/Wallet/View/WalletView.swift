//
//  WalletView.swift
//  ZuluMachineWallet
//
//  Created by Sipho Motha on 2025/11/28.
//

import SwiftUI
import Lottie

public struct WalletView: View {
    
    @StateObject public var viewModel: WalletViewModel
    @State private var isEditingBTC = false
    @State private var tempBTCAmount = ""
    @State private var showToast = false

    public init(viewModel: WalletViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                if viewModel.isLoading {
                    VStack {
                        LottieView(animation: .named("loading_indicator"))
                            .playing(loopMode: .loop)
                    }
                }

                VStack(spacing: 16) {
                    // BTC header card (gradient)
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("your_bitcoin".localized)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("\(viewModel.btcAmount) \(viewModel.baseCurrency)")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            Button {
                                tempBTCAmount = viewModel.btcAmount
                                isEditingBTC = true
                            } label: {
                                Image(systemName: "pencil")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(.white.opacity(0.12))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [ZuluPalette.primary, ZuluPalette.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(16)
                    .padding(.horizontal)

                    // list
                    ScrollView {
                        Spacer()
                        VStack(spacing: 12) {
                            ForEach(viewModel.displayItems) { item in
                                CurrencyCard(item: item)
                                    .onTapGesture { Haptics.success() }
                            }
                        }.padding(.horizontal)
                    }

                    Spacer()
                    VStack {
                        Text(viewModel.lastUpdatedDate ?? "")
                            .font(.footnote.bold())
                            .foregroundColor(.gray)
                    }
                }
                .navigationTitle("wallet_title".localized)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { Task { await viewModel.load(force: true) } }) {
                            Image(systemName: "arrow.clockwise.circle.fill").font(.title2)
                        }
                        .accessibilityLabel("refresh".localized)
                    }
                }
                .task { await viewModel.load(force: false) }
                .sheet(isPresented: $isEditingBTC) {
                    NavigationStack {
                        Form {
                            Section("update_btc".localized) {
                                TextField("0.0", text: $tempBTCAmount).keyboardType(.decimalPad)
                            }
                        }
                        .navigationTitle("edit_btc".localized)
                        .toolbar {
                            ToolbarItem(placement:.cancellationAction) {
                                Button("cancel".localized) { isEditingBTC = false }
                            }
                            ToolbarItem(placement:.confirmationAction) {
                                Button("save".localized) {
                                    viewModel.btcAmount = tempBTCAmount
                                    viewModel.savePersisted()
                                    Task { await viewModel.load(force: false) }
                                    isEditingBTC = false
                                }
                            }
                        }
                    }
                }
            }

            // toast
            if let text = viewModel.toastText {
                ToastView(text)
                    .padding()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear { DispatchQueue.main.asyncAfter(deadline:.now() + 2) {
                        viewModel.toastText = nil
                    } }
            }
        }
    }
}

struct CurrencyCard: View {
    
    let item: CurrencyDisplayItem

    var body: some View {
        HStack {
            VStack(alignment:.leading) {
                Text(item.currency)
                    .font(.headline)
                
                Text(item.formatted)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if let pct = item.changePct {
                Text(String(format: "%+.2f%%", pct))
                    .foregroundColor(pct >= 0 ? .green : .red)
            } else {
                Text("—")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
