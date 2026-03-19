//
//  CreateGroupPageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/19/26.
//

import SwiftUI

struct CreateGroupPageView: View {
    @Binding var selectedTab: Tab
    let availableFriends: [BalanceItem]
    let onSaveGroup: (String, GroupType, [BalanceItem]) -> Void

    @State private var groupName: String = ""
    @State private var selectedGroupType: GroupType = .trip
    @State private var showFriendsList = false
    @State private var selectedFriendIDs: Set<UUID> = []

    private let cardBorder = Color.purple.opacity(0.12)
    private let cardShadow = Color.purple.opacity(0.08)
    private let iconTint = Color(red: 0.53, green: 0.28, blue: 0.95)

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.95, blue: 1.0),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    headerSection
                        .padding(.top, 8)

                    groupNameCard

                    addMemberCard

                    if showFriendsList {
                        friendsSelectionCard
                    }

                    groupTypeSection

                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
    }

    private var headerSection: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    selectedTab = .friends
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white)
                        .frame(width: 46, height: 46)
                        .shadow(color: cardShadow, radius: 8, x: 0, y: 4)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Create Group")
                .font(.system(size: 24, weight: .bold))
                .italic()
                .foregroundColor(.black)

            Spacer()

            Button {
                saveGroup()
            } label: {
                Text("Save")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.54, green: 0.25, blue: 0.95),
                                Color(red: 0.43, green: 0.20, blue: 0.86)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color.purple.opacity(0.18), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(.plain)
        }
    }

    private var groupNameCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Group Name")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.gray)

            TextField("Enter group name", text: $groupName)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)

            Rectangle()
                .fill(Color.purple.opacity(0.15))
                .frame(height: 1)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(cardBorder, lineWidth: 1)
                )
                .shadow(color: cardShadow, radius: 8, x: 0, y: 5)
        )
    }

    private var addMemberCard: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.25)) {
                showFriendsList.toggle()
            }
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(iconTint)
                    .frame(width: 34)

                Text("Add member")
                    .font(.system(size: 20, weight: .bold))
                    .italic()
                    .foregroundColor(.black)

                Spacer()

                Text("\(selectedFriendIDs.count)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(iconTint))

                Image(systemName: showFriendsList ? "chevron.up" : "chevron.down")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(cardBorder, lineWidth: 1)
                    )
                    .shadow(color: cardShadow, radius: 8, x: 0, y: 5)
            )
        }
        .buttonStyle(.plain)
    }

    private var friendsSelectionCard: some View {
        VStack(spacing: 0) {
            ForEach(availableFriends) { friend in
                Button {
                    toggleFriend(friend.id)
                } label: {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(avatarColor(for: friend).opacity(0.22))
                            .frame(width: 46, height: 46)
                            .overlay(
                                Text(String(friend.name.prefix(1)))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(avatarColor(for: friend))
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(friend.name)
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.black)

                            Text("Friend")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Image(systemName: selectedFriendIDs.contains(friend.id) ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(selectedFriendIDs.contains(friend.id) ? iconTint : .gray.opacity(0.5))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.plain)

                if friend.id != availableFriends.last?.id {
                    Divider()
                        .opacity(0.18)
                        .padding(.leading, 74)
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(cardBorder, lineWidth: 1)
                )
                .shadow(color: cardShadow, radius: 8, x: 0, y: 5)
        )
    }

    private var groupTypeSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Group Type")
                .font(.system(size: 20, weight: .bold))
                .italic()
                .foregroundColor(.black)

            HStack(spacing: 12) {
                ForEach(GroupType.allCases, id: \.self) { type in
                    Button {
                        selectedGroupType = type
                    } label: {
                        VStack(spacing: 10) {
                            Image(systemName: type.icon)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(selectedGroupType == type ? .white : iconTint)

                            Text(type.title)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(selectedGroupType == type ? .white : .black)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 82)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(
                                    selectedGroupType == type
                                    ? Color(red: 0.53, green: 0.28, blue: 0.95)
                                    : Color.white
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(cardBorder, lineWidth: 1)
                                )
                                .shadow(color: cardShadow, radius: 8, x: 0, y: 5)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func toggleFriend(_ id: UUID) {
        if selectedFriendIDs.contains(id) {
            selectedFriendIDs.remove(id)
        } else {
            selectedFriendIDs.insert(id)
        }
    }

    private func saveGroup() {
        let trimmedName = groupName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let selectedFriends = availableFriends.filter { selectedFriendIDs.contains($0.id) }
        guard !selectedFriends.isEmpty else { return }

        onSaveGroup(trimmedName, selectedGroupType, selectedFriends)

        withAnimation(.easeInOut(duration: 0.25)) {
            selectedTab = .friends
        }
    }

    private func avatarColor(for item: BalanceItem) -> Color {
        let colors: [Color] = [.purple, .blue, .green, .pink]
        return colors[abs(item.name.hashValue) % colors.count]
    }
}

enum GroupType: CaseIterable {
    case trip
    case room
    case couple
    case others

    var title: String {
        switch self {
        case .trip: return "Trip"
        case .room: return "Room"
        case .couple: return "Couple"
        case .others: return "Others"
        }
    }

    var icon: String {
        switch self {
        case .trip: return "airplane"
        case .room: return "house"
        case .couple: return "heart"
        case .others: return "square.grid.2x2"
        }
    }
}
