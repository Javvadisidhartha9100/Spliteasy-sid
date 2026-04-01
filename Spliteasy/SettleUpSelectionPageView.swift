//
// Lets the user choose which friend they want to settle up with.
//
//
//  SettleUpSelectionPageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/24/26.
//

import SwiftUI

struct SettleUpSelectionPageView: View {
    let friends: [BalanceItem]
    @Binding var selectedTab: Tab
    @Binding var showSettleUpSelectionPage: Bool
    let onSelectFriend: (BalanceItem) -> Void

    @State private var searchText = ""
    // Main screen layout


    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppPalette.backgroundTop, AppPalette.backgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                headerView
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                searchBar
                    .padding(.horizontal, 20)
                    .padding(.top, 18)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(filteredFriends) { friend in
                            Button {
                                onSelectFriend(friend)
                            } label: {
                                HStack(spacing: 14) {
                                    Circle()
                                        .fill(avatarColor(for: friend).opacity(0.18))
                                        .frame(width: 52, height: 52)
                                        .overlay(
                                            Text(String(friend.name.prefix(1)))
                                                .font(.system(size: 22, weight: .bold))
                                                .foregroundColor(avatarColor(for: friend))
                                        )

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(friend.name)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(AppPalette.primaryText)

                                        Text(friend.balanceText)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(friend.direction == .owesYou ? .green.opacity(0.85) : .red.opacity(0.85))
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundColor(AppPalette.secondaryText.opacity(0.7))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                                        .fill(AppPalette.card)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 22)
                                                .stroke(AppPalette.border, lineWidth: 1)
                                        )
                                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 5)
                                )
                            }
                            .buttonStyle(.plain)
                            
                        }

                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                }
            }
        }
    }
    // Top bar / page heading


    private var headerView: some View {
        HStack {
            Button {
                showSettleUpSelectionPage = false
                selectedTab = .home
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppPalette.card)
                        .frame(width: 46, height: 46)
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(AppPalette.primaryText)
                }
            }
            .buttonStyle(.plain)
            

            Spacer()

            Text("Select Friend")
                .font(.system(size: 24, weight: .bold))
                .italic()
                .foregroundColor(AppPalette.primaryText)

            Spacer()

            Color.clear.frame(width: 46, height: 46)
        }
    }
    // Search UI for quick filtering on the page


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
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppPalette.searchField)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppPalette.border, lineWidth: 1)
                )
        )
    }

    private var filteredFriends: [BalanceItem] {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty { return friends }
        return friends.filter { $0.name.localizedCaseInsensitiveContains(text) }
    }

    private func avatarColor(for item: BalanceItem) -> Color {
        let colors: [Color] = [AppPalette.accentMid, AppPalette.accentStart, .green, .pink]
        return colors[abs(item.name.hashValue) % colors.count]
    }
}
