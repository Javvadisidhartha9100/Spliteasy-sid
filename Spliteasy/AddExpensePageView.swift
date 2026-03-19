//
//  AddExpensePageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/19/26.
//

import SwiftUI

struct AddExpensePageView: View {
    @Binding var selectedTab: Tab

    @State private var withName: String = ""
    @State private var descriptionText: String = ""
    @State private var amountText: String = ""

    private let themePurple = Color.purple
    private let themeBorder = Color.purple.opacity(0.12)
    private let themeShadow = Color.purple.opacity(0.08)

    var body: some View {
        ZStack {
            Color.gray.opacity(0.12)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                    .padding(.horizontal, 20)
                    .padding(.top, 6)

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        withFieldSection
                            .padding(.top, 34)

                        inputRow(
                            iconName: "bag",
                            iconTint: Color.black,
                            iconBackground: Color.clear,
                            placeholder: "Enter description",
                            text: $descriptionText
                        )

                        inputRow(
                            iconName: "dollarsign.square.fill",
                            iconTint: Color(red: 0.03, green: 0.71, blue: 0.58),
                            iconBackground: Color(red: 0.03, green: 0.71, blue: 0.58).opacity(0.12),
                            placeholder: "Enter amount",
                            text: $amountText,
                            showPlusBadge: true
                        )

                        VStack(spacing: 18) {
                            actionButton(title: "Split equally")
                            actionButton(title: "custom")
                        }
                        .padding(.top, 18)

                        Spacer(minLength: 160)
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 4)
                }
            }
        }
    }

    private var headerSection: some View {
        HStack {
            Spacer()

            Button {
                print("Save tapped")
            } label: {
                Text("Save")
                    .font(.system(size: 24, weight: .bold))
                    .italic()
                    .foregroundColor(.black)
            }
            .buttonStyle(.plain)
        }
    }

    private var withFieldSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("With : friend name/ Group name")
                .font(.system(size: 20, weight: .bold))
                .italic()
                .foregroundColor(.black)

            TextField("", text: $withName)
                .font(.system(size: 18, weight: .bold))
                .italic()
                .foregroundColor(.black)

            Rectangle()
                .fill(Color.black.opacity(0.30))
                .frame(height: 1)
        }
    }

    private func inputRow(
        iconName: String,
        iconTint: Color,
        iconBackground: Color,
        placeholder: String,
        text: Binding<String>,
        showPlusBadge: Bool = false
    ) -> some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack(alignment: .bottomTrailing) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconBackground)
                    .frame(width: 38, height: 38)

                Image(systemName: iconName)
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(iconTint)

                if showPlusBadge {
                    ZStack {
                        Circle()
                            .fill(Color(red: 1.0, green: 0.08, blue: 0.33))
                            .frame(width: 20, height: 20)

                        Image(systemName: "plus")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(x: 8, y: 8)
                }
            }
            .frame(width: 42)

            VStack(alignment: .leading, spacing: 6) {
                TextField(
                    "",
                    text: text,
                    prompt: Text(placeholder)
                        .foregroundColor(Color.black.opacity(0.82))
                )
                .font(.system(size: 18, weight: .bold))
                .italic()
                .foregroundColor(.black)

                Rectangle()
                    .fill(Color.black.opacity(0.30))
                    .frame(height: 1)
            }
        }
    }

    private func actionButton(title: String) -> some View {
        Button {
            print("\(title) tapped")
        } label: {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .italic()
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 58)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(themeBorder, lineWidth: 1)
                        )
                        .shadow(color: themeShadow, radius: 10, x: 0, y: 6)
                )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 62)
    }
}
