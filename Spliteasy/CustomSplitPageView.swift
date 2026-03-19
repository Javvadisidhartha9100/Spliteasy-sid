//
//  CustomSplitPageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/19/26.
//

import SwiftUI

enum CustomSplitOption: String, CaseIterable, Hashable {
    case youPaidSplitEqually
    case youPaidTheyOweYouFull
    case theyPaidSplitEqually
    case theyPaidYouOweFull

    var title: String {
        switch self {
        case .youPaidSplitEqually:
            return "You paid split equally"
        case .youPaidTheyOweYouFull:
            return "You paid they owe you full"
        case .theyPaidSplitEqually:
            return "They paid split equally"
        case .theyPaidYouOweFull:
            return "They paid you owe full"
        }
    }

    var isYouPaid: Bool {
        switch self {
        case .youPaidSplitEqually, .youPaidTheyOweYouFull:
            return true
        case .theyPaidSplitEqually, .theyPaidYouOweFull:
            return false
        }
    }
}

struct CustomSplitPageView: View {
    @Binding var selectedOption: CustomSplitOption
    let enteredAmount: Double
    let participantCount: Int

    @Environment(\.dismiss) private var dismiss

    private var calculatedAmount: Double {
        switch selectedOption {
        case .youPaidSplitEqually, .theyPaidSplitEqually:
            return participantCount > 0 ? enteredAmount / Double(participantCount) : enteredAmount
        case .youPaidTheyOweYouFull, .theyPaidYouOweFull:
            return enteredAmount
        }
    }

    private var amountPreviewText: String {
        let formatted = String(format: "%.2f", calculatedAmount)

        switch selectedOption {
        case .youPaidSplitEqually, .youPaidTheyOweYouFull:
            return "They owe you $\(formatted)"
        case .theyPaidSplitEqually, .theyPaidYouOweFull:
            return "You owe $\(formatted)"
        }
    }

    private var amountPreviewColor: Color {
        switch selectedOption {
        case .youPaidSplitEqually, .youPaidTheyOweYouFull:
            return .green
        case .theyPaidSplitEqually, .theyPaidYouOweFull:
            return .red
        }
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.18)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                VStack(spacing: 0) {
                    Text("Custom split")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 18)
                        .padding(.bottom, 16)

                    Divider()

                    ForEach(CustomSplitOption.allCases, id: \.self) { option in
                        Button {
                            selectedOption = option
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(option.title)
                                        .font(.system(size: 20))
                                        .foregroundColor(.blue)
                                        .multilineTextAlignment(.leading)

                                    if selectedOption == option && enteredAmount > 0 {
                                        Text(previewText(for: option))
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(previewColor(for: option))
                                    }
                                }

                                Spacer()

                                if selectedOption == option {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 20, weight: .semibold))
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                        }
                        .buttonStyle(.plain)

                        if option != CustomSplitOption.allCases.last {
                            Divider()
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))

                Button {
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
        }
    }

    private func previewText(for option: CustomSplitOption) -> String {
        let value: Double
        switch option {
        case .youPaidSplitEqually, .theyPaidSplitEqually:
            value = participantCount > 0 ? enteredAmount / Double(participantCount) : enteredAmount
        case .youPaidTheyOweYouFull, .theyPaidYouOweFull:
            value = enteredAmount
        }

        let formatted = String(format: "%.2f", value)

        switch option {
        case .youPaidSplitEqually, .youPaidTheyOweYouFull:
            return "They owe you $\(formatted)"
        case .theyPaidSplitEqually, .theyPaidYouOweFull:
            return "You owe $\(formatted)"
        }
    }

    private func previewColor(for option: CustomSplitOption) -> Color {
        switch option {
        case .youPaidSplitEqually, .youPaidTheyOweYouFull:
            return .green
        case .theyPaidSplitEqually, .theyPaidYouOweFull:
            return .red
        }
    }
}
