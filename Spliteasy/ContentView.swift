//
//  ContentView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @State private var selectedSection: FriendsSection = .friends
    @State private var showPlusMenu = false
    @State private var selectedFilter: BalanceFilter = .none

    let friendsData: [BalanceItem] = [
        .init(name: "Friend -1", balanceText: "You owe $25"),
        .init(name: "Friend -2", balanceText: "owes you $12"),
        .init(name: "Friend -3", balanceText: "You owe $45"),
        .init(name: "Friend -4", balanceText: "owes you $30"),
        .init(name: "Friend -5", balanceText: "You owe $50")
    ]

    let groupsData: [BalanceItem] = [
        .init(name: "Group -1", balanceText: "owes you $12"),
        .init(name: "Group -2", balanceText: "You owe $45"),
        .init(name: "Group -3", balanceText: "owes you $30"),
        .init(name: "Group -4", balanceText: "You owe $50"),
        .init(name: "Group -5", balanceText: "You owe $25")
    ]

    var body: some View {
        ZStack {
            Color.gray.opacity(0.12)
                .ignoresSafeArea()

            if showPlusMenu && selectedTab != .friends && selectedTab != .activity && selectedTab != .add {
                Color.black.opacity(0.001)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            showPlusMenu = false
                        }
                    }
            }

            switch selectedTab {
            case .home:
                HomePageView(
                    friendsData: filteredFriends,
                    headerTitle: "Settle Up",
                    selectedFilter: $selectedFilter
                )

            case .friends:
                FriendsPageView(
                    selectedSection: $selectedSection,
                    friendsData: filteredFriends,
                    groupsData: filteredGroups,
                    headerTitle: "Save",
                    selectedFilter: $selectedFilter
                )

            case .activity:
                ActivityPageView()

            case .profile:
                AccountPageView()

            case .add:
                AddExpensePageView(selectedTab: $selectedTab)
            }
        }
        .safeAreaInset(edge: .bottom) {
            CustomBottomBar(
                selectedTab: $selectedTab,
                selectedSection: selectedSection,
                showActionButton: selectedTab == .friends,
                showPlusMenu: $showPlusMenu,
                hidePlusButton: selectedTab == .activity || selectedTab == .profile || selectedTab == .add,
                actionButtonPressed: handleFriendsActionButtonTap,
                takePicturePressed: handleTakePicture,
                addExpensePressed: handleAddExpense
            )
            .padding(.horizontal, 5)
            .padding(.bottom, -145)
        }
        .onChange(of: selectedTab) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                showPlusMenu = false
            }
        }
    }

    private var filteredFriends: [BalanceItem] {
        applyFilter(to: friendsData)
    }

    private var filteredGroups: [BalanceItem] {
        applyFilter(to: groupsData)
    }

    private func applyFilter(to items: [BalanceItem]) -> [BalanceItem] {
        switch selectedFilter {
        case .none:
            return items
        case .youOwe:
            return items.filter { $0.balanceText.lowercased().contains("you owe") }
        case .owesYou:
            return items.filter { $0.balanceText.lowercased().contains("owes you") }
        }
    }

    private func handleFriendsActionButtonTap() {
        if selectedSection == .friends {
            print("Add Friend tapped")
        } else {
            print("Create Group tapped")
        }
    }

    private func handleTakePicture() {
        print("Take a picture tapped")
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showPlusMenu = false
        }
    }

    private func handleAddExpense() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showPlusMenu = false
            selectedTab = .add
        }
    }
}

#Preview {
    ContentView()
}
