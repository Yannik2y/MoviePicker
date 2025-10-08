//
//  MenuView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 14.05.23.
//

import SwiftUI

struct MenuView: View {
    @Binding var isShowingMenu: Bool
    @Binding var currentView: CurrentView
    @State private var showingInstructions = false
    @State private var showingAbout = false
    @State private var showingHistory = false

    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Text(L10n.Menu.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    HapticManager.shared.lightImpact()
                    isShowingMenu = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding()
            .padding(.top, 50) // Extra top padding for safe area
            
            Divider()
                .background(Color.white.opacity(0.3))
            
            // Bond Picker Button
            Button(action: {
                HapticManager.shared.mediumImpact()
                currentView = .contentView
                isShowingMenu = false
            }) {
                HStack {
                    Image(systemName: "scope")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 30)
                    Text(Strings.bondPickerTitle)
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                    if currentView == .contentView {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(currentView == .contentView ? Color.white.opacity(0.1) : Color.clear)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            
            // Movie Picker Button
            Button(action: {
                HapticManager.shared.mediumImpact()
                currentView = .customPickerView
                isShowingMenu = false
            }) {
                HStack {
                    Image(systemName: "target")
                        .font(.title3)
                        .foregroundColor(.cyan)
                        .frame(width: 30)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.Menu.moviePicker)
                            .font(.body)
                            .foregroundColor(.white)
                        Text(L10n.Mode.moviePickerDescription)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    Spacer()
                    if currentView == .customPickerView {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(currentView == .customPickerView ? Color.white.opacity(0.1) : Color.clear)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            
            // Dad Mode Button
            Button(action: {
                HapticManager.shared.mediumImpact()
                currentView = .dadModeView
                isShowingMenu = false
            }) {
                HStack {
                    Image(systemName: "trophy.fill")
                        .font(.title3)
                        .foregroundColor(.yellow)
                        .frame(width: 30)
                    Text(Strings.dadModeTitle)
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                    if currentView == .dadModeView {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(currentView == .dadModeView ? Color.white.opacity(0.1) : Color.clear)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.horizontal)
                .padding(.top, 8)
            
            // Instructions Button
            Button(action: {
                HapticManager.shared.mediumImpact()
                showingInstructions = true
            }) {
                HStack {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.cyan)
                        .frame(width: 30)
                    Text(L10n.Menu.instructions)
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding()
                .background(Color.clear)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            
            // History Button
            Button(action: {
                HapticManager.shared.mediumImpact()
                showingHistory = true
            }) {
                HStack {
                    Image(systemName: "clock.fill")
                        .font(.title3)
                        .foregroundColor(.cyan)
                        .frame(width: 30)
                    Text("History & Favorites")
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding()
                .background(Color.clear)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            
            // About Button
            Button(action: {
                HapticManager.shared.mediumImpact()
                showingAbout = true
            }) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(.title3)
                        .foregroundColor(.cyan)
                        .frame(width: 30)
                    Text("About")
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding()
                .background(Color.clear)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            AppColors.menuBackground
                .overlay(
                    // Blur effect for more modern look
                    Color.black.opacity(0.3)
                )
        )
        .edgesIgnoringSafeArea(.all)
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isShowingMenu)
        .offset(y: isShowingMenu ? 0 : Layout.menuOffsetHidden)
        .sheet(isPresented: $showingInstructions) {
            InstructionsView()
        }
        .sheet(isPresented: $showingHistory) {
            HistoryView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
}
