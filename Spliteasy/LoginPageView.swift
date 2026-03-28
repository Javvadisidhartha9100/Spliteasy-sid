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
    @State private var showSignUpPage = false

    let onLogin: () -> Void
    let onSignUp: (_ name: String, _ nickname: String, _ email: String, _ phone: String) -> Void

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
                        Button {
                            showSignUpPage = true
                        } label: {
                            Text("Sign Up")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppPalette.accentMid)
                        }
                        .buttonStyle(.plain)

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
        .sheet(isPresented: $showSignUpPage) {
            SignUpPageView { name, nickname, email, phone in
                showSignUpPage = false
                onSignUp(name, nickname, email, phone)
            }
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

struct SignUpPageView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var fullName: String = ""
    @State private var nickname: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showSuccessMessage = false

    let onSignUp: (_ name: String, _ nickname: String, _ email: String, _ phone: String) -> Void

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

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 22) {
                        VStack(spacing: 10) {
                            Text("Create Account")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(AppPalette.primaryText)

                            Text("Sign up to start using SplitEasy")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppPalette.secondaryText)
                        }
                        .padding(.top, 26)

                        VStack(spacing: 16) {
                            field(title: "Full Name", text: $fullName, placeholder: "Enter full name")
                            field(title: "Nickname", text: $nickname, placeholder: "Enter nickname")
                            field(title: "Email", text: $email, placeholder: "Enter email")
                            field(title: "Phone Number", text: $phone, placeholder: "Enter phone number", isPhone: true)
                            secureField(title: "Password", text: $password, placeholder: "Enter password")
                            secureField(title: "Confirm Password", text: $confirmPassword, placeholder: "Re-enter password")
                        }

                        Button {
                            showSuccessMessage = true
                            let savedName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
                            let savedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
                            let savedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                            let savedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                dismiss()
                                onSignUp(savedName, savedNickname, savedEmail, savedPhone)
                            }
                        } label: {
                            Text("Create Account")
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
                        .disabled(!canSignUp)
                        .opacity(canSignUp ? 1.0 : 0.65)

                        if showSuccessMessage {
                            VStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 32, weight: .semibold))
                                    .foregroundColor(AppPalette.accentMid)

                                Text("Account created")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(AppPalette.primaryText)

                                Text("Welcome to SplitEasy.")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppPalette.secondaryText)
                            }
                            .padding(.top, 4)
                        }

                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
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

            Text("Sign Up")
                .font(.system(size: 24, weight: .bold))
                .italic()
                .foregroundColor(AppPalette.primaryText)

            Spacer()

            Color.clear
                .frame(width: 46, height: 46)
        }
    }

    private func field(
        title: String,
        text: Binding<String>,
        placeholder: String,
        isPhone: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppPalette.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            TextField(placeholder, text: text)
                .onChange(of: text.wrappedValue) { _, newValue in
                    if isPhone {
                        text.wrappedValue = formatPhone(newValue)
                    }
                }
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

    private func secureField(
        title: String,
        text: Binding<String>,
        placeholder: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppPalette.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)

            SecureField(placeholder, text: text)
                .textContentType(.oneTimeCode)
                .autocorrectionDisabled(true)
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

    private var canSignUp: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        password == confirmPassword
    }

    private func formatPhone(_ input: String) -> String {
        let digits = input.filter(\.isNumber)
        let trimmed = String(digits.prefix(10))
        let count = trimmed.count

        if count == 0 {
            return ""
        } else if count <= 3 {
            return "(\(trimmed)"
        } else if count <= 6 {
            let area = String(trimmed.prefix(3))
            let rest = String(trimmed.dropFirst(3))
            return "(\(area)) \(rest)"
        } else {
            let area = String(trimmed.prefix(3))
            let middle = String(trimmed.dropFirst(3).prefix(3))
            let last = String(trimmed.dropFirst(6))
            return "(\(area)) \(middle)-\(last)"
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
