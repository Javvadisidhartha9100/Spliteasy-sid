//
//  HomePageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/17/26.
//

import SwiftUI

struct HomePageView: View {
    let friendsData: [BalanceItem]
    let headerTitle: String
    @Binding var selectedFilter: BalanceFilter
    let totalYouOwe: Double
    let totalYouAreOwed: Double
    let onSelectItem: (BalanceItem) -> Void

    @State private var showFilterSheet = false

    var body: some View {
        VStack(spacing: 0) {
            headerView(title: headerTitle)

            homeSummaryCard
                .padding(.top, 8)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(friendsData) { item in
                        Button {
                            onSelectItem(item)
                        } label: {
                            HomeBalanceRow(item: item)
                                .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer(minLength: 180)
                }
                .padding(.top, 10)
                .padding(.horizontal, 14)
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterPageView(selectedFilter: $selectedFilter)
        }
    }

    private var overallTitle: String {
        let net = totalYouAreOwed - totalYouOwe

        if net > 0 {
            return "You are owed $\(formattedAmount(net))"
        } else if net < 0 {
            return "You owe $\(formattedAmount(abs(net)))"
        } else {
            return "You are settled up"
        }
    }

    private func formattedAmount(_ value: Double) -> String {
        String(format: "%.2f", value)
    }

    private func headerView(title: String) -> some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 26, weight: .regular))
                    .foregroundColor(.black)
            }

            Spacer()

            Button(action: {}) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .italic()
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, -30)
        .padding(.bottom, 4)
    }

    private var homeSummaryCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Overall")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)

                    Text(overallTitle)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .minimumScaleFactor(0.85)
                        .lineLimit(1)
                }

                Spacer(minLength: 10)

                Button {
                    showFilterSheet = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(selectedFilter.tintColor)
                        .frame(width: 44, height: 44)
                        .background(Color.clear)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.top, 14)
            .padding(.bottom, 14)

            HStack(spacing: 10) {
                balancePill(
                    text: "Owe $\(formattedAmount(totalYouOwe))",
                    bg: Color.red.opacity(0.08),
                    textColor: Color.red.opacity(0.85),
                    icon: "arrow.down.right"
                )

                balancePill(
                    text: "Owed $\(formattedAmount(totalYouAreOwed))",
                    bg: Color.green.opacity(0.10),
                    textColor: Color.green.opacity(0.85),
                    icon: "arrow.up.right"
                )
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.purple.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: Color.purple.opacity(0.08), radius: 10, x: 0, y: 6)
        )
        .padding(.horizontal, 12)
    }

    private func balancePill(text: String, bg: Color, textColor: Color, icon: String) -> some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .semibold))

            Text(text)
                .font(.system(size: 13, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.85)
        }
        .foregroundColor(textColor)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(
            Capsule()
                .fill(bg)
        )
    }
}
