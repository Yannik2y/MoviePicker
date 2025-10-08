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
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: DeviceHelper.spacing(12)) {
                Image(systemName: "film.fill")
                    .font(.system(size: DeviceHelper.fontSize(28)))
                    .scaleEffect(isPressed ? 1.2 : 1.0)
                Text(title)
                    .font(.system(size: DeviceHelper.fontSize(34), weight: .bold))
            }
            .foregroundColor(AppColors.buttonForeground)
            .padding(.horizontal, DeviceHelper.spacing(32))
            .padding(.vertical, Layout.adaptiveButtonPadding)
            .background(
                Capsule()
                    .fill(AppColors.buttonBackground)
                    .shadow(color: Color.black.opacity(0.25), radius: isPressed ? 4 : 8, x: 0, y: isPressed ? 2 : 4)
            )
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.5), lineWidth: 2)
            )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
        .accessibilityLabel(Strings.Accessibility.pickerButtonLabel)
        .accessibilityHint(Strings.Accessibility.pickerButtonHint)
    }
}

