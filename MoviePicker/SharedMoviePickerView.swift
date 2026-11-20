//
//  SharedMoviePickerView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

/// Shared view component used by ContentView, DadModeView, and CustomPickerView
struct SharedMoviePickerView<ViewModel: MoviePickerViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @State private var errorDismissTask: DispatchWorkItem?
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
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                    
                    Spacer(minLength: 8)
                }
                .frame(maxWidth: metrics.contentMaxWidth)
                .frame(maxWidth: .infinity)
                
                if let errorMessage = viewModel.errorMessage {
                    errorBanner(errorMessage)
                }
            }
        }
        .background(
            Image("appBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        )
        .onChange(of: viewModel.targetMovie) { _, newTargetMovie in
            if newTargetMovie != nil {
                viewModel.triggerScrolling = true
            }
        }
        .onChange(of: viewModel.selectedActor) { _, _ in
            viewModel.updateFilteredMovies()
        }
    }
    
    @ViewBuilder
    private func chrome(metrics: AdaptiveLayoutMetrics) -> some View {
        if metrics.isRegularWidth {
            HStack(spacing: 24) {
                PickerButton(action: { viewModel.selectMovie() }, title: buttonTitle, metrics: metrics)
                ActorPicker(selectedActor: $viewModel.selectedActor, allActors: viewModel.allActors)
            }
            .padding(.horizontal)
        } else {
            VStack(spacing: metrics.chromeSpacing) {
                PickerButton(action: { viewModel.selectMovie() }, title: buttonTitle, metrics: metrics)
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
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white.opacity(0.8))
                }
                .accessibilityLabel(L10n.Common.close)
            }
            .padding()
            .background(AppColors.errorBackground)
            .cornerRadius(Layout.errorMessageCornerRadius)
            .padding(.horizontal, Layout.errorMessageHorizontalPadding)
            .padding(.bottom, Layout.errorMessageBottomPadding)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .onTapGesture {
                errorDismissTask?.cancel()
                viewModel.errorMessage = nil
            }
        }
        .animation(.easeInOut, value: viewModel.errorMessage)
        .onAppear {
            errorDismissTask?.cancel()
            let task = DispatchWorkItem {
                viewModel.errorMessage = nil
            }
            errorDismissTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + AnimationTiming.errorDismissDelay, execute: task)
        }
        .onDisappear {
            errorDismissTask?.cancel()
        }
    }
}
