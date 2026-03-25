import SwiftUI

struct HomePageView: View {
    let friendsData: [BalanceItem]
    let headerTitle: String
    @Binding var selectedFilter: BalanceFilter
    let monthlyLimit: Double
    let monthlySpent: Double
    let onSelectItem: (BalanceItem) -> Void
    let onSettleUpTap: () -> Void
    @Binding var showThemeMenu: Bool

    @State private var showFilterSheet = false
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            headerView(title: headerTitle)

            searchBar
                .padding(.horizontal, 16)
                .padding(.top, 8)

            monthlyLimitCard
                .padding(.top, 10)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(filteredSearchFriends) { item in
                        Button {
                            onSelectItem(item)
                        } label: {
                            HomeBalanceRow(item: item)
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer(minLength: 180)
                }
                .padding(.top, 12)
                .padding(.horizontal, 14)
            }
        }
        .background(
            LinearGradient(
                colors: [AppPalette.backgroundTop, AppPalette.backgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .sheet(isPresented: $showFilterSheet) {
            FilterPageView(selectedFilter: $selectedFilter)
        }
    }

    private var filteredSearchFriends: [BalanceItem] {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty { return friendsData }
        return friendsData.filter { $0.name.localizedCaseInsensitiveContains(trimmed) }
    }

    private var progressValue: Double {
        guard monthlyLimit > 0 else { return 0 }
        return min(monthlySpent / monthlyLimit, 1.0)
    }

    private var amountLeft: Double {
        max(monthlyLimit - monthlySpent, 0)
    }

    private var progressTint: Color {
        if progressValue >= 1.0 {
            return .red.opacity(0.85)
        } else if progressValue >= 0.75 {
            return .orange.opacity(0.85)
        } else {
            return AppPalette.accentMid
        }
    }

    private func formattedAmount(_ value: Double) -> String {
        String(format: "%.2f", value)
    }

    private func headerView(title: String) -> some View {
        HStack {
            ThemeHeaderButton(showThemeMenu: $showThemeMenu)

            Spacer()

            Button {
                onSettleUpTap()
            } label: {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            colors: [AppPalette.accentStart, AppPalette.accentEnd],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: AppPalette.accentMid.opacity(0.18), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, -45)
        .padding(.bottom, -5)
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppPalette.secondaryText)

            TextField("Search friends", text: $searchText)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppPalette.primaryText)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppPalette.secondaryText)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppPalette.searchField)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppPalette.border, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 4)
        )
    }

    private var monthlyLimitCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Monthly Limit")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppPalette.secondaryText)

                    Text("$\(formattedAmount(monthlyLimit))")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(AppPalette.primaryText)

                    Text("Spent $\(formattedAmount(monthlySpent)) this month")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppPalette.secondaryText)
                }

                Spacer(minLength: 10)

                Button {
                    showFilterSheet = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(selectedFilter.tintColor)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)

            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 16)

                    GeometryReader { geo in
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [progressTint.opacity(0.96), progressTint],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: max(16, geo.size.width * progressValue),
                                height: 16
                            )
                    }
                    .frame(height: 16)
                }

                HStack {
                    Text("\(Int(progressValue * 100))% used")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(progressTint)

                    Spacer()

                    if monthlySpent <= monthlyLimit {
                        Text("$\(formattedAmount(amountLeft)) left")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green.opacity(0.90))
                    } else {
                        Text("Over by $\(formattedAmount(monthlySpent - monthlyLimit))")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.red.opacity(0.88))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(AppPalette.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(AppPalette.border, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 6)
        )
        .padding(.horizontal, 12)
    }
}
