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

    private let filterOptions: [BalanceFilter] = [
        .none,
        .youOwe,
        .owesYou
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(filterOptions, id: \.self) { filter in
                    Button {
                        selectedFilter = filter
                        dismiss()
                    } label: {
                        HStack {
                            Text(filter.title)
                                .font(.system(size: 20))
                                .foregroundColor(.blue)

                            Spacer()

                            if selectedFilter == filter {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.white)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Set filter")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
