//
//  FriendDetailPageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/24/26.
//

import SwiftUI

struct FriendDetailPageView: View {
    let friend: BalanceItem
    @Binding var selectedTab: Tab
    @Binding var showFriendDetailPage: Bool
    let onAddExpense: (BalanceItem) -> Void
    let onSettleUp: (BalanceItem) -> Void

    private let cardBorder = Color.purple.opacity(0.12)
    private let cardShadow = Color.purple.opacity(0.08)
    private let themePurple = Color(red: 0.53, green: 0.28, blue: 0.95)

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

            VStack(spacing: 0) {
                headerView
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        friendNameCard
                        actionCards
                        recentExpensesSection

                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                }
            }

            VStack {
                Spacer()

                addExpenseButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)
            }
        }
    }

    private var headerView: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showFriendDetailPage = false
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

            Text("Friend Details")
                .font(.system(size: 24, weight: .bold))
                .italic()
                .foregroundColor(.black)

            Spacer()

            Color.clear.frame(width: 46, height: 46)
        }
    }

    private var friendNameCard: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(themePurple.opacity(0.15))
                .frame(width: 64, height: 64)
                .overlay(
                    Text(String(friend.name.prefix(1)))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(themePurple)
                )

            VStack(alignment: .leading, spacing: 6) {
                Text("Friend")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)

                Text(friend.name)
                    .font(.system(size: 28, weight: .bold))
                    .italic()
                    .foregroundColor(Color(red: 0.10, green: 0.14, blue: 0.22))

                Text(friend.balanceText)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(friend.direction == .owesYou ? .green.opacity(0.85) : .red.opacity(0.85))
            }

            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(cardBorder, lineWidth: 1)
                )
                .shadow(color: cardShadow, radius: 10, x: 0, y: 6)
        )
    }

    private var actionCards: some View {
        HStack(spacing: 14) {
            Button {
                onSettleUp(friend)
            } label: {
                actionCardContent(icon: "arrow.left.arrow.right", title: "Settle up")
            }
            .buttonStyle(.plain)

            Button {
                print("Remind tapped")
            } label: {
                actionCardContent(icon: "bell", title: "Remind")
            }
            .buttonStyle(.plain)
        }
    }

    private func actionCardContent(icon: String, title: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(themePurple)

            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
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

    private var recentExpensesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Recent Expenses")
                .font(.system(size: 22, weight: .bold))
                .italic()
                .foregroundColor(.black)

            if friend.expenses.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "tray")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(.gray.opacity(0.7))

                    Text("No expenses yet")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 28)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(cardBorder, lineWidth: 1)
                        )
                        .shadow(color: cardShadow, radius: 8, x: 0, y: 5)
                )
            } else {
                VStack(spacing: 0) {
                    ForEach(friend.expenses) { expense in
                        HStack(spacing: 12) {
                            Circle()
                                .fill(themePurple.opacity(0.12))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Image(systemName: "receipt")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(themePurple)
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text(expense.description)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black)

                                Text(expense.dateText)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Text("$\(String(format: "%.2f", expense.amount))")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)

                        if expense.id != friend.expenses.last?.id {
                            Divider()
                                .padding(.leading, 72)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(cardBorder, lineWidth: 1)
                        )
                        .shadow(color: cardShadow, radius: 8, x: 0, y: 5)
                )
            }
        }
    }

    private var addExpenseButton: some View {
        Button {
            onAddExpense(friend)
        } label: {
            Text("Add Expense")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
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
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}
