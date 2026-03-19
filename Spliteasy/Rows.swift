//
//  Rows.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/17/26.
//

import SwiftUI

struct BalanceRow: View {
    let item: BalanceItem

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Circle()
                    .fill(avatarColor)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(String(item.name.prefix(1)))
                            .font(.system(size: 21, weight: .bold))
                            .foregroundColor(avatarTextColor)
                    )

                Text(item.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(1)

                Spacer(minLength: 8)

                Text(item.balanceText)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(balanceColor)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(.vertical, 4)

            Divider()
                .padding(.top, 10)
                .opacity(0.2)
        }
    }

    private var avatarColor: Color {
        let colors: [Color] = [
            Color.purple.opacity(0.22),
            Color.blue.opacity(0.28),
            Color.pink.opacity(0.28),
            Color.green.opacity(0.22)
        ]
        return colors[abs(item.name.hashValue) % colors.count]
    }

    private var avatarTextColor: Color {
        let colors: [Color] = [
            Color.purple,
            Color.blue,
            Color.pink,
            Color.green
        ]
        return colors[abs(item.name.hashValue) % colors.count]
    }

    private var balanceColor: Color {
        item.direction == .owesYou
            ? Color.green.opacity(0.9)
            : Color.red.opacity(0.85)
    }
}

struct HomeBalanceRow: View {
    let item: BalanceItem

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Circle()
                    .fill(avatarColor)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(String(item.name.prefix(1)))
                            .font(.system(size: 21, weight: .bold))
                            .foregroundColor(avatarTextColor)
                    )

                Text(item.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(1)

                Spacer(minLength: 8)

                Text(item.balanceText)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(balanceColor)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(.vertical, 4)

            Divider()
                .padding(.top, 10)
                .opacity(0.2)
        }
    }

    private var avatarColor: Color {
        let colors: [Color] = [
            Color.pink.opacity(0.28),
            Color.purple.opacity(0.22),
            Color.green.opacity(0.22),
            Color.blue.opacity(0.28)
        ]
        return colors[abs(item.name.hashValue) % colors.count]
    }

    private var avatarTextColor: Color {
        let colors: [Color] = [
            Color.pink,
            Color.purple,
            Color.green,
            Color.blue
        ]
        return colors[abs(item.name.hashValue) % colors.count]
    }

    private var balanceColor: Color {
        item.direction == .owesYou
            ? Color.green.opacity(0.9)
            : Color.red.opacity(0.85)
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
            Spacer()
        }
    }
}
