//
//  AppPalette.swift
//  Spliteasy
//
//  Created by SIDHARTHA JAVVADI on 3/24/26.
//

//
//  AppPalette.swift
//  Spliteasy
//

import SwiftUI

enum AppPalette {
    static let backgroundTop = Color(
        light: Color(red: 0.96, green: 0.95, blue: 1.0),
        dark: Color(red: 0.08, green: 0.08, blue: 0.11)
    )

    static let backgroundBottom = Color(
        light: Color.white,
        dark: Color(red: 0.04, green: 0.04, blue: 0.06)
    )

    static let card = Color(
        light: Color.white,
        dark: Color(red: 0.12, green: 0.12, blue: 0.16)
    )

    static let softCard = Color(
        light: Color(red: 0.95, green: 0.95, blue: 0.96),
        dark: Color(red: 0.15, green: 0.15, blue: 0.20)
    )

    static let border = Color(
        light: Color.purple.opacity(0.12),
        dark: Color.white.opacity(0.08)
    )

    static let primaryText = Color(
        light: Color(red: 0.10, green: 0.14, blue: 0.22),
        dark: Color.white
    )

    static let secondaryText = Color(
        light: Color(red: 0.55, green: 0.59, blue: 0.66),
        dark: Color(red: 0.72, green: 0.75, blue: 0.82)
    )

    static let rowIconBg = Color(
        light: Color(red: 0.91, green: 0.88, blue: 0.98),
        dark: Color(red: 0.22, green: 0.18, blue: 0.30)
    )

    static let searchField = Color(
        light: Color.white,
        dark: Color(red: 0.12, green: 0.12, blue: 0.16)
    )

    static let divider = Color(
        light: Color.black.opacity(0.08),
        dark: Color.white.opacity(0.06)
    )

    static let accentStart = Color(red: 0.75, green: 0.30, blue: 0.97)
    static let accentEnd = Color(red: 0.60, green: 0.24, blue: 0.90)
    static let accentMid = Color(red: 0.53, green: 0.28, blue: 0.95)
}

extension Color {
    init(light: Color, dark: Color) {
        #if os(iOS)
        self = Color(UIColor { trait in
            trait.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #elseif os(macOS)
        self = Color(NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return NSColor(isDark ? dark : light)
        })
        #else
        self = light
        #endif
    }
}

struct AppCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(AppPalette.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(AppPalette.border, lineWidth: 1)
                    )
                    .shadow(
                        color: Color.black.opacity(0.10),
                        radius: 10,
                        x: 0,
                        y: 6
                    )
            )
    }
}

extension View {
    func appCardStyle() -> some View {
        modifier(AppCardModifier())
    }
}
