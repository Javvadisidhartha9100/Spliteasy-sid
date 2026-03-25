//
//  LoginPageView.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/25/26.
//

import SwiftUI

struct LoginPageView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showForgotPasswordPage = false

    let onLogin: () -> Void

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppPalette.backgroundTop, AppPalette.backgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()

                VStack(spacing: 10) {
                    Text("SplitEasy")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(AppPalette.primaryText)

                    Text("Login to continue")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppPalette.secondaryText)
                }

                VStack(spacing: 16) {
                    field(title: "Email", text: $email, placeholder: "Enter email")

                    SecureField("Enter password", text: $password)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(AppPalette.primaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(AppPalette.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(AppPalette.border, lineWidth: 1)
                                )
                        )

                    HStack {
                        Spacer()

                        Button {
                            showForgotPasswordPage = true
                        } label: {
                            Text("Forgot Password?")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppPalette.accentMid)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)

                Button {
                    onLogin()
                } label: {
                    Text("Login")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [AppPalette.accentStart, AppPalette.accentEnd],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)

                Spacer()
            }
        }
        .sheet(isPresented: $showForgotPasswordPage) {
            ForgotPasswordPageView()
        }
    }

    private func field(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppPalette.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField(placeholder, text: text)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(AppPalette.primaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(AppPalette.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke(AppPalette.border, lineWidth: 1)
                        )
                )
        }
    }
}

struct ForgotPasswordPageView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var recoveryText: String = ""
    @State private var showConfirmation = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppPalette.backgroundTop, AppPalette.backgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                headerView
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                VStack(spacing: 22) {
                    Spacer()

                    VStack(spacing: 10) {
                        Text("Verify Account")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(AppPalette.primaryText)

                        Text("Enter your email or phone number")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppPalette.secondaryText)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Email or Phone Number")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(AppPalette.secondaryText)

                        TextField("Enter email or phone number", text: $recoveryText)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(AppPalette.primaryText)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(AppPalette.card)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(AppPalette.border, lineWidth: 1)
                                    )
                            )
                    }
                    .padding(.horizontal, 24)

                    Button {
                        showConfirmation = true
                    } label: {
                        Text("Send Reset Link")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(
                                        LinearGradient(
                                            colors: [AppPalette.accentStart, AppPalette.accentEnd],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 24)
                    .disabled(recoveryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(recoveryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.65 : 1.0)

                    if showConfirmation {
                        VStack(spacing: 8) {
                            Image(systemName: "envelope.badge")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(AppPalette.accentMid)

                            Text("Reset link sent")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(AppPalette.primaryText)

                            Text("A password reset link has been sent to your registered email.")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppPalette.secondaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                    }

                    Spacer()
                }
            }
        }
    }

    private var headerView: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppPalette.card)
                        .frame(width: 46, height: 46)
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(AppPalette.primaryText)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Forgot Password")
                .font(.system(size: 24, weight: .bold))
                .italic()
                .foregroundColor(AppPalette.primaryText)

            Spacer()

            Color.clear
                .frame(width: 46, height: 46)
        }
    }
}
