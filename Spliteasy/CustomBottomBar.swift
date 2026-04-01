//
// Custom tab bar and floating action button used in the main app layout.
//
//
//  CustomBottomBar.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/17/26.
//

import SwiftUI

struct CustomBottomBar: View {
    @Binding var selectedTab: Tab
    let selectedSection: FriendsSection
    let showActionButton: Bool
    @Binding var showPlusMenu: Bool
    let hidePlusButton: Bool
    let actionButtonPressed: () -> Void
    let addExpensePressed: () -> Void

    private let activeColor = AppPalette.accentMid
    private let inactiveColor = AppPalette.secondaryText.opacity(0.75)
    private let plusActiveStart = AppPalette.accentStart
    private let plusActiveEnd = AppPalette.accentEnd
    private let plusInactiveStart = AppPalette.accentStart
    private let plusInactiveEnd = AppPalette.accentEnd
    // Main screen layout


    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let horizontalPadding: CGFloat = 16
            let usableWidth = totalWidth - (horizontalPadding * 2)
            let tabWidth = usableWidth / 4
            let profileCenterX = horizontalPadding + (tabWidth * 3) + (tabWidth / 2)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(AppPalette.card.opacity(0.96))
                    .frame(height: 82)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(AppPalette.border, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 4)
                    .offset(y: 24)

                HStack(spacing: 0) {
                    tabItem(.home)
                    tabItem(.friends)
                    tabItem(.activity)
                    tabItem(.profile)
                }
                .padding(.horizontal, horizontalPadding)
                .frame(height: 82)
                .offset(y: 24)

                if showActionButton {
                    actionButton
                        .position(x: profileCenterX - 20, y: 0)
                        .offset(y: -30)
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(2)
                } else if !hidePlusButton {
                    if showPlusMenu {
                        plusMenu
                            .position(x: profileCenterX - 38, y: -88)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .zIndex(3)
                    }

                    plusButton
                        .position(x: profileCenterX, y: 0)
                        .offset(y: -30)
                        .transition(.scale.combined(with: .opacity))
                        .zIndex(2)
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showActionButton)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showPlusMenu)
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: hidePlusButton)
        }
        .frame(height: 220)
    }

    private func tabItem(_ tab: Tab) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selectedTab = tab
                showPlusMenu = false
            }
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
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                showPlusMenu.toggle()
            }
        } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: showPlusMenu
                                ? [plusActiveStart, plusActiveEnd]
                                : [plusInactiveStart, plusInactiveEnd],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 64, height: 64)
                    .shadow(
                        color: AppPalette.accentMid.opacity(showPlusMenu ? 0.42 : 0.30),
                        radius: 12,
                        x: 0,
                        y: 6
                    )

                Image(systemName: "plus")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(showPlusMenu ? 45 : 0))
            }
        }
        .buttonStyle(.plain)
    }

    private var plusMenu: some View {
        VStack(alignment: .trailing, spacing: 12) {
            menuButton(title: "Add Expenses") {
                addExpensePressed()
            }
        }
        .padding(.bottom, 28)
    }

    private func menuButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [plusInactiveStart, plusInactiveEnd],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: AppPalette.accentMid.opacity(0.20), radius: 8, x: 0, y: 4)
                )
        }
        .buttonStyle(.plain)
    }

    private var actionButton: some View {
        Button {
            actionButtonPressed()
        } label: {
            Text(selectedSection == .friends ? "Add Friend" : "Create Group")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [plusInactiveStart, plusInactiveEnd],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: AppPalette.accentMid.opacity(0.30), radius: 12, x: 0, y: 6)
                )
        }
        .buttonStyle(.plain)
    }
}
