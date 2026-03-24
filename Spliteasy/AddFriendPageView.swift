import SwiftUI

struct AddFriendPageView: View {
    @Binding var selectedTab: Tab
    @Binding var showAddFriendPage: Bool
    let onSaveFriend: (String, String) -> Void

    @State private var friendName: String = ""
    @State private var contactText: String = ""

    private let cardBorder = Color.purple.opacity(0.12)
    private let cardShadow = Color.purple.opacity(0.08)

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.95, blue: 1.0),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    headerSection
                        .padding(.top, 8)

                    friendNameCard
                    contactCard
                    actionPreviewCard

                    Spacer(minLength: 120)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
    }

    private var headerSection: some View {
        HStack {
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showAddFriendPage = false
                    selectedTab = .friends
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.white)
                        .frame(width: 46, height: 46)
                        .shadow(color: cardShadow, radius: 8, x: 0, y: 4)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Add Friend")
                .font(.system(size: 24, weight: .bold))
                .italic()
                .foregroundColor(.black)

            Spacer()

            Button {
                saveFriend()
            } label: {
                Text("Save")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [
                                Color(red: 0.54, green: 0.25, blue: 0.95),
                                Color(red: 0.43, green: 0.20, blue: 0.86)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color.purple.opacity(0.18), radius: 8, x: 0, y: 4)
                    .opacity(trimmedName.isEmpty ? 0.65 : 1.0)
            }
            .buttonStyle(.plain)
            .disabled(trimmedName.isEmpty)
        }
    }

    private var friendNameCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Friend Name")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.gray)

            TextField("Enter friend name", text: $friendName)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)

            Rectangle()
                .fill(Color.purple.opacity(0.15))
                .frame(height: 1)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(cardBorder, lineWidth: 1)
                )
                .shadow(color: cardShadow, radius: 8, x: 0, y: 5)
        )
    }

    private var contactCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Phone or Email")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.gray)

            TextField("Enter phone number or email", text: $contactText)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .keyboardType(UIKeyboardType.emailAddress)

            Rectangle()
                .fill(Color.purple.opacity(0.15))
                .frame(height: 1)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(cardBorder, lineWidth: 1)
                )
                .shadow(color: cardShadow, radius: 8, x: 0, y: 5)
        )
    }

    private var actionPreviewCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.system(size: 20, weight: .bold))
                .italic()
                .foregroundColor(.black)

            HStack(spacing: 12) {
                previewButton(icon: "arrow.left.arrow.right", title: "Settle up")
                previewButton(icon: "bell", title: "Remind")
            }
        }
    }

    private func previewButton(icon: String, title: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(Color(red: 0.53, green: 0.28, blue: 0.95))

            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 88)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(cardBorder, lineWidth: 1)
                )
                .shadow(color: cardShadow, radius: 8, x: 0, y: 5)
        )
    }

    private var trimmedName: String {
        friendName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func saveFriend() {
        guard !trimmedName.isEmpty else { return }

        onSaveFriend(
            trimmedName,
            contactText.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        showAddFriendPage = false
        selectedTab = .friends
    }
}
