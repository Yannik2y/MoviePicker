//
//  MenuButton.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 14.05.23.
//

import SwiftUI

struct MenuButton: View {
    let action: () -> Void
    var isDadMode: Bool = false

    var body: some View {
        HStack {
            Button(action: {
                HapticManager.shared.lightImpact()
                action()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 50, height: 50)
                    Image(systemName: "line.3.horizontal")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding()

            Spacer()

            if isDadMode {
                HStack(spacing: 6) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.yellow)
                    Text(Strings.dadModeTitle)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.15))
                )
                .padding(.trailing, 20)
            }
        }
    }
}
