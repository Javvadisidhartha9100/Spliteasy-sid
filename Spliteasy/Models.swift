//
//  Models.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/17/26.
//

import SwiftUI

enum Tab {
    case home
    case friends
    case activity
    case profile
    case add

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

enum FriendsSection {
    case friends
    case groups
}

enum BalanceFilter {
    case none
    case youOwe
    case owesYou

    var title: String {
        switch self {
        case .none: return "None"
        case .youOwe: return "Friends you owe"
        case .owesYou: return "Friends who owe you"
        }
    }

    var tintColor: Color {
        switch self {
        case .none:
            return .gray
        case .youOwe:
            return .red
        case .owesYou:
            return .green
        }
    }
}

struct BalanceItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let balanceText: String
}

enum ActivityChartType {
    case category
    case month
}

struct CategoryItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let amount: Double
    let color: Color
}

struct MonthlyExpense: Identifiable, Hashable {
    let id = UUID()
    let month: String
    let amount: Double
}

struct TransactionItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
    let amount: Double
    let date: String
}
