import SwiftUI

struct AddExpensePageView: View {
    let selectedItem: BalanceItem?
    let onSaveExpense: (UUID, String, Double, BalanceDirection, GroupExpenseDraft?) -> Void
    @Binding var selectedTab: Tab

    @State private var withName: String = ""
    @State private var descriptionText: String = ""
    @State private var amountText: String = ""

    @State private var splitEquallySelected = true
    @State private var showCustomSplitSheet = false
    @State private var selectedCustomOption: CustomSplitOption = .youPaidSplitEqually

    @State private var selectedPaidByPeople: Set<String> = ["YOU"]
    @State private var selectedSplitPeople: Set<String> = []
    @State private var showPaidByPicker = false
    @State private var showSplitPicker = false

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
                    VStack(alignment: .leading, spacing: 18) {
                        nameCard
                        cameraCard

                        inputCard(
                            icon: "bag",
                            placeholder: "Enter description",
                            text: $descriptionText
                        )

                        amountCard
                        splitButtonsSection

                        if enteredAmount > 0 {
                            summaryCard
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
                enteredAmount: enteredAmount,
                participantCount: participantCount
            )
        }
        .sheet(isPresented: $showPaidByPicker) {
            GroupMemberPickerSheet(
                title: "Paid by",
                people: groupPeople,
                selectedPeople: $selectedPaidByPeople
            )
        }
        .sheet(isPresented: $showSplitPicker) {
            GroupMemberPickerSheet(
                title: "Split with",
                people: groupPeople,
                selectedPeople: $selectedSplitPeople
            )
        }
        .onAppear {
            withName = selectedItem?.name ?? ""
            if isGroup {
                selectedSplitPeople = Set(groupPeople)
                selectedPaidByPeople = ["YOU"]
            }
        }
    }

    private var isGroup: Bool {
        selectedItem?.kind == .group
    }

    private var groupPeople: [String] {
        guard let selectedItem, selectedItem.kind == .group else { return [] }
        return ["YOU"] + selectedItem.memberNames
    }

    private var effectiveSplitPeople: [String] {
        let values = Array(selectedSplitPeople)
        return values.isEmpty ? groupPeople : values.sorted()
    }

    private var effectivePaidByPeople: [String] {
        let values = Array(selectedPaidByPeople)
        return values.isEmpty ? ["YOU"] : values.sorted()
    }

    private var headerView: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    selectedTab = selectedItem?.kind == .group ? .friends : .home
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
                    .opacity(canSaveExpense ? 1 : 0.65)
            }
            .buttonStyle(.plain)
            .disabled(!canSaveExpense)
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

    private var cameraCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Receipt")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.gray)

            Button {
                print("Camera tapped")
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 16, weight: .bold))

                    Text("Take a picture")
                        .font(.system(size: 16, weight: .bold))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 18)
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
                if isGroup {
                    selectedPaidByPeople = ["YOU"]
                    selectedSplitPeople = Set(groupPeople)
                } else {
                    selectedCustomOption = .youPaidSplitEqually
                }
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

            if isGroup {
                groupCustomCard
            } else {
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
    }

    private var groupCustomCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Customise")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(red: 0.18, green: 0.18, blue: 0.22))

            HStack(spacing: 8) {
                Text("Paid by")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)

                Button {
                    splitEquallySelected = false
                    showPaidByPicker = true
                } label: {
                    Text(paidByTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.53, green: 0.28, blue: 0.95))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.purple.opacity(0.08))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                Text("and")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)

                Button {
                    splitEquallySelected = false
                    showSplitPicker = true
                } label: {
                    Text(splitTitle)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.53, green: 0.28, blue: 0.95))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.purple.opacity(0.08))
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)

                Spacer()
            }

            Text("The payer does not need to be included in the split.")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.purple.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: Color.purple.opacity(0.07), radius: 10, x: 0, y: 5)
        )
    }

    private var summaryCard: some View {
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

    private var paidByTitle: String {
        let values = effectivePaidByPeople
        return values.count == 1 ? values[0] : "\(values.count) people"
    }

    private var splitTitle: String {
        let values = effectiveSplitPeople
        return values.count == 1 ? "SPLIT \(values[0])" : "SPLIT \(values.count)"
    }

    private var groupYourPaidShare: Double {
        guard enteredAmount > 0 else { return 0 }
        let payers = max(effectivePaidByPeople.count, 1)
        return effectivePaidByPeople.contains("YOU") ? enteredAmount / Double(payers) : 0
    }

    private var groupYourSplitShare: Double {
        guard enteredAmount > 0 else { return 0 }
        let splitters = max(effectiveSplitPeople.count, 1)
        return effectiveSplitPeople.contains("YOU") ? enteredAmount / Double(splitters) : 0
    }

    private var groupNetAmount: Double {
        groupYourPaidShare - groupYourSplitShare
    }

    private var customTitle: String {
        splitEquallySelected ? "Custom split" : selectedCustomOption.title
    }

    private var friendCalculatedAmount: Double {
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

    private var friendDirection: BalanceDirection {
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

    private var calculatedAmount: Double {
        isGroup ? abs(groupNetAmount) : friendCalculatedAmount
    }

    private var activeDirection: BalanceDirection {
        isGroup ? (groupNetAmount >= 0 ? .owesYou : .youOwe) : friendDirection
    }

    private var summaryText: String {
        let value = String(format: "%.2f", calculatedAmount)

        if isGroup {
            if groupNetAmount > 0 {
                return "You should get back $\(value)"
            } else if groupNetAmount < 0 {
                return "You owe $\(value)"
            } else {
                return "You are settled up"
            }
        }

        switch activeDirection {
        case .owesYou:
            return "They owe you $\(value)"
        case .youOwe:
            return "You owe $\(value)"
        }
    }

    private var summaryColor: Color {
        if calculatedAmount == 0 {
            return .gray
        }
        return activeDirection == .owesYou ? .green.opacity(0.9) : .red.opacity(0.85)
    }

    private var canSaveExpense: Bool {
        guard selectedItem != nil else { return false }
        guard !descriptionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }
        guard enteredAmount > 0 else { return false }

        if isGroup && !splitEquallySelected {
            return !effectivePaidByPeople.isEmpty && !effectiveSplitPeople.isEmpty
        }

        return true
    }

    private func saveExpense() {
        guard let selectedItem else { return }
        guard canSaveExpense else { return }

        let draft: GroupExpenseDraft? = isGroup ? GroupExpenseDraft(
            paidBy: effectivePaidByPeople,
            splitWith: effectiveSplitPeople,
            yourNetAmount: groupNetAmount
        ) : nil

        onSaveExpense(
            selectedItem.id,
            descriptionText,
            calculatedAmount,
            activeDirection,
            draft
        )

        descriptionText = ""
        amountText = ""
        selectedTab = selectedItem.kind == .group ? .friends : .home
    }
}

struct GroupMemberPickerSheet: View {
    let title: String
    let people: [String]
    @Binding var selectedPeople: Set<String>
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)

                Spacer()

                Button("Done") {
                    dismiss()
                }
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.purple)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            Divider()

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(people, id: \.self) { person in
                        Button {
                            toggle(person)
                        } label: {
                            HStack {
                                Text(person)
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.black)

                                Spacer()

                                Image(systemName: selectedPeople.contains(person) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedPeople.contains(person) ? .purple : .gray.opacity(0.5))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                        }
                        .buttonStyle(.plain)

                        Divider()
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func toggle(_ person: String) {
        if selectedPeople.contains(person) {
            if selectedPeople.count > 1 {
                selectedPeople.remove(person)
            }
        } else {
            selectedPeople.insert(person)
        }
    }
}
