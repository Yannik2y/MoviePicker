//
//  Theme.swift
//  MoviePicker
//
//  Design tokens: materials, semantic colors, radii (Apple chassis + Bond stage).
//

import SwiftUI

enum Theme {
    // MARK: - Surfaces
    
    static let appScrim = Color.black.opacity(0.35)
    static let stageBackground = Color.black
    
    static var chromeMaterial: Material { .ultraThinMaterial }
    static var panelMaterial: Material { .regularMaterial }
    static var barMaterial: Material { .bar }
    
    // MARK: - Ink (on dark cinematic UI)
    
    static let inkPrimary = Color.white
    static let inkSecondary = Color.white.opacity(0.8)
    static let inkTertiary = Color.white.opacity(0.55)
    
    // MARK: - Accents / mode tints
    
    /// System accent — gold/champagne from AccentColor asset
    static var accent: Color { Color.accentColor }
    static let modeBond = Color.white
    static let modeCustom = Color.cyan
    static let modeDad = Color.yellow
    static let danger = Color.red.opacity(0.85)
    
    // MARK: - Radii
    
    static let posterCornerRadius: CGFloat = 16
    static let listCornerRadius: CGFloat = 12
    static let toastCornerRadius: CGFloat = 12
    
    // MARK: - Helpers
    
    static func modeColor(for mode: PickerMode) -> Color {
        switch mode {
        case .bondPicker: return modeBond
        case .customPicker: return modeCustom
        case .dadMode: return modeDad
        }
    }
}

/// Pressable primary CTA style (replaces DragGesture press hack)
struct PrimaryPickerButtonStyle: ButtonStyle {
    var isEnabled: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && isEnabled ? 0.95 : 1.0)
            .opacity(isEnabled ? 1.0 : 0.55)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
