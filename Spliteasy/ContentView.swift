import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var selectedSection: FriendsSection = .friends
    @State private var showPlusMenu = false
    @State private var selectedFilter: BalanceFilter = .none
    @State private var showExpenseSelectionPage = false
    @State private var showCreateGroupPage = false

    @State private var friendsData: [BalanceItem] = [
        .init(kind: .friend, name: "Friend -1", amount: 25, direction: .youOwe, participantCount: 2),
        .init(kind: .friend, name: "Friend -2", amount: 12, direction: .owesYou, participantCount: 2),
        .init(kind: .friend, name: "Friend -3", amount: 120, direction: .youOwe, participantCount: 2),
        .init(kind: .friend, name: "Friend -4", amount: 30, direction: .owesYou, participantCount: 2),
        .init(kind: .friend, name: "Friend -5", amount: 50, direction: .youOwe, participantCount: 2)
    ]

    @State private var groupsData: [BalanceItem] = [
        .init(kind: .group, name: "Group -1", amount: 12, direction: .owesYou, participantCount: 3),
        .init(kind: .group, name: "Group -2", amount: 45, direction: .youOwe, participantCount: 4),
        .init(kind: .group, name: "Group -3", amount: 30, direction: .owesYou, participantCount: 5),
        .init(kind: .group, name: "Group -4", amount: 50, direction: .youOwe, participantCount: 3),
        .init(kind: .group, name: "Group -5", amount: 25, direction: .youOwe, participantCount: 4)
    ]

    @State private var selectedExpenseTarget: BalanceItem?

    @State private var activityTransactions: [TransactionItem] = [
        .init(title: "Trip to NYC", subtitle: "You paid · 3 people", amount: 4000.00, date: "Mar 16", monthKey: "2026-03", category: "Travel"),
        .init(title: "Walmart", subtitle: "You paid · 3 people", amount: 120.00, date: "Mar 12", monthKey: "2026-03", category: "Shopping"),
        .init(title: "Groceries", subtitle: "Taylor paid · 3 people", amount: 67.30, date: "Mar 11", monthKey: "2026-03", category: "Food"),
        .init(title: "Dinner at Olive Garden", subtitle: "You paid · 4 people", amount: 86.50, date: "Mar 9", monthKey: "2026-03", category: "Food"),
        .init(title: "Uber to Airport", subtitle: "Alex paid · 4 people", amount: 45.00, date: "Mar 8", monthKey: "2026-03", category: "Transport"),
        .init(title: "March Rent", subtitle: "You paid · 3 people", amount: 2400.00, date: "Feb 28", monthKey: "2026-02", category: "Other")
    ]

    var body: some View {
        ZStack {
            Color.gray.opacity(0.12)
                .ignoresSafeArea()

            if showPlusMenu && !showExpenseSelectionPage && !showCreateGroupPage && selectedTab != .friends && selectedTab != .activity && selectedTab != .add {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showPlusMenu = false
                        }
                    }
            }

            if showCreateGroupPage {
                CreateGroupPageView(
                    selectedTab: $selectedTab,
                    availableFriends: friendsData,
                    onSaveGroup: saveNewGroup
                )
            } else if showExpenseSelectionPage {
                RecentSelectionPageView(
                    recentFriends: recentFriends,
                    recentGroups: recentGroups,
                    onSelectItem: { item in
                        openExpensePage(for: item)
                    },
                    selectedTab: $selectedTab,
                    showExpenseSelectionPage: $showExpenseSelectionPage
                )
            } else {
                switch selectedTab {
                case .home:
                    HomePageView(
                        friendsData: filteredFriends,
                        headerTitle: "Settle Up",
                        selectedFilter: $selectedFilter,
                        totalYouOwe: homeTotalYouOwe,
                        totalYouAreOwed: homeTotalYouAreOwed,
                        onSelectItem: { item in
                            openExpensePage(for: item)
                        }
                    )

                case .friends:
                    FriendsPageView(
                        selectedSection: $selectedSection,
                        friendsData: filteredFriends,
                        groupsData: filteredGroups,
                        headerTitle: "Save",
                        selectedFilter: $selectedFilter,
                        totalYouOwe: friendsPageTotalYouOwe,
                        totalYouAreOwed: friendsPageTotalYouAreOwed,
                        onSelectItem: { item in
                            openExpensePage(for: item)
                        }
                    )

                case .activity:
                    ActivityPageView(transactions: activityTransactions)

                case .profile:
                    AccountPageView()

                case .add:
                    AddExpensePageView(
                        selectedItem: selectedExpenseTarget,
                        onSaveExpense: saveExpense,
                        selectedTab: $selectedTab
                    )
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if !showCreateGroupPage {
                CustomBottomBar(
                    selectedTab: $selectedTab,
                    selectedSection: selectedSection,
                    showActionButton: selectedTab == .friends && !showExpenseSelectionPage && !showCreateGroupPage,
                    showPlusMenu: $showPlusMenu,
                    hidePlusButton: selectedTab == .activity || selectedTab == .profile || selectedTab == .add || showExpenseSelectionPage || showCreateGroupPage,
                    actionButtonPressed: handleFriendsActionButtonTap,
                    addExpensePressed: handleAddExpense
                )
                .padding(.horizontal, 5)
                .padding(.bottom, -145)
            }
        }
        .onChange(of: selectedTab) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                showPlusMenu = false
            }

            if selectedTab != .friends {
                showCreateGroupPage = false
            }
        }
    }

    private var homeItems: [BalanceItem] {
        friendsData
    }

    private var currentFriendsPageItems: [BalanceItem] {
        selectedSection == .friends ? friendsData : groupsData
    }

    private var homeTotalYouOwe: Double {
        homeItems
            .filter { $0.direction == .youOwe }
            .reduce(0) { $0 + $1.amount }
    }

    private var homeTotalYouAreOwed: Double {
        homeItems
            .filter { $0.direction == .owesYou }
            .reduce(0) { $0 + $1.amount }
    }

    private var friendsPageTotalYouOwe: Double {
        currentFriendsPageItems
            .filter { $0.direction == .youOwe }
            .reduce(0) { $0 + $1.amount }
    }

    private var friendsPageTotalYouAreOwed: Double {
        currentFriendsPageItems
            .filter { $0.direction == .owesYou }
            .reduce(0) { $0 + $1.amount }
    }

    private var filteredFriends: [BalanceItem] {
        applyFilter(to: friendsData)
    }

    private var filteredGroups: [BalanceItem] {
        applyFilter(to: groupsData)
    }

    private var recentFriends: [BalanceItem] {
        Array(friendsData.prefix(4))
    }

    private var recentGroups: [BalanceItem] {
        Array(groupsData.prefix(4))
    }

    private func applyFilter(to items: [BalanceItem]) -> [BalanceItem] {
        switch selectedFilter {
        case .none:
            return items
        case .youOwe:
            return items.filter { $0.direction == .youOwe }
        case .owesYou:
            return items.filter { $0.direction == .owesYou }
        }
    }

    private func openExpensePage(for item: BalanceItem) {
        selectedExpenseTarget = item
        showExpenseSelectionPage = false
        showCreateGroupPage = false
        selectedTab = .add

        if item.kind == .group {
            selectedSection = .groups
        }
    }

    private func saveNewGroup(name: String, type: GroupType, members: [BalanceItem]) {
        let participantCount = members.count + 1

        let newGroup = BalanceItem(
            kind: .group,
            name: name,
            amount: 0,
            direction: .owesYou,
            participantCount: participantCount,
            expenses: []
        )

        groupsData.insert(newGroup, at: 0)

        selectedSection = .groups
        showCreateGroupPage = false
        selectedTab = .friends
    }

    private func saveExpense(itemID: UUID, description: String, amount: Double, direction: BalanceDirection) {
        let now = Date()

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "MMM d"

        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "yyyy-MM"

        if let friendIndex = friendsData.firstIndex(where: { $0.id == itemID }) {
            let friend = friendsData[friendIndex]

            let newExpense = ExpenseEntry(
                description: description,
                amount: amount,
                dateText: dayFormatter.string(from: now)
            )

            friendsData[friendIndex].amount += amount
            friendsData[friendIndex].direction = direction
            friendsData[friendIndex].expenses.append(newExpense)
            selectedExpenseTarget = friendsData[friendIndex]

            let transaction = TransactionItem(
                title: description,
                subtitle: direction == .owesYou ? "You paid · \(friend.name)" : "\(friend.name) paid",
                amount: amount,
                date: dayFormatter.string(from: now),
                monthKey: monthFormatter.string(from: now),
                category: inferCategory(from: description)
            )

            activityTransactions.insert(transaction, at: 0)
            selectedSection = .friends
            selectedTab = .home
            return
        }

        if let groupIndex = groupsData.firstIndex(where: { $0.id == itemID }) {
            let group = groupsData[groupIndex]

            let newExpense = ExpenseEntry(
                description: description,
                amount: amount,
                dateText: dayFormatter.string(from: now)
            )

            groupsData[groupIndex].amount += amount
            groupsData[groupIndex].direction = direction
            groupsData[groupIndex].expenses.append(newExpense)
            selectedExpenseTarget = groupsData[groupIndex]

            let subtitleText = direction == .owesYou
                ? "You paid · \(group.participantCount) people"
                : "\(group.participantCount) people paid"

            let transaction = TransactionItem(
                title: description,
                subtitle: subtitleText,
                amount: amount,
                date: dayFormatter.string(from: now),
                monthKey: monthFormatter.string(from: now),
                category: inferCategory(from: description)
            )

            activityTransactions.insert(transaction, at: 0)
            selectedSection = .groups
            selectedTab = .friends
        }
    }

    private func inferCategory(from description: String) -> String {
        let text = description.lowercased()

        if text.contains("food") || text.contains("dinner") || text.contains("lunch") || text.contains("breakfast") || text.contains("restaurant") || text.contains("grocer") || text.contains("cafe") || text.contains("coffee") {
            return "Food"
        }

        if text.contains("uber") || text.contains("lyft") || text.contains("taxi") || text.contains("bus") || text.contains("train") || text.contains("flight") || text.contains("airport") || text.contains("gas") {
            return "Transport"
        }

        if text.contains("shop") || text.contains("mall") || text.contains("walmart") || text.contains("target") || text.contains("amazon") || text.contains("clothes") {
            return "Shopping"
        }

        if text.contains("trip") || text.contains("hotel") || text.contains("travel") || text.contains("vacation") {
            return "Travel"
        }

        return "Other"
    }

    private func handleFriendsActionButtonTap() {
        if selectedSection == .friends {
            print("Add Friend tapped")
        } else {
            showCreateGroupPage = true
        }
    }

    private func handleAddExpense() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showPlusMenu = false
            showCreateGroupPage = false
            showExpenseSelectionPage = true
        }
    }
}

#Preview {
    ContentView()
}
