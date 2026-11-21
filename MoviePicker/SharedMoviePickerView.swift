//
//  SharedMoviePickerView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI
import UIKit

/// Shared view component used by ContentView, DadModeView, and CustomPickerView
struct SharedMoviePickerView<ViewModel: MoviePickerViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var errorDismissTask: DispatchWorkItem?
    @State private var showMissingKeyHint = false
    var buttonTitle: String = Strings.bondPickerTitle
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        GeometryReader { geo in
            let metrics = AdaptiveLayoutMetrics(
                horizontalSizeClass: horizontalSizeClass,
                verticalSizeClass: verticalSizeClass,
                size: geo.size
            )
            
            ZStack {
                VStack(spacing: metrics.chromeSpacing) {
                    chrome(metrics: metrics)
                        .padding(.top, metrics.pickerTopPadding)
                    
                    Spacer(minLength: 8)
                    
                    if viewModel.filteredMovies.isEmpty && !viewModel.triggerScrolling {
                        emptyState
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        MovieScrollingView(
                            movies: viewModel.allMovies,
                            randomMovie: $viewModel.randomMovie,
                            triggerScrolling: $viewModel.triggerScrolling,
                            targetMovie: $viewModel.targetMovie,
                            metrics: metrics,
                            reduceMotion: reduceMotion
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    }
                    
                    Spacer(minLength: 8)
                }
                .frame(maxWidth: metrics.contentMaxWidth)
                .frame(maxWidth: .infinity)
                
                if let errorMessage = viewModel.errorMessage {
                    errorBanner(errorMessage)
                } else if showMissingKeyHint {
                    errorBanner(L10n.Error.missingAPIKey)
                }
            }
        }
        .background(
            Image("appBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .onChange(of: viewModel.selectedActor) { _, _ in
            viewModel.updateFilteredMovies()
        }
        .onAppear {
            Config.logConfigurationOnce()
            if !Config.hasValidAPIKey {
                showMissingKeyHint = true
            }
        }
    }
    
    @ViewBuilder
    private func chrome(metrics: AdaptiveLayoutMetrics) -> some View {
        let pickAction = {
            viewModel.selectMovie()
        }
        
        if metrics.isRegularWidth {
            HStack(spacing: 24) {
                PickerButton(
                    action: pickAction,
                    title: buttonTitle,
                    metrics: metrics,
                    isEnabled: !viewModel.triggerScrolling
                )
                ActorPicker(selectedActor: $viewModel.selectedActor, allActors: viewModel.allActors)
            }
            .padding(.horizontal)
        } else {
            VStack(spacing: metrics.chromeSpacing) {
                PickerButton(
                    action: pickAction,
                    title: buttonTitle,
                    metrics: metrics,
                    isEnabled: !viewModel.triggerScrolling
                )
                ActorPicker(selectedActor: $viewModel.selectedActor, allActors: viewModel.allActors)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: Layout.emptyStateSpacing) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                Image(systemName: "film.stack")
                    .font(.largeTitle)
                    .foregroundColor(.white.opacity(0.7))
            }
            Text(Strings.EmptyState.noMoviesAvailable)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(Strings.EmptyState.tryDifferentActor)
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding()
        .transition(.scale.combined(with: .opacity))
    }
    
    private func errorBanner(_ errorMessage: String) -> some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.white)
                Text(errorMessage)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button(action: {
                    errorDismissTask?.cancel()
                    viewModel.errorMessage = nil
                    showMissingKeyHint = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.8))
                }
                .accessibilityLabel(L10n.Common.close)
            }
            .padding()
            .background(Theme.panelMaterial, in: RoundedRectangle(cornerRadius: Theme.toastCornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.toastCornerRadius, style: .continuous)
                    .stroke(AppColors.errorBackground.opacity(0.8), lineWidth: 1)
            )
            .padding(.horizontal, Layout.errorMessageHorizontalPadding)
            .padding(.bottom, Layout.errorMessageBottomPadding)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .accessibilityAddTraits(.isStaticText)
            .onTapGesture {
                errorDismissTask?.cancel()
                viewModel.errorMessage = nil
                showMissingKeyHint = false
            }
        }
        .animation(.easeInOut, value: viewModel.errorMessage)
        .onAppear {
            UIAccessibility.post(notification: .announcement, argument: errorMessage)
            errorDismissTask?.cancel()
            let task = DispatchWorkItem {
                viewModel.errorMessage = nil
                showMissingKeyHint = false
            }
            errorDismissTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + AnimationTiming.errorDismissDelay, execute: task)
        }
        .onDisappear {
            errorDismissTask?.cancel()
        }
    }
}
