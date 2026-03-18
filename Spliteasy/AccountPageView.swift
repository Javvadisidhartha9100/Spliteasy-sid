//
//  AccountPageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/17/26.
//

import SwiftUI

struct AccountPageView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                headerSection
                    .padding(.horizontal, 20)
                    .padding(.top, 6)

                profileHeaderCard
                    .padding(.top, 22)
                    .padding(.horizontal, 20)

                infoCard
                    .padding(.top, 18)
                    .padding(.horizontal, 20)

                singleOptionCard(
                    iconName: "star",
                    iconColor: Color.orange,
                    iconBackground: Color.orange.opacity(0.10),
                    title: "Feedback"
                )
                .padding(.top, 18)
                .padding(.horizontal, 20)

                singleOptionCard(
                    iconName: "message",
                    iconColor: Color.teal,
                    iconBackground: Color.teal.opacity(0.10),
                    title: "Contact Us"
                )
                .padding(.top, 18)
                .padding(.horizontal, 20)

                signOutButton
                    .padding(.top, 22)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 34)
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.95, blue: 1.0),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    private var headerSection: some View {
        HStack {
            Text("Profile")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(red: 0.10, green: 0.14, blue: 0.22))

            Spacer()

            Button(action: {}) {
                Image(systemName: "pencil")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(width: 46, height: 46)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.gray.opacity(0.08))
                    )
            }
            .buttonStyle(.plain)
        }
    }

    private var profileHeaderCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.54, green: 0.25, blue: 0.95),
                                Color(red: 0.43, green: 0.20, blue: 0.86)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 78, height: 78)
                    .shadow(color: Color.purple.opacity(0.16), radius: 8, x: 0, y: 4)

                Text("S")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Sidhartha Javvadi")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(red: 0.10, green: 0.14, blue: 0.22))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text("javvadisidhartha9100@gmail.com")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.blue.opacity(0.9))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }

            Spacer()
        }
    }

    private var infoCard: some View {
        VStack(spacing: 0) {
            settingsRow(
                iconName: "bell",
                iconColor: Color.purple.opacity(0.8),
                iconBackground: Color.purple.opacity(0.10),
                title: "Notification",
                trailingText: nil,
                showCheck: false
            )

            Divider()
                .opacity(0.18)

            settingsRow(
                iconName: "phone",
                iconColor: Color.blue.opacity(0.8),
                iconBackground: Color.blue.opacity(0.10),
                title: "Phone No",
                trailingText: "—",
                showCheck: false
            )

            Divider()
                .opacity(0.18)

            settingsRow(
                iconName: "envelope",
                iconColor: Color.pink.opacity(0.85),
                iconBackground: Color.pink.opacity(0.10),
                title: "Email",
                trailingText: "javvadisidhartha9100@gmail.com",
                showCheck: true
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.purple.opacity(0.10), lineWidth: 1)
                )
                .shadow(color: Color.purple.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }

    private func settingsRow(
        iconName: String,
        iconColor: Color,
        iconBackground: Color,
        title: String,
        trailingText: String?,
        showCheck: Bool
    ) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 14)
                .fill(iconBackground)
                .frame(width: 52, height: 52)
                .overlay(
                    Image(systemName: iconName)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(iconColor)
                )

            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(Color(red: 0.25, green: 0.29, blue: 0.37))

            Spacer()

            if let trailingText {
                Text(trailingText)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            if showCheck {
                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.green)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.gray.opacity(0.4))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func singleOptionCard(
        iconName: String,
        iconColor: Color,
        iconBackground: Color,
        title: String
    ) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 14)
                .fill(iconBackground)
                .frame(width: 52, height: 52)
                .overlay(
                    Image(systemName: iconName)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(iconColor)
                )

            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(Color(red: 0.25, green: 0.29, blue: 0.37))

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.gray.opacity(0.4))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.purple.opacity(0.08), lineWidth: 1)
                )
        )
    }

    private var signOutButton: some View {
        Button(action: {}) {
            Text("Sign Out")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.54, green: 0.25, blue: 0.95),
                                    Color(red: 0.43, green: 0.20, blue: 0.86)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: Color.purple.opacity(0.20), radius: 10, x: 0, y: 6)
                )
        }
        .buttonStyle(.plain)
    }
}

