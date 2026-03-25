import SwiftUI

enum AppThemeMode: String, CaseIterable {
    case light
    case dark
    case auto

    var title: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .auto: return "Auto"
        }
    }

    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .auto: return "clock.fill"
        }
    }
}

struct ThemeHeaderButton: View {
    @Binding var showThemeMenu: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                showThemeMenu = true
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppPalette.card)
                    .frame(width: 46, height: 46)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(AppPalette.border, lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.10), radius: 8, x: 0, y: 4)

                Image(systemName: colorScheme == .dark ? "moon.stars.fill" : "sun.max.fill")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppPalette.accentMid)
            }
        }
        .buttonStyle(.plain)
    }
}

struct ThemeSideMenuView: View {
    @Binding var showThemeMenu: Bool
    @Binding var selectedTheme: AppThemeMode

    var body: some View {
        ZStack(alignment: .leading) {
            Color.black.opacity(0.25)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                        showThemeMenu = false
                    }
                }

            VStack(alignment: .leading, spacing: 22) {
                HStack {
                    Text("Appearance")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(AppPalette.primaryText)
                        .padding(.top, -80)
                }

                Text("Choose how the app looks")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(AppPalette.secondaryText)
                    .padding(.top, -65)

                VStack(spacing: 12) {
                    ForEach(AppThemeMode.allCases, id: \.self) { mode in
                        Button {
                            selectedTheme = mode
                            withAnimation(.spring(response: 0.32, dampingFraction: 0.82)) {
                                showThemeMenu = false
                            }
                        } label: {
                            HStack(spacing: 14) {
                                ZStack {
                                    Circle()
                                        .fill(selectedTheme == mode ? AppPalette.accentMid.opacity(0.14) : Color.gray.opacity(0.10))
                                        .frame(width: 44, height: 44)

                                    Image(systemName: mode.icon)
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(selectedTheme == mode ? AppPalette.accentMid : AppPalette.secondaryText)
                                }

                                Text(mode.title)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(AppPalette.primaryText)

                                Spacer()

                                Image(systemName: selectedTheme == mode ? "checkmark.circle.fill" : "circle")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(selectedTheme == mode ? AppPalette.accentMid : AppPalette.secondaryText.opacity(0.5))
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(AppPalette.card)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .stroke(selectedTheme == mode ? AppPalette.accentMid.opacity(0.25) : AppPalette.border, lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 70)
            .frame(width: 290)
            .frame(maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [AppPalette.backgroundTop, AppPalette.backgroundBottom],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .transition(.move(edge: .leading))
        }
    }
}

#Preview {
    ContentView()
}

