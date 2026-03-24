import SwiftUI

struct HomePageView: View {
    let friendsData: [BalanceItem]
    let headerTitle: String
    @Binding var selectedFilter: BalanceFilter
    let monthlyLimit: Double
    let monthlySpent: Double
    let onSelectItem: (BalanceItem) -> Void
    let onSettleUpTap: () -> Void

    @State private var showFilterSheet = false
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 0) {
            headerView(title: headerTitle)

            searchBar
                .padding(.horizontal, 16)
                .padding(.top, 8)

            monthlyLimitCard
                .padding(.top, 8)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(filteredSearchFriends) { item in
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
            return Color(red: 0.53, green: 0.28, blue: 0.95)
        }
    }

    private func formattedAmount(_ value: Double) -> String {
        String(format: "%.2f", value)
    }

    private func headerView(title: String) -> some View {
        HStack {
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
                            colors: [
                                Color(red: 0.75, green: 0.30, blue: 0.97),
                                Color(red: 0.60, green: 0.24, blue: 0.90)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color.purple.opacity(0.15), radius: 6, x: 0, y: 3)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, -45)
        .padding(.bottom, -20)
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search friends", text: $searchText)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.purple.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: Color.purple.opacity(0.06), radius: 8, x: 0, y: 4)
        )
    }

    private var monthlyLimitCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Monthly Limit")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)

                    Text("$\(formattedAmount(monthlyLimit))")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)

                    Text("Spent $\(formattedAmount(monthlySpent)) this month")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(red: 0.35, green: 0.38, blue: 0.45))
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
                        .fill(Color.gray.opacity(0.12))
                        .frame(height: 16)

                    GeometryReader { geo in
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [progressTint.opacity(0.95), progressTint],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: max(16, geo.size.width * progressValue), height: 16)
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
                            .foregroundColor(Color.green.opacity(0.85))
                    } else {
                        Text("Over by $\(formattedAmount(monthlySpent - monthlyLimit))")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.red.opacity(0.85))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.purple.opacity(0.12), lineWidth: 1)
                )
                .shadow(color: Color.purple.opacity(0.08), radius: 10, x: 0, y: 6)
        )
        .padding(.horizontal, 12)
    }
}

#Preview {
    ContentView()
}

