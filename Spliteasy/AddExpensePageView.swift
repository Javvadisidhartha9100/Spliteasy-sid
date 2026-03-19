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
                    .padding(.top, 6)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        nameCard

                        inputCard(
                            icon: "bag",
                            placeholder: "Enter description",
                            text: $descriptionText
                        )

                        amountCard

                        splitButtonsSection

                        if let amount = Double(amountText), amount > 0 {
                            summaryCard(amount: amount)
                        }

                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
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

    private var headerView: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    selectedTab = .home
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white)
                        .frame(width: 46, height: 46)
                        .shadow(color: Color.purple.opacity(0.08), radius: 8, x: 0, y: 4)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                saveExpense()
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
                    .shadow(color: Color.purple.opacity(0.18), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
    }

    private var nameCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("With")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)

            Text(withName)
                .font(.system(size: 28, weight: .bold))
                .italic()
                .foregroundColor(Color(red: 0.10, green: 0.14, blue: 0.22))
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.purple.opacity(0.10), lineWidth: 1)
                )
                .shadow(color: Color.purple.opacity(0.08), radius: 10, x: 0, y: 6)
        )
    }

    private func inputCard(icon: String, placeholder: String, text: Binding<String>) -> some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.purple.opacity(0.10))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundColor(Color(red: 0.53, green: 0.28, blue: 0.95))
                )

            VStack(alignment: .leading, spacing: 8) {
                TextField(placeholder, text: text)
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
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.purple.opacity(0.10), lineWidth: 1)
                )
                .shadow(color: Color.purple.opacity(0.07), radius: 10, x: 0, y: 6)
        )
    }

    private var amountCard: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.purple.opacity(0.10))
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "dollarsign.square.fill")
                        .font(.system(size: 21, weight: .semibold))
                        .foregroundColor(Color(red: 0.53, green: 0.28, blue: 0.95))
                )

            VStack(alignment: .leading, spacing: 8) {
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
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.purple.opacity(0.10), lineWidth: 1)
                )
                .shadow(color: Color.purple.opacity(0.07), radius: 10, x: 0, y: 6)
        )
    }

    private var splitButtonsSection: some View {
        VStack(spacing: 16) {
            Button {
                splitEquallySelected = true
                selectedCustomOption = .youPaidSplitEqually
            } label: {
                Text("Split equally")
                    .font(.system(size: 21, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.75, green: 0.30, blue: 0.97),
                                Color(red: 0.60, green: 0.24, blue: 0.90)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .shadow(color: Color.purple.opacity(0.18), radius: 10, x: 0, y: 5)
            }
            .buttonStyle(.plain)

            Button {
                splitEquallySelected = false
                showCustomSplitSheet = true
            } label: {
                Text(customTitle)
                    .font(.system(size: 21, weight: .bold))
                    .foregroundColor(Color(red: 0.18, green: 0.18, blue: 0.22))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.purple.opacity(0.12), lineWidth: 1)
                    )
                    .shadow(color: Color.purple.opacity(0.07), radius: 10, x: 0, y: 5)
            }
            .buttonStyle(.plain)
        }
    }

    private func summaryCard(amount: Double) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Summary")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.gray)

            Text(summaryText)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(summaryColor)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.purple.opacity(0.10), lineWidth: 1)
                )
                .shadow(color: Color.purple.opacity(0.07), radius: 10, x: 0, y: 5)
        )
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
        splitEquallySelected ? "Custom split" : selectedCustomOption.title
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
        activeDirection == .owesYou
            ? Color.green.opacity(0.9)
            : Color.red.opacity(0.85)
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
#Preview {
    ContentView()
}

