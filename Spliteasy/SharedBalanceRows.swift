//
// Shared row views used by home/friends pages so the UI stays consistent.
//
//
//  SharedBalanceRows.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/24/26.
//

import SwiftUI

struct BalanceRow: View {
    let item: BalanceItem
    // Main screen layout


    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(avatarColor.opacity(0.20))
                .frame(width: 54, height: 54)
                .overlay(
                    Text(String(item.name.prefix(1)))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(avatarColor)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppPalette.primaryText)

                Text(item.kind == .friend ? "Friend" : "\(item.participantCount) members")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(AppPalette.secondaryText)
            }

            Spacer()

            Text(item.balanceText)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(item.direction == .owesYou ? .green.opacity(0.90) : .red.opacity(0.88))
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(AppPalette.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(AppPalette.border, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 5)
        )
    }

    private var avatarColor: Color {
        let colors: [Color] = [AppPalette.accentMid, AppPalette.accentStart, .green, .pink]
        return colors[abs(item.name.hashValue) % colors.count]
    }
}

struct HomeBalanceRow: View {
    let item: BalanceItem

    var body: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(avatarColor.opacity(0.20))
                .frame(width: 54, height: 54)
                .overlay(
                    Text(String(item.name.prefix(1)))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(avatarColor)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppPalette.primaryText)

                Text(item.kind == .friend ? "Friend" : "Group")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(AppPalette.secondaryText)
            }

            Spacer()

            Text(item.balanceText)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(item.direction == .owesYou ? .green.opacity(0.90) : .red.opacity(0.88))
                .multilineTextAlignment(.trailing)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(AppPalette.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(AppPalette.border, lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 5)
        )
    }

    private var avatarColor: Color {
        let colors: [Color] = [.pink, AppPalette.accentMid, .green, AppPalette.accentStart]
        return colors[abs(item.name.hashValue) % colors.count]
    }
}

struct SimplePageView: View {
    let title: String

    var body: some View {
        VStack {
            Spacer()
            Text("Selected: \(title)")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(AppPalette.primaryText)
            Spacer()
        }
        .background(
            LinearGradient(
                colors: [AppPalette.backgroundTop, AppPalette.backgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}
