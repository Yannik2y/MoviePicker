//
//  InstructionsView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

/// Instructions view explaining how to use all three picker modes
struct InstructionsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            // Dark background matching app theme
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Text(L10n.Instructions.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        Button(action: {
                            HapticManager.shared.lightImpact()
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Bond Picker Mode
                    InstructionCard(
                        icon: "scope",
                        iconColor: .white,
                        title: L10n.Instructions.bondPickerTitle,
                        subtitle: L10n.Instructions.bondPickerSubtitle,
                        steps: [
                            L10n.Instructions.bondPickerStep1,
                            L10n.Instructions.bondPickerStep2,
                            L10n.Instructions.bondPickerStep3
                        ]
                    )
                    
                    // Movie Picker Mode
                    InstructionCard(
                        icon: "target",
                        iconColor: .cyan,
                        title: L10n.Instructions.moviePickerTitle,
                        subtitle: L10n.Instructions.moviePickerSubtitle,
                        steps: [
                            L10n.Instructions.moviePickerStep1,
                            L10n.Instructions.moviePickerStep2,
                            L10n.Instructions.moviePickerStep3,
                            L10n.Instructions.moviePickerStep4,
                            L10n.Instructions.moviePickerStep5
                        ],
                        highlightColor: .cyan
                    )
                    
                    // Dad Mode
                    InstructionCard(
                        icon: "trophy.fill",
                        iconColor: .yellow,
                        title: L10n.Instructions.dadModeTitle,
                        subtitle: L10n.Instructions.dadModeSubtitle,
                        steps: [
                            L10n.Instructions.dadModeStep1,
                            L10n.Instructions.dadModeStep2,
                            L10n.Instructions.dadModeStep3
                        ],
                        highlightColor: .yellow
                    )
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical)
            }
        }
    }
}

/// Individual instruction card for each mode
struct InstructionCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let steps: [String]
    var highlightColor: Color = .white
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(iconColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
            }
            
            Divider()
                .background(Color.white.opacity(0.2))
            
            // Steps
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(highlightColor.opacity(0.2))
                                .frame(width: 28, height: 28)
                            Text("\(index + 1)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(highlightColor)
                        }
                        
                        Text(step)
                            .font(.body)
                            .foregroundColor(.white.opacity(0.9))
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(highlightColor.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}

