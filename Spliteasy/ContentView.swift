//
//  ContentView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home

    var body: some View {
        ZStack {
            Color.gray.opacity(0.12)
                .ignoresSafeArea()

            Text("Selected: \(selectedTab.title)")
                .font(.title2)
                .fontWeight(.semibold)
        }
        .safeAreaInset(edge: .bottom) {
            CustomBottomBar(selectedTab: $selectedTab)
                .padding(.horizontal, 5)
                .padding(.bottom, -45)
        }
    }
}

enum Tab {
    case home, friends, activity, profile, add

    var title: String {
        switch self {
        case .home: return "Home"
        case .friends: return "Friends"
        case .activity: return "Activity"
        case .profile: return "Profile"
        case .add: return "Add"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house"
        case .friends: return "person.2"
        case .activity: return "clock"
        case .profile: return "person.crop.circle"
        case .add: return "plus"
        }
    }
}

struct CustomBottomBar: View {
    @Binding var selectedTab: Tab

    private let activeColor = Color(red: 0.75, green: 0.20, blue: 0.95)
    private let inactiveColor = Color.gray.opacity(0.65)

    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let horizontalPadding: CGFloat = 16
            let usableWidth = totalWidth - (horizontalPadding * 2)
            let tabWidth = usableWidth / 4
            let profileCenterX = horizontalPadding + (tabWidth * 3) + (tabWidth / 2)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(0.96))
                    .frame(height: 82)
                    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
                    .offset(y: 24)   // moves navigation bar downward

                HStack(spacing: 0) {
                    tabItem(.home)
                    tabItem(.friends)
                    tabItem(.activity)
                    tabItem(.profile)
                }
                .padding(.horizontal, horizontalPadding)
                .frame(height: 82)
                .offset(y: 24)   // keeps icons aligned with moved bar

                plusButton
                    .position(x: profileCenterX, y: 0)
                    .offset(y: -30)   // keeps button above bar with spacing
            }
        }
        .frame(height: 124)
    }

    private func tabItem(_ tab: Tab) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 23, weight: .regular))
                    .frame(height: 24)

                Text(tab.title)
                    .font(.system(size: 11, weight: .medium))
                    .lineLimit(1)
            }
            .foregroundColor(selectedTab == tab ? activeColor : inactiveColor)
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
            .padding(.bottom, 8)
        }
        .buttonStyle(.plain)
    }

    private var plusButton: some View {
        Button {
            selectedTab = .add
        } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.82, green: 0.25, blue: 0.95),
                                Color(red: 0.71, green: 0.16, blue: 0.90)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 64, height: 64)
                    .shadow(color: activeColor.opacity(0.30), radius: 12, x: 0, y: 6)

                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
