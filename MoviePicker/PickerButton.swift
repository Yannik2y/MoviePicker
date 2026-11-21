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
    var isEnabled: Bool = true
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "film.fill")
                    .font(.title2)
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
        .buttonStyle(PrimaryPickerButtonStyle(isEnabled: isEnabled))
        .disabled(!isEnabled)
        .hoverEffect(.highlight)
        .accessibilityLabel(Strings.Accessibility.pickerButtonLabel)
        .accessibilityHint(Strings.Accessibility.pickerButtonHint)
    }
}
