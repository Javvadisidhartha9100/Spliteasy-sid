//
//  SettleUpPageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/24/26.
//

import SwiftUI

struct SettleUpPageView: View {
    let friend: BalanceItem
    let onBack: () -> Void
    let onSave: (UUID, Double, String) -> Void

    @State private var amountText: String = ""
    @State private var selectedMethod: String = ""
    @State private var showMethodPicker = false

    private let cardBorder = Color.purple.opacity(0.12)
    private let cardShadow = Color.purple.opacity(0.08)
    private let themePurple = Color(red: 0.53, green: 0.28, blue: 0.95)

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.95, blue: 1.0),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                headerView
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        friendCard
                        outstandingCard
                        amountCard
                        paymentMethodCard

                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .confirmationDialog("Payment Method", isPresented: $showMethodPicker, titleVisibility: .visible) {
            Button("Cash") { selectedMethod = "Cash" }
            Button("Transfer") { selectedMethod = "Transfer" }
            Button("Cancel", role: .cancel) { }
        }
        .onAppear {
            amountText = String(format: "%.2f", friend.amount)
        }
    }

    private var headerView: some View {
        HStack {
            Button {
                onBack()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white)
                        .frame(width: 46, height: 46)
                        .shadow(color: cardShadow, radius: 8, x: 0, y: 4)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Settle Up")
                .font(.system(size: 24, weight: .bold))
                .italic()
                .foregroundColor(.black)

            Spacer()

            Button {
                saveSettle()
            } label: {
                Text("Save")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.54, green: 0.25, blue: 0.95),
                                Color(red: 0.43, green: 0.20, blue: 0.86)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .opacity(canSave ? 1 : 0.65)
            }
            .buttonStyle(.plain)
            .disabled(!canSave)
        }
    }

    private var friendCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Friend")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)

            Text(friend.name)
                .font(.system(size: 28, weight: .bold))
                .italic()
                .foregroundColor(Color(red: 0.10, green: 0.14, blue: 0.22))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(cardBorder, lineWidth: 1)
                )
                .shadow(color: cardShadow, radius: 10, x: 0, y: 6)
        )
    }

    private var outstandingCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Outstanding")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)

            Text(balanceText)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(friend.direction == .owesYou ? .green.opacity(0.85) : .red.opacity(0.85))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(cardBorder, lineWidth: 1)
                )
                .shadow(color: cardShadow, radius: 10, x: 0, y: 6)
        )
    }

    private var amountCard: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.purple.opacity(0.10))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "dollarsign.square.fill")
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundColor(themePurple)
                )

            VStack(alignment: .leading, spacing: 8) {
                Text("Enter amount")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)

                TextField("Enter amount", text: $amountText)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)

                Rectangle()
                    .fill(Color.purple.opacity(0.15))
                    .frame(height: 1)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(cardBorder, lineWidth: 1)
                )
                .shadow(color: cardShadow, radius: 10, x: 0, y: 6)
        )
    }

    private var paymentMethodCard: some View {
        Button {
            showMethodPicker = true
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Payment Method")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)

                    Text(selectedMethod.isEmpty ? "Choose payment method" : selectedMethod)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(selectedMethod.isEmpty ? .gray : .black)
                }

                Spacer()

                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(cardBorder, lineWidth: 1)
                    )
                    .shadow(color: cardShadow, radius: 10, x: 0, y: 6)
            )
        }
        .buttonStyle(.plain)
    }

    private var enteredAmount: Double {
        Double(amountText) ?? 0
    }

    private var canSave: Bool {
        enteredAmount > 0 && !selectedMethod.isEmpty
    }

    private var balanceText: String {
        let value = String(format: "%.2f", friend.amount)
        return friend.direction == .owesYou ? "They owe you $\(value)" : "You owe $\(value)"
    }

    private func saveSettle() {
        guard canSave else { return }
        onSave(friend.id, enteredAmount, selectedMethod)
    }
}
