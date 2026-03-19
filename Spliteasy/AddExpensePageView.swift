//
//  AddExpensePageView.swift
//  Spliteasy
//

import SwiftUI

struct AddExpensePageView: View {
    let selectedItem: BalanceItem?
    let onSaveExpense: (UUID, String, Double, BalanceDirection) -> Void
    @Binding var selectedTab: Tab

    @State private var withName: String = ""
    @State private var descriptionText: String = ""
    @State private var amountText: String = ""
    @State private var splitEquallySelected = true
    @State private var showCustomSplitSheet = false
    @State private var selectedCustomOption: CustomSplitOption = .youPaidSplitEqually

    var body: some View {
        ZStack {
            Color.gray.opacity(0.12)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()

                    Button {
                        saveExpense()
                    } label: {
                        Text("Save")
                            .font(.system(size: 24, weight: .bold))
                            .italic()
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                ScrollView {
                    VStack(alignment: .leading, spacing: 28) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text(withName)
                                .font(.system(size: 22, weight: .bold))
                                .italic()

                            Rectangle()
                                .fill(Color.black.opacity(0.3))
                                .frame(height: 1)
                        }

                        inputRow(
                            icon: "bag",
                            placeholder: "Enter description",
                            text: $descriptionText
                        )

                        inputRow(
                            icon: "dollarsign.square.fill",
                            placeholder: "Enter amount",
                            text: $amountText
                        )

                        VStack(spacing: 18) {
                            buttonStyle(
                                title: "Split equally",
                                isSelected: splitEquallySelected
                            ) {
                                splitEquallySelected = true
                                selectedCustomOption = .youPaidSplitEqually
                                saveExpense()
                            }

                            buttonStyle(
                                title: customTitle,
                                isSelected: !splitEquallySelected
                            ) {
                                splitEquallySelected = false
                                showCustomSplitSheet = true
                            }
                        }

                        if let amount = Double(amountText), amount > 0 {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Summary")
                                    .font(.headline)

                                Text(summaryText)
                                    .font(.title3)
                                    .foregroundColor(summaryColor)
                            }
                        }

                        Spacer(minLength: 100)
                    }
                    .padding(20)
                }
            }
        }
        .sheet(isPresented: $showCustomSplitSheet) {
            CustomSplitPageView(
                selectedOption: $selectedCustomOption,
                enteredAmount: Double(amountText) ?? 0,
                participantCount: participantCount
            )
        }
        .onAppear {
            withName = selectedItem?.name ?? ""
        }
    }
}

extension AddExpensePageView {
    private var participantCount: Int {
        max(selectedItem?.participantCount ?? 2, 2)
    }

    private var enteredAmount: Double {
        Double(amountText) ?? 0
    }

    private var customTitle: String {
        splitEquallySelected ? "custom" : selectedCustomOption.title
    }

    private var calculatedAmount: Double {
        guard enteredAmount > 0 else { return 0 }

        if splitEquallySelected {
            return enteredAmount / Double(participantCount)
        }

        switch selectedCustomOption {
        case .youPaidSplitEqually, .theyPaidSplitEqually:
            return enteredAmount / Double(participantCount)
        case .youPaidTheyOweYouFull, .theyPaidYouOweFull:
            return enteredAmount
        }
    }

    private var activeDirection: BalanceDirection {
        if splitEquallySelected {
            return .owesYou
        }

        switch selectedCustomOption {
        case .youPaidSplitEqually, .youPaidTheyOweYouFull:
            return .owesYou
        case .theyPaidSplitEqually, .theyPaidYouOweFull:
            return .youOwe
        }
    }

    private var summaryText: String {
        let value = String(format: "%.2f", calculatedAmount)

        switch activeDirection {
        case .owesYou:
            return "They owe you $\(value)"
        case .youOwe:
            return "You owe $\(value)"
        }
    }

    private var summaryColor: Color {
        activeDirection == .owesYou ? .green : .red
    }

    private func saveExpense() {
        guard let selectedItem else { return }
        guard !descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        guard calculatedAmount > 0 else { return }

        onSaveExpense(
            selectedItem.id,
            descriptionText,
            calculatedAmount,
            activeDirection
        )

        descriptionText = ""
        amountText = ""
        selectedTab = .home
    }
}

extension AddExpensePageView {
    private func inputRow(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)

            VStack(alignment: .leading) {
                TextField(placeholder, text: text)
                    .font(.system(size: 18, weight: .bold))
                    .italic()

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black.opacity(0.3))
            }
        }
    }

    private func buttonStyle(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .italic()
                .foregroundColor(isSelected ? .purple : .black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.purple.opacity(0.1) : Color.white)
                )
        }
        .padding(.horizontal, 40)
    }
}
