//
//  FilterPageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/17/26.
//

import SwiftUI

struct FilterPageView: View {
    @Binding var selectedFilter: BalanceFilter
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.gray.opacity(0.12)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                            .font(.system(size: 24, weight: .bold))
                            .italic()
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)

                Spacer()

                VStack(spacing: 18) {
                    filterButton(title: "None", value: .none)
                    filterButton(title: "Friends you owe", value: .youOwe)
                    filterButton(title: "Friends owes you", value: .owesYou)
                }

                Spacer()
            }
        }
        .presentationDetents([.fraction(1.0)])
        .presentationDragIndicator(.hidden)
    }

    private func filterButton(title: String, value: BalanceFilter) -> some View {
        Button {
            selectedFilter = value
        } label: {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .italic()
                .foregroundColor(selectedFilter == value ? Color.purple : .black)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
