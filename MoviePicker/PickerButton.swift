//
//  PickerButton.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 09.04.23.
//

import SwiftUI

struct PickerButton: View {
    let action: () -> Void
    var title: String = Strings.bondPickerTitle
    var metrics: AdaptiveLayoutMetrics? = nil
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "film.fill")
                    .font(.title2)
                    .scaleEffect(isPressed ? 1.2 : 1.0)
                Text(title)
                    .font(.title2.bold())
            }
            .foregroundColor(AppColors.buttonForeground)
            .padding(.horizontal, metrics?.buttonHorizontalPadding ?? 24)
            .padding(.vertical, metrics?.isRegularWidth == true ? 16 : 14)
            .background(
                Capsule()
                    .fill(AppColors.buttonBackground)
            )
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
            )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .hoverEffect(.highlight)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed { isPressed = true }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .accessibilityLabel(Strings.Accessibility.pickerButtonLabel)
        .accessibilityHint(Strings.Accessibility.pickerButtonHint)
    }
}
