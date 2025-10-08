//
//  SharedMoviePickerView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import SwiftUI

/// Shared view component used by both ContentView, DadModeView, and CustomPickerView
/// Eliminates code duplication between the picker modes
struct SharedMoviePickerView<ViewModel: MoviePickerViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    
    // Track if we're currently showing an error (for auto-dismiss)
    @State private var errorDismissTask: DispatchWorkItem?
    
    // Custom button title (defaults to Bond Picker)
    var buttonTitle: String = Strings.bondPickerTitle
    
    // Dark mode support
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack {
                PickerButton(action: {
                    viewModel.selectMovie()
                }, title: buttonTitle)
                .padding(.top, Layout.adaptivePickerTop)
                
                ActorPicker(selectedActor: $viewModel.selectedActor, allActors: viewModel.allActors)
                    .padding(.top, Layout.adaptiveActorPickerTop)
                
                Spacer()
                
                // Show movie scrolling view or empty state
                if viewModel.filteredMovies.isEmpty && !viewModel.triggerScrolling {
                    // Empty state when no movies match the filter
                    VStack(spacing: Layout.emptyStateSpacing) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: 120, height: 120)
                            Image(systemName: "film.stack")
                                .font(.system(size: Layout.emptyStateIconSize))
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding()
                    .transition(.scale.combined(with: .opacity))
                } else {
                    MovieScrollingView(
                        movies: viewModel.allMovies,
                        randomMovie: $viewModel.randomMovie,
                        triggerScrolling: $viewModel.triggerScrolling,
                        targetMovie: $viewModel.targetMovie
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                
                Spacer()
            }
            
            // Error message overlay
            if let errorMessage = viewModel.errorMessage {
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
                    }
                    .padding()
                    .background(AppColors.errorBackground)
                    .cornerRadius(Layout.errorMessageCornerRadius)
                    .padding(.horizontal, Layout.errorMessageHorizontalPadding)
                    .padding(.bottom, Layout.errorMessageBottomPadding)
                    .shadow(radius: 5)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onTapGesture {
                        // Allow dismissing by tapping anywhere on the error
                        errorDismissTask?.cancel()
                        viewModel.errorMessage = nil
                    }
                }
                .animation(.easeInOut, value: viewModel.errorMessage)
                .onAppear {
                    // Auto-dismiss error after configured delay
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
        .background(
            Image("appBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        )
        .onChange(of: viewModel.targetMovie) { oldValue, newTargetMovie in
            // Only set randomMovie immediately for regular picker mode
            // In Dad Mode, let the scrolling view handle the target movie
            if let movie = newTargetMovie, movie.title != MovieConstants.fifaWM2014Title {
                viewModel.randomMovie = newTargetMovie
            }
            // Ensure triggerScrolling is set to true to start animation
            viewModel.triggerScrolling = true
        }
        .onChange(of: viewModel.selectedActor) { oldValue, newValue in
            viewModel.updateFilteredMovies()
        }
    }
}

