//
//  RecentSelectionPageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/19/26.
//

import SwiftUI

struct RecentSelectionPageView: View {
    let recentFriends: [BalanceItem]
    let recentGroups: [BalanceItem]
    let onSelectItem: (BalanceItem) -> Void
    @Binding var selectedTab: Tab

    var body: some View {
        ZStack {
            Color.gray.opacity(0.12)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                    .padding(.horizontal, 20)
                    .padding(.top, 6)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        recentSection(title: "Recent Friends", items: recentFriends)
                        recentSection(title: "Recent Groups", items: recentGroups)

                        Spacer(minLength: 160)
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 24)
                }
            }
        }
    }

    private var headerSection: some View {
        HStack {
            Button {
                selectedTab = .home
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Add Expenses")
                .font(.system(size: 24, weight: .bold))
                .italic()
                .foregroundColor(.black)

            Spacer()

            Color.clear
                .frame(width: 24, height: 24)
        }
    }

    private func recentSection(title: String, items: [BalanceItem]) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .italic()
                .foregroundColor(.black)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                ForEach(items) { item in
                    Button {
                        onSelectItem(item)
                    } label: {
                        recentRow(item: item)
                    }
                    .buttonStyle(.plain)

                    if item.id != items.last?.id {
                        Divider()
                            .opacity(0.18)
                            .padding(.leading, 64)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(Color.purple.opacity(0.12), lineWidth: 1)
                    )
                    .shadow(color: Color.purple.opacity(0.08), radius: 10, x: 0, y: 6)
            )
        }
    }

    private func recentRow(item: BalanceItem) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(avatarColor(for: item).opacity(0.22))
                .frame(width: 46, height: 46)
                .overlay(
                    Text(String(item.name.prefix(1)))
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(avatarColor(for: item))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(1)

                Text(item.kind == .friend ? "Friend" : "Group")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.gray.opacity(0.7))
        }
        .padding(.vertical, 12)
    }

    private func avatarColor(for item: BalanceItem) -> Color {
        let colors: [Color] = [.purple, .blue, .green, .pink]
        return colors[abs(item.name.hashValue) % colors.count]
    }
}
