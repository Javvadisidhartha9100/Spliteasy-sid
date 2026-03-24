//
//  ActivityPageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/17/26.
//

import SwiftUI

struct ActivityPageView: View {
    let transactions: [TransactionItem]
    @State private var selectedChart: ActivityChartType = .category

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                headerSection

                chartCard
                    .padding(.top, 16)
                    .padding(.horizontal, 20)

                Text("Recent Transactions")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(red: 0.22, green: 0.26, blue: 0.34))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 16)
                    .padding(.horizontal, 20)

                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 0) {
                        ForEach(transactions) { transaction in
                            ActivityTransactionRow(item: transaction)
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
                .frame(maxHeight: .infinity)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .top)
            .background(Color.gray.opacity(0.12).ignoresSafeArea())
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Activity")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color(red: 0.05, green: 0.10, blue: 0.18))

            Text("All your transactions")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.60, green: 0.64, blue: 0.71))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, -40)
    }

    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedChart == .category ? "This Month by Category" : "Monthly Expenses")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(red: 0.25, green: 0.29, blue: 0.37))

                    Text(selectedChart == .category ? currentMonthTitle : "Last 6 months")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.60, green: 0.64, blue: 0.71))
                }

                Spacer()

                HStack(spacing: 8) {
                    Capsule()
                        .fill(selectedChart == .category ? Color.purple : Color.gray.opacity(0.35))
                        .frame(width: 28, height: 12)

                    Capsule()
                        .fill(selectedChart == .month ? Color.purple : Color.gray.opacity(0.35))
                        .frame(width: 28, height: 12)
                }
                .padding(.top, 4)
            }

            if selectedChart == .category {
                categoryChartSection
                    .padding(.top, 10)
            } else {
                monthChartSection
                    .padding(.top, 10)
            }

            chartToggleButtons
                .padding(.top, 12)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color(red: 0.95, green: 0.95, blue: 0.96))
        )
    }

    private var currentMonthTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: Date())
    }

    private var categoryData: [CategoryItem] {
        let currentMonthKey = monthKey(for: Date())
        let monthTransactions = transactions.filter { $0.monthKey == currentMonthKey }

        let grouped = Dictionary(grouping: monthTransactions, by: { $0.category })
            .mapValues { items in
                items.reduce(0) { $0 + $1.amount }
            }

        let colors: [String: Color] = [
            "Food": Color(red: 0.49, green: 0.38, blue: 0.78),
            "Transport": Color(red: 0.38, green: 0.39, blue: 0.88),
            "Shopping": Color(red: 0.89, green: 0.27, blue: 0.58),
            "Travel": Color(red: 0.22, green: 0.70, blue: 0.60),
            "Other": Color(red: 0.62, green: 0.68, blue: 0.77)
        ]

        let sorted = grouped
            .map { key, value in
                CategoryItem(name: key, amount: value, color: colors[key] ?? Color.gray)
            }
            .sorted { $0.amount > $1.amount }

        return sorted.isEmpty
            ? [CategoryItem(name: "Other", amount: 0.01, color: Color(red: 0.62, green: 0.68, blue: 0.77))]
            : sorted
    }

    private var monthlyData: [MonthlyExpense] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"

        let grouped = Dictionary(grouping: transactions, by: { $0.monthKey })
            .mapValues { items in
                items.reduce(0) { $0 + $1.amount }
            }

        return (0..<6).compactMap { offset in
            guard let date = calendar.date(byAdding: .month, value: -(5 - offset), to: Date()) else { return nil }
            let key = monthKey(for: date)
            return MonthlyExpense(
                month: formatter.string(from: date),
                amount: grouped[key] ?? 0
            )
        }
    }

    private var categoryChartSection: some View {
        HStack(spacing: 18) {
            ModernDonutChartView(data: categoryData)
                .frame(width: 146, height: 146)

            VStack(alignment: .leading, spacing: 12) {
                ForEach(categoryData) { item in
                    HStack(spacing: 10) {
                        Circle()
                            .fill(item.color)
                            .frame(width: 10, height: 10)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0.22, green: 0.26, blue: 0.34))

                            Text("$\(String(format: "%.2f", item.amount))")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(red: 0.60, green: 0.64, blue: 0.71))
                        }
                    }
                }
            }

            Spacer(minLength: 0)
        }
    }

    private var monthChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(monthlyData) { item in
                    VStack(spacing: 8) {
                        Text(item.amount > 0 ? shortAmount(item.amount) : "")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(red: 0.42, green: 0.46, blue: 0.54))
                            .frame(height: 16)

                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.54, green: 0.25, blue: 0.95), Color(red: 0.43, green: 0.20, blue: 0.86)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 28, height: barHeight(for: item.amount))

                        Text(item.month)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(red: 0.42, green: 0.46, blue: 0.54))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 190, alignment: .bottom)
        }
    }

    private var chartToggleButtons: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    selectedChart = .category
                }
            } label: {
                Text("By Category")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(selectedChart == .category ? .white : Color(red: 0.42, green: 0.46, blue: 0.54))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(
                                selectedChart == .category
                                ? LinearGradient(
                                    colors: [Color(red: 0.54, green: 0.25, blue: 0.95), Color(red: 0.43, green: 0.20, blue: 0.86)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                : LinearGradient(colors: [Color.clear, Color.clear], startPoint: .leading, endPoint: .trailing)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.gray.opacity(0.25), lineWidth: selectedChart == .category ? 0 : 1.5)
                            )
                    )
            }
            .buttonStyle(.plain)

            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    selectedChart = .month
                }
            } label: {
                Text("By Month")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(selectedChart == .month ? .white : Color(red: 0.42, green: 0.46, blue: 0.54))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(
                                selectedChart == .month
                                ? LinearGradient(
                                    colors: [Color(red: 0.54, green: 0.25, blue: 0.95), Color(red: 0.43, green: 0.20, blue: 0.86)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                : LinearGradient(colors: [Color.clear, Color.clear], startPoint: .leading, endPoint: .trailing)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .stroke(Color.gray.opacity(0.25), lineWidth: selectedChart == .month ? 0 : 1.5)
                            )
                    )
            }
            .buttonStyle(.plain)
        }
    }

    private func monthKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter.string(from: date)
    }

    private func shortAmount(_ amount: Double) -> String {
        if amount >= 1000 {
            return String(format: "$%.1fk", amount / 1000)
        }
        return String(format: "$%.0f", amount)
    }

    private func barHeight(for amount: Double) -> CGFloat {
        let maxAmount = max(monthlyData.map(\.amount).max() ?? 1, 1)
        let minHeight: CGFloat = amount > 0 ? 16 : 4
        let maxHeight: CGFloat = 116
        let normalized = amount / maxAmount
        return amount > 0 ? max(minHeight, CGFloat(normalized) * maxHeight) : minHeight
    }
}

struct ModernDonutChartView: View {
    let data: [CategoryItem]

    private var total: Double {
        max(data.reduce(0) { $0 + $1.amount }, 0.01)
    }

    var body: some View {
        ZStack {
            ForEach(Array(data.enumerated()), id: \.element.id) { index, item in
                ActivityDonutSlice(
                    startAngle: startAngle(for: index),
                    endAngle: endAngle(for: index)
                )
                .stroke(
                    item.color,
                    style: StrokeStyle(lineWidth: 22, lineCap: .butt, lineJoin: .round)
                )
            }

            Circle()
                .fill(Color(red: 0.95, green: 0.95, blue: 0.96))
                .frame(width: 60, height: 60)

            VStack(spacing: 2) {
                Text("$\(String(format: "%.0f", data.reduce(0) { $0 + $1.amount }))")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.22, green: 0.26, blue: 0.34))

                Text("Month")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(red: 0.60, green: 0.64, blue: 0.71))
            }
        }
        .rotationEffect(.degrees(-90))
    }

    private func startAngle(for index: Int) -> Angle {
        let previousTotal = data.prefix(index).reduce(0) { $0 + $1.amount }
        return .degrees((previousTotal / total) * 360)
    }

    private func endAngle(for index: Int) -> Angle {
        let currentTotal = data.prefix(index + 1).reduce(0) { $0 + $1.amount }
        return .degrees((currentTotal / total) * 360)
    }
}

struct ActivityTransactionRow: View {
    let item: TransactionItem

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(red: 0.91, green: 0.88, blue: 0.98))
                        .frame(width: 56, height: 56)

                    Image(systemName: iconName(for: item.category))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(red: 0.53, green: 0.28, blue: 0.95))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(red: 0.15, green: 0.19, blue: 0.26))
                        .lineLimit(1)

                    Text(item.subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.60, green: 0.64, blue: 0.71))
                        .lineLimit(1)
                }

                Spacer(minLength: 6)

                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "$%.2f", item.amount))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(red: 0.15, green: 0.19, blue: 0.26))

                    Text(item.date)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.60, green: 0.64, blue: 0.71))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 10)

            Divider()
                .background(Color.gray.opacity(0.2))
        }
    }

    private func iconName(for category: String) -> String {
        switch category {
        case "Food": return "fork.knife"
        case "Transport": return "car.fill"
        case "Shopping": return "bag.fill"
        case "Travel": return "airplane"
        default: return "receipt"
        }
    }
}

struct ActivityDonutSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)

        var path = Path()
        path.addArc(
            center: center,
            radius: radius - 14,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        return path
    }
}

#Preview {
    ContentView()
}
