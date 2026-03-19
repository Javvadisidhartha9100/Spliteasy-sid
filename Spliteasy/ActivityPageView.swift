//
//  ActivityPageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/17/26.
//

import SwiftUI

struct ActivityPageView: View {
    @State private var selectedChart: ActivityChartType = .category

    private let categoryData: [CategoryItem] = [
        .init(name: "Other", amount: 4000, color: Color(red: 0.62, green: 0.68, blue: 0.77)),
        .init(name: "Shopping", amount: 187, color: Color(red: 0.89, green: 0.27, blue: 0.58)),
        .init(name: "Food", amount: 87, color: Color(red: 0.49, green: 0.38, blue: 0.78)),
        .init(name: "Transport", amount: 45, color: Color(red: 0.38, green: 0.39, blue: 0.88))
    ]

    private let monthlyData: [MonthlyExpense] = [
        .init(month: "Oct", amount: 0),
        .init(month: "Nov", amount: 0),
        .init(month: "Dec", amount: 0),
        .init(month: "Jan", amount: 0),
        .init(month: "Feb", amount: 2300),
        .init(month: "Mar", amount: 4200)
    ]

    private let transactions: [TransactionItem] = [
        .init(title: "trip to nyc", subtitle: "Sidhartha Javvadi paid · 3 people", amount: 4000.00, date: "Mar 16"),
        .init(title: "walmart", subtitle: "You paid · 3 people", amount: 120.00, date: "Mar 12"),
        .init(title: "Groceries", subtitle: "Taylor paid · 3 people", amount: 67.30, date: "Mar 11"),
        .init(title: "Dinner at Olive Garden", subtitle: "You paid · 4 people", amount: 86.50, date: "Mar 9"),
        .init(title: "Uber to Airport", subtitle: "Alex paid · 4 people", amount: 45.00, date: "Mar 8"),
        .init(title: "March Rent", subtitle: "You paid · 3 people", amount: 2400.00, date: "Feb 28")
    ]

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
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(Color(red: 0.05, green: 0.10, blue: 0.18))

            Text("All your transactions")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(red: 0.60, green: 0.64, blue: 0.71))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 6)
    }

    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(selectedChart == .category ? "This Month by Category" : "Monthly Expenses")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(red: 0.25, green: 0.29, blue: 0.37))

                    Text(selectedChart == .category ? "March 2026" : "Last 6 months")
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

    private var categoryChartSection: some View {
        VStack(spacing: 12) {
            ModernDonutChartView(data: categoryData)
                .frame(height: 130)

            VStack(spacing: 8) {
                ForEach(categoryData) { item in
                    HStack(spacing: 10) {
                        Circle()
                            .fill(item.color)
                            .frame(width: 10, height: 10)

                        Text(item.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.29, green: 0.34, blue: 0.42))

                        Spacer()

                        Text("$\(Int(item.amount))")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(red: 0.16, green: 0.20, blue: 0.28))
                    }
                }
            }
        }
    }

    private var monthChartSection: some View {
        let chartHeight: CGFloat = 120
        let maxValue: Double = 6000

        return VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .trailing, spacing: 0) {
                    Spacer().frame(height: 2)
                    Text("$6000")
                    Spacer()
                    Text("$4500")
                    Spacer()
                    Text("$3000")
                    Spacer()
                    Text("$1500")
                    Spacer()
                    Text("$0")
                }
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color(red: 0.60, green: 0.64, blue: 0.71))
                .frame(width: 42, height: chartHeight)

                VStack(spacing: 0) {
                    ZStack(alignment: .bottom) {
                        VStack(spacing: chartHeight / 4) {
                            ForEach(0..<5, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(height: 1)
                            }
                        }

                        HStack(alignment: .bottom, spacing: 18) {
                            ForEach(monthlyData) { item in
                                VStack(spacing: 8) {
                                    ZStack(alignment: .bottom) {
                                        Color.clear
                                            .frame(width: 28, height: chartHeight)

                                        if item.amount > 0 {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(
                                                    item.month == "Mar"
                                                    ? Color(red: 0.50, green: 0.39, blue: 0.77)
                                                    : Color(red: 0.70, green: 0.64, blue: 0.88)
                                                )
                                                .frame(width: 28, height: CGFloat(item.amount / maxValue) * chartHeight)
                                        }
                                    }

                                    Text(item.month)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(Color(red: 0.60, green: 0.64, blue: 0.71))
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .frame(height: chartHeight + 24)
            }
        }
        .frame(height: 165)
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
}

struct ModernDonutChartView: View {
    let data: [CategoryItem]

    private var total: Double {
        data.reduce(0) { $0 + $1.amount }
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

                    Image(systemName: "receipt")
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
