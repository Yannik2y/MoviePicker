//
//  MovieSearchView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI

/// View for searching and selecting custom movies from TMDB
/// Styled to match the app's Bond-themed dark aesthetic
struct MovieSearchView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var tmdbService = TMDBService.shared
    @StateObject private var storage = CustomMovieStorage.shared
    
    @State private var searchText = ""
    @State private var searchResults: [TMDBMovie] = []
    @State private var isSearching = false
    @State private var selectedMovie: TMDBMovie?
    
    // Callback to clear picker when movie is selected
    var clearPickerCallback: (() -> Void)?
    
    var body: some View {
        ZStack {
            // Dark background matching app theme
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with close button
                HStack {
                    Text(L10n.Search.title)
                        .font(.title2)
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
                .padding()
                .padding(.top, 10)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.6))
                    TextField(L10n.Search.placeholder, text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .tint(.cyan)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            searchResults = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom)
                
                // Current Selection
                if let currentMovie = storage.selectedMovie {
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(L10n.Search.currentSelection)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.7))
                            Spacer()
                        }
                        
                        HStack(spacing: 12) {
                            if let posterImage = storage.posterImage {
                                Image(uiImage: posterImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 75)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                            } else {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 50, height: 75)
                                    .overlay(
                                        Image(systemName: "film.fill")
                                            .foregroundColor(.white.opacity(0.5))
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(currentMovie.title)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(currentMovie.actor)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
                // Results or Empty State
                if isSearching {
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1.5)
                        Text(L10n.Search.searching)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.top)
                        Spacer()
                    }
                } else if searchResults.isEmpty && !searchText.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "film.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                        Text(L10n.Search.noResults)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(L10n.Search.tryDifferent)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                        Spacer()
                    }
                } else if searchResults.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "popcorn.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.cyan)
                        Text(L10n.Search.searchAny)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(L10n.Search.prankHint)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                    .padding()
                } else {
                    // Search Results
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(searchResults) { movie in
                                MovieSearchResultRow(movie: movie) {
                                    selectMovie(movie)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .onChange(of: searchText) { oldValue, newValue in
            Task {
                await performSearch()
            }
        }
    }
    
    private func performSearch() async {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        AppLogger.debug("Searching for: '\(searchText)'", category: .network)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000) // Debounce
            let results = try await tmdbService.searchMovies(query: searchText)
            searchResults = results
            AppLogger.info("Search completed: \(results.count) results for '\(searchText)'", category: .network)
        } catch {
            AppLogger.error("Search failed for '\(searchText)'", error: error, category: .network)
            tmdbService.errorMessage = error.localizedDescription
        }
        
        isSearching = false
    }
    
    private func selectMovie(_ movie: TMDBMovie) {
        HapticManager.shared.mediumImpact()
        AppLogger.info("User selected movie: '\(movie.title)' (\(movie.year))", category: .ui)
        
        Task {
            do {
                // Get cast information
                AppLogger.debug("Fetching cast for movie ID: \(movie.id)", category: .network)
                let cast = try await tmdbService.getMovieCredits(movieId: movie.id)
                
                // Download poster if available
                var posterData: Data?
                if let posterURL = movie.posterURL {
                    AppLogger.debug("Downloading poster from: \(posterURL.absoluteString)", category: .network)
                    posterData = try? await URLSession.shared.data(from: posterURL).0
                    if posterData != nil {
                        AppLogger.info("Poster downloaded successfully", category: .network)
                    } else {
                        AppLogger.warning("Failed to download poster data", category: .network)
                    }
                }
                
                // Save the selection and clear the picker display
                storage.saveMovie(movie, cast: cast, posterData: posterData)
                AppLogger.info("Movie selection saved: '\(movie.title)'", category: .storage)
                
                // Clear the picker display via callback
                clearPickerCallback?()
                
                HapticManager.shared.success()
                
                // Dismiss after short delay
                try await Task.sleep(nanoseconds: 500_000_000)
                dismiss()
                
            } catch {
                AppLogger.error("Failed to select movie '\(movie.title)'", error: error, category: .network)
                HapticManager.shared.error()
            }
        }
    }
}

/// Individual search result row - styled to match app theme
struct MovieSearchResultRow: View {
    let movie: TMDBMovie
    let action: () -> Void
    
    @State private var posterImage: UIImage?
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Poster
                Group {
                    if let image = posterImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                Image(systemName: "film.fill")
                                    .foregroundColor(.white.opacity(0.3))
                            )
                    }
                }
                .frame(width: 60, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                // Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    if movie.year > 0 {
                        Text(verbatim: String(movie.year))
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    if let overview = movie.overview, !overview.isEmpty {
                        Text(overview)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .task {
            await loadPoster()
        }
    }
    
    private func loadPoster() async {
        guard let posterURL = movie.posterURL else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: posterURL)
            if let image = UIImage(data: data) {
                posterImage = image
            } else {
                AppLogger.warning("Failed to create image from poster data for '\(movie.title)'", category: .network)
            }
        } catch {
            AppLogger.error("Failed to load poster for '\(movie.title)'", error: error, category: .network)
        }
    }
}

