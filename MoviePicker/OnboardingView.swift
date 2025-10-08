//
//  OnboardingView.swift
//  MoviePicker
//
//  Onboarding flow for first-time users
//

import SwiftUI

/// Onboarding view shown to first-time users
struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "scope",
            iconColor: .white,
            title: L10n.Instructions.bondPickerTitle,
            description: L10n.Instructions.bondPickerSubtitle,
            details: L10n.Instructions.bondPickerStep2,
            accentColor: .white
        ),
        OnboardingPage(
            icon: "target",
            iconColor: .cyan,
            title: L10n.Instructions.moviePickerTitle,
            description: L10n.Instructions.moviePickerSubtitle,
            details: L10n.Instructions.moviePickerStep2 + "\n\n" + L10n.Instructions.moviePickerStep3 + "\n\n" + L10n.Instructions.moviePickerStep4 + "\n\n" + L10n.Instructions.moviePickerStep5,
            accentColor: .cyan
        ),
        OnboardingPage(
            icon: "trophy.fill",
            iconColor: .yellow,
            title: L10n.Instructions.dadModeTitle,
            description: L10n.Instructions.dadModeSubtitle,
            details: L10n.Instructions.dadModeStep3,
            accentColor: .yellow
        ),
        OnboardingPage(
            icon: "checkmark.circle.fill",
            iconColor: .green,
            title: "Ready to Go!",
            description: "You're all set",
            details: "Choose your mode from the menu and start picking movies. Have fun!",
            accentColor: .green
        )
    ]
    
    var body: some View {
        ZStack {
            // Dark background matching app theme
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()
                    Button(action: {
                        HapticManager.shared.lightImpact()
                        dismissOnboarding()
                    }) {
                        Text(L10n.Common.close)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                            .padding()
                    }
                }
                
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page, isLastPage: index == pages.count - 1)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                // Navigation buttons
                HStack(spacing: 20) {
                    if currentPage > 0 {
                        Button(action: {
                            HapticManager.shared.lightImpact()
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text(L10n.Common.back)
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(25)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        HapticManager.shared.mediumImpact()
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            dismissOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? L10n.Common.next : L10n.Common.getStarted)
                            if currentPage < pages.count - 1 {
                                Image(systemName: "chevron.right")
                            } else {
                                Image(systemName: "checkmark")
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            currentPage == pages.count - 1
                                ? Color.green
                                : Color.white
                        )
                        .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            AppLogger.info("Onboarding started", category: .ui)
        }
    }
    
    private func dismissOnboarding() {
        // Mark onboarding as completed
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        AppLogger.info("Onboarding completed", category: .ui)
        HapticManager.shared.success()
        isPresented = false
    }
}

/// Individual onboarding page content
struct OnboardingPageView: View {
    let page: OnboardingPage
    let isLastPage: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(page.iconColor.opacity(0.2))
                    .frame(width: 140, height: 140)
                Image(systemName: page.icon)
                    .font(.system(size: 70))
                    .foregroundColor(page.iconColor)
            }
            
            // Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Text(page.details)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding()
    }
}

/// Onboarding page data model
struct OnboardingPage {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let details: String
    let accentColor: Color
}

// MARK: - Preview

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isPresented: .constant(true))
    }
}

