//
//  MovieSearchView.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI

/// View for searching and selecting custom movies from TMDB
struct MovieSearchView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var tmdbService = TMDBService.shared
    @StateObject private var storage = CustomMovieStorage.shared
    
    @State private var searchText = ""
    @State private var searchResults: [TMDBMovie] = []
    @State private var isSearching = false
    @FocusState private var isSearchFocused: Bool
    
    var clearPickerCallback: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
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
                    .accessibilityLabel(L10n.Common.close)
                }
                .padding()
                .padding(.top, 10)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.6))
                    TextField(L10n.Search.placeholder, text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(.white)
                        .textInputAutocapitalization(.never)
                        .tint(.cyan)
                        .focused($isSearchFocused)
                        .accessibilityLabel(L10n.Search.placeholder)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            searchResults = []
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .accessibilityLabel(L10n.Common.close)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.15))
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom)
                
                if let error = tmdbService.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red.opacity(0.9))
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
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
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .task(id: searchText) {
            await performSearch()
        }
        .onAppear {
            isSearchFocused = true
            if !Config.hasValidAPIKey {
                tmdbService.errorMessage = TMDBError.noAPIKey.localizedDescription
            }
        }
    }
    
    private func performSearch() async {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            searchResults = []
            isSearching = false
            return
        }
        
        isSearching = true
        tmdbService.errorMessage = nil
        AppLogger.debug("Searching for: '\(query)'", category: .network)
        
        do {
            try await Task.sleep(nanoseconds: 500_000_000)
            try Task.checkCancellation()
            let results = try await tmdbService.searchMovies(query: query)
            try Task.checkCancellation()
            searchResults = results
            AppLogger.info("Search completed: \(results.count) results for '\(query)'", category: .network)
        } catch is CancellationError {
            // Newer keystroke superseded this search
        } catch {
            AppLogger.error("Search failed for '\(query)'", error: error, category: .network)
            tmdbService.errorMessage = error.localizedDescription
        }
        
        isSearching = false
    }
    
    private func selectMovie(_ movie: TMDBMovie) {
        HapticManager.shared.mediumImpact()
        AppLogger.info("User selected movie: '\(movie.title)' (\(movie.year))", category: .ui)
        
        Task {
            do {
                let cast = try await tmdbService.getMovieCredits(movieId: movie.id)
                
                var posterData: Data?
                if let posterURL = movie.posterURL {
                    posterData = try? await URLSession.shared.data(from: posterURL).0
                }
                
                storage.saveMovie(movie, cast: cast, posterData: posterData)
                clearPickerCallback?()
                HapticManager.shared.success()
                
                try await Task.sleep(nanoseconds: 500_000_000)
                dismiss()
            } catch {
                AppLogger.error("Failed to select movie '\(movie.title)'", error: error, category: .network)
                tmdbService.errorMessage = error.localizedDescription
                HapticManager.shared.error()
            }
        }
    }
}

struct MovieSearchResultRow: View {
    let movie: TMDBMovie
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Group {
                    if let posterURL = movie.posterURL {
                        AsyncImage(url: posterURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .empty:
                                ProgressView()
                            default:
                                Image(systemName: "film.fill")
                                    .foregroundColor(.white.opacity(0.3))
                            }
                        }
                    } else {
                        Image(systemName: "film.fill")
                            .foregroundColor(.white.opacity(0.3))
                    }
                }
                .frame(width: 60, height: 90)
                .background(Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
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
        .accessibilityLabel("\(movie.title), \(movie.year > 0 ? String(movie.year) : "")")
    }
}
