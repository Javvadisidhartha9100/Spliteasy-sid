import SwiftUI

struct AppNotificationItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let message: String
    let timeText: String
}

struct AccountPageView: View {
    @Binding var showThemeMenu: Bool
    @Binding var profileName: String
    @Binding var profileEmail: String
    @Binding var profilePhone: String

    let notifications: [AppNotificationItem]
    let onSaveProfile: (_ name: String, _ email: String, _ phone: String, _ password: String) -> Void
    let onSubmitFeedback: (_ rating: Int, _ message: String) -> Void
    let onContactSupport: (_ subject: String, _ message: String) -> Void
    let onSignOut: () -> Void

    @State private var showEditProfileSheet = false
    @State private var showNotificationsSheet = false
    @State private var showFeedbackSheet = false
    @State private var showContactSheet = false

    @State private var profileNickname: String = "SID"
    @State private var selectedAvatarIndex: Int = 0

    private let avatarOptions: [AvatarStyle] = [
        AvatarStyle(
            icon: "person.fill",
            gradient: [Color(red: 0.08, green: 0.68, blue: 1.0), Color(red: 0.14, green: 0.55, blue: 0.98)]
        ),
        AvatarStyle(
            icon: "person.crop.circle.fill",
            gradient: [Color(red: 0.15, green: 0.78, blue: 1.0), Color(red: 0.32, green: 0.36, blue: 1.0)]
        ),
        AvatarStyle(
            icon: "sparkles",
            gradient: [Color(red: 0.12, green: 0.69, blue: 1.0), Color(red: 0.45, green: 0.22, blue: 0.98)]
        ),
        AvatarStyle(
            icon: "moon.stars.fill",
            gradient: [Color(red: 0.08, green: 0.72, blue: 1.0), Color(red: 0.18, green: 0.43, blue: 0.98)]
        )
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                headerSection
                    .padding(.horizontal, 20)
                    .padding(.top, 0)

                profileHeaderCard
                    .padding(.top, 18)
                    .padding(.horizontal, 20)

                phoneCard
                    .padding(.top, 18)
                    .padding(.horizontal, 20)

                emailCard
                    .padding(.top, 18)
                    .padding(.horizontal, 20)

                notificationCard
                    .padding(.top, 18)
                    .padding(.horizontal, 20)

                Button {
                    showFeedbackSheet = true
                } label: {
                    singleOptionCard(
                        iconName: "star",
                        iconColor: Color.orange,
                        iconBackground: Color.orange.opacity(0.12),
                        title: "Feedback"
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 18)
                .padding(.horizontal, 20)

                Button {
                    showContactSheet = true
                } label: {
                    singleOptionCard(
                        iconName: "message",
                        iconColor: Color.teal,
                        iconBackground: Color.teal.opacity(0.12),
                        title: "Contact Us"
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 18)
                .padding(.horizontal, 20)

                signOutButton
                    .padding(.top, 22)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 34)
            }
            .padding(.top, 8)
        }
        .ignoresSafeArea(edges: .top)
        .background(
            LinearGradient(
                colors: [AppPalette.backgroundTop, AppPalette.backgroundBottom],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .sheet(isPresented: $showEditProfileSheet) {
            EditProfileSheet(
                name: profileName,
                nickname: profileNickname,
                email: profileEmail,
                phone: profilePhone,
                selectedAvatarIndex: selectedAvatarIndex,
                avatarOptions: avatarOptions,
                onSave: { name, nickname, email, phone, password, avatarIndex in
                    profileNickname = nickname.isEmpty ? "SID" : nickname
                    selectedAvatarIndex = avatarIndex
                    onSaveProfile(name, email, phone, password)
                }
            )
        }
        .sheet(isPresented: $showNotificationsSheet) {
            NotificationsSheet(items: notifications)
        }
        .sheet(isPresented: $showFeedbackSheet) {
            FeedbackSheet { rating, message in
                onSubmitFeedback(rating, message)
            }
        }
        .sheet(isPresented: $showContactSheet) {
            ContactSupportSheet { subject, message in
                onContactSupport(subject, message)
            }
        }
    }

    private var currentAvatar: AvatarStyle {
        avatarOptions[selectedAvatarIndex % avatarOptions.count]
    }

    private var formattedProfilePhone: String {
        formattedPhone(profilePhone)
    }

    private var headerSection: some View {
        HStack {
            ThemeHeaderButton(showThemeMenu: $showThemeMenu)

            Spacer()

            Button {
                showEditProfileSheet = true
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppPalette.secondaryText)
                    .frame(width: 46, height: 46)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(AppPalette.card)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(AppPalette.border, lineWidth: 1)
                            )
                    )
            }
            .buttonStyle(.plain)
            .padding(.top, 15)
        }
    }

    private var profileHeaderCard: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: currentAvatar.gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 78, height: 78)
                    .shadow(color: AppPalette.accentMid.opacity(0.16), radius: 8, x: 0, y: 4)

                Image(systemName: currentAvatar.icon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(profileNickname)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(AppPalette.primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(profileEmail)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.blue.opacity(0.92))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }

            Spacer()
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .appCardStyle()
    }

    private var phoneCard: some View {
        singleInfoCard(
            iconName: "phone",
            iconColor: Color.blue.opacity(0.85),
            iconBackground: Color.blue.opacity(0.12),
            title: "Phone No",
            trailingText: formattedProfilePhone.isEmpty ? "—" : formattedProfilePhone,
            showCheck: true,
            action: nil
        )
    }

    private var emailCard: some View {
        singleInfoCard(
            iconName: "envelope",
            iconColor: Color.pink.opacity(0.90),
            iconBackground: Color.pink.opacity(0.12),
            title: "Email",
            trailingText: profileEmail,
            showCheck: true,
            action: nil
        )
    }

    private var notificationCard: some View {
        singleInfoCard(
            iconName: "bell",
            iconColor: Color.purple.opacity(0.85),
            iconBackground: Color.purple.opacity(0.12),
            title: "Notification",
            trailingText: nil,
            showCheck: false,
            action: {
                showNotificationsSheet = true
            }
        )
    }

    private func singleInfoCard(
        iconName: String,
        iconColor: Color,
        iconBackground: Color,
        title: String,
        trailingText: String?,
        showCheck: Bool,
        action: (() -> Void)?
    ) -> some View {
        Button {
            action?()
        } label: {
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
                    .foregroundColor(AppPalette.primaryText)

                Spacer()

                if let trailingText {
                    Text(trailingText)
                        .font(.system(size: 13))
                        .foregroundColor(AppPalette.secondaryText)
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
                        .foregroundColor(AppPalette.secondaryText.opacity(0.7))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppPalette.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(AppPalette.border, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
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
                .foregroundColor(AppPalette.primaryText)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppPalette.secondaryText.opacity(0.7))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(AppPalette.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppPalette.border, lineWidth: 1)
                )
        )
    }

    private var signOutButton: some View {
        Button {
            onSignOut()
        } label: {
            Text("Sign Out")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [AppPalette.accentStart, AppPalette.accentEnd],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: AppPalette.accentMid.opacity(0.20), radius: 10, x: 0, y: 6)
                )
        }
        .buttonStyle(.plain)
    }

    private func formattedPhone(_ input: String) -> String {
        let digits = input.filter(\.isNumber)
        guard !digits.isEmpty else { return "" }

        let trimmed = String(digits.prefix(10))
        let count = trimmed.count

        if count <= 3 {
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

struct AvatarStyle: Hashable {
    let icon: String
    let gradient: [Color]
}

struct EditProfileSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var nickname: String
    @State private var email: String
    @State private var phone: String
    @State private var selectedAvatarIndex: Int

    @State private var showResetPassword = false
    @State private var currentPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmNewPassword: String = ""

    let avatarOptions: [AvatarStyle]
    let onSave: (_ name: String, _ nickname: String, _ email: String, _ phone: String, _ password: String, _ avatarIndex: Int) -> Void

    init(
        name: String,
        nickname: String,
        email: String,
        phone: String,
        selectedAvatarIndex: Int,
        avatarOptions: [AvatarStyle],
        onSave: @escaping (_ name: String, _ nickname: String, _ email: String, _ phone: String, _ password: String, _ avatarIndex: Int) -> Void
    ) {
        _name = State(initialValue: name)
        _nickname = State(initialValue: nickname)
        _email = State(initialValue: email)
        _phone = State(initialValue: EditProfileSheet.formatPhone(phone))
        _selectedAvatarIndex = State(initialValue: selectedAvatarIndex)
        self.avatarOptions = avatarOptions
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    profileEditorHeader

                    sheetTextField(title: "Name", text: $name, placeholder: "Enter name")
                    sheetTextField(title: "Mobile Number", text: $phone, placeholder: "Enter mobile number", isPhone: true)
                    sheetTextField(title: "Email", text: $email, placeholder: "Enter email")
                    sheetTextField(title: "Nickname", text: $nickname, placeholder: "Enter nickname")
                    resetPasswordCard
                }
                .padding(20)
            }
            .background(
                LinearGradient(
                    colors: [AppPalette.backgroundTop, AppPalette.backgroundBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let passwordToSave = showResetPassword ? newPassword : ""
                        onSave(
                            name.trimmingCharacters(in: .whitespacesAndNewlines),
                            nickname.trimmingCharacters(in: .whitespacesAndNewlines),
                            email.trimmingCharacters(in: .whitespacesAndNewlines),
                            EditProfileSheet.formatPhone(phone),
                            passwordToSave,
                            selectedAvatarIndex
                        )
                        dismiss()
                    }
                    .disabled(!canSaveProfile)
                }
            }
        }
    }

    private var currentAvatar: AvatarStyle {
        avatarOptions[selectedAvatarIndex % avatarOptions.count]
    }

    private var profileEditorHeader: some View {
        VStack(spacing: 10) {
            Button {
                selectedAvatarIndex = (selectedAvatarIndex + 1) % avatarOptions.count
            } label: {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: currentAvatar.gradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 94, height: 94)
                        .shadow(color: AppPalette.accentMid.opacity(0.18), radius: 10, x: 0, y: 4)

                    Image(systemName: currentAvatar.icon)
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(.white)

                    Circle()
                        .fill(AppPalette.card)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "camera.fill")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(AppPalette.accentMid)
                        )
                        .offset(x: 4, y: 2)
                }
            }
            .buttonStyle(.plain)

            Text(nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "SID" : nickname)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppPalette.primaryText)

            Text("Tap photo to change")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppPalette.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 4)
    }

    private func sheetTextField(
        title: String,
        text: Binding<String>,
        placeholder: String,
        isPhone: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: Font.Weight.semibold))
                .foregroundColor(AppPalette.secondaryText)

            TextField(placeholder, text: text)
                .onChange(of: text.wrappedValue) { _, newValue in
                    if isPhone {
                        text.wrappedValue = EditProfileSheet.formatPhone(newValue)
                    }
                }
                .font(.system(size: 17, weight: Font.Weight.semibold))
                .foregroundColor(AppPalette.primaryText)
                .padding(Edge.Set.horizontal, 14)
                .padding(Edge.Set.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: RoundedCornerStyle.continuous)
                        .fill(AppPalette.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: RoundedCornerStyle.continuous)
                                .stroke(AppPalette.border, lineWidth: 1)
                        )
                )
        }
    }

    private var resetPasswordCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showResetPassword.toggle()

                    if !showResetPassword {
                        currentPassword = ""
                        newPassword = ""
                        confirmNewPassword = ""
                    }
                }
            } label: {
                HStack {
                    Text("Reset Password")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(AppPalette.accentMid)

                    Spacer()

                    Image(systemName: showResetPassword ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(AppPalette.accentMid)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(AppPalette.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(AppPalette.border, lineWidth: 1)
                        )
                )
            }
            .buttonStyle(.plain)

            if showResetPassword {
                VStack(spacing: 14) {
                    secureInput(title: "Current Password", text: $currentPassword, placeholder: "Enter current password")
                    secureInput(title: "New Password", text: $newPassword, placeholder: "Enter new password")
                    secureInput(title: "Re-enter New Password", text: $confirmNewPassword, placeholder: "Re-enter new password")

                    if !confirmNewPassword.isEmpty && newPassword != confirmNewPassword {
                        Text("New passwords do not match")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.red.opacity(0.85))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }

    private func secureInput(title: String, text: Binding<String>, placeholder: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppPalette.secondaryText)

            SecureField(placeholder, text: text)
                .textContentType(.oneTimeCode)
                .autocorrectionDisabled(true)
                .font(.system(size: 17, weight: Font.Weight.semibold))
                .foregroundColor(AppPalette.primaryText)
                .padding(Edge.Set.horizontal, 14)
                .padding(Edge.Set.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(AppPalette.card)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(AppPalette.border, lineWidth: 1)
                        )
                )
        }
    }

    private var canSaveProfile: Bool {
        let basicValid =
            !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        if !showResetPassword {
            return basicValid
        }

        return basicValid &&
            !currentPassword.isEmpty &&
            !newPassword.isEmpty &&
            !confirmNewPassword.isEmpty &&
            newPassword == confirmNewPassword
    }

    private static func formatPhone(_ input: String) -> String {
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

struct NotificationsSheet: View {
    let items: [AppNotificationItem]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    if items.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "bell.slash")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(AppPalette.secondaryText)

                            Text("No recent notifications")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppPalette.secondaryText)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
                        ForEach(items) { item in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(item.title)
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(AppPalette.primaryText)

                                    Spacer()

                                    Text(item.timeText)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(AppPalette.secondaryText)
                                }

                                Text(item.message)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(AppPalette.secondaryText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(16)
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
                .padding(20)
            }
            .background(
                LinearGradient(
                    colors: [AppPalette.backgroundTop, AppPalette.backgroundBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeedbackSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var rating: Int = 0
    @State private var message: String = ""

    let onSubmit: (_ rating: Int, _ message: String) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                Text("Rate your experience")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(AppPalette.primaryText)
                    .padding(.top, 16)

                HStack(spacing: 12) {
                    ForEach(1...5, id: \.self) { index in
                        Button {
                            rating = index
                        } label: {
                            Image(systemName: rating >= index ? "star.fill" : "star")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.orange)
                        }
                        .buttonStyle(.plain)
                    }
                }

                TextEditor(text: $message)
                    .frame(height: 180)
                    .padding(12)
                    .scrollContentBackground(.hidden)
                    .background(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(AppPalette.card)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(AppPalette.border, lineWidth: 1)
                            )
                    )
                    .foregroundColor(AppPalette.primaryText)

                Button {
                    onSubmit(rating, message.trimmingCharacters(in: .whitespacesAndNewlines))
                    dismiss()
                } label: {
                    Text("Submit Feedback")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
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
                .disabled(rating == 0)

                Spacer()
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [AppPalette.backgroundTop, AppPalette.backgroundBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Feedback")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ContactSupportSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var subject: String = ""
    @State private var message: String = ""

    let onSend: (_ subject: String, _ message: String) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Subject")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppPalette.secondaryText)

                    TextField("Enter subject", text: $subject)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(AppPalette.primaryText)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(AppPalette.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(AppPalette.border, lineWidth: 1)
                                )
                        )
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Message")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppPalette.secondaryText)

                    TextEditor(text: $message)
                        .frame(height: 220)
                        .padding(12)
                        .scrollContentBackground(.hidden)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(AppPalette.card)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .stroke(AppPalette.border, lineWidth: 1)
                                )
                        )
                        .foregroundColor(AppPalette.primaryText)
                }

                Button {
                    onSend(
                        subject.trimmingCharacters(in: .whitespacesAndNewlines),
                        message.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                    dismiss()
                } label: {
                    Text("Send")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
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
                .disabled(subject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Spacer()
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [AppPalette.backgroundTop, AppPalette.backgroundBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .navigationTitle("Contact Us")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
