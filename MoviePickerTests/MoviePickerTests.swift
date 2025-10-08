//
//  MoviePickerTests.swift
//  MoviePickerTests
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import XCTest
@testable import MoviePicker

/// Comprehensive test suite for MoviePicker app
final class MoviePickerTests: XCTestCase {

    // MARK: - Movie Tests
    
    func testMovieEquality() {
        let movie1 = Movie(title: "Goldfinger", year: 1964, actor: "Sean Connery", genre: "Action", imdbRating: 7.7, poster: "goldfinger")
        let movie2 = Movie(title: "Goldfinger", year: 1964, actor: "Sean Connery", genre: "Action", imdbRating: 7.7, poster: "goldfinger")
        let movie3 = Movie(title: "Skyfall", year: 2012, actor: "Daniel Craig", genre: "Action", imdbRating: 7.7, poster: "skyfall")
        
        XCTAssertEqual(movie1, movie2, "Movies with same title and year should be equal")
        XCTAssertNotEqual(movie1, movie3, "Movies with different titles should not be equal")
    }
    
    func testMovieBondActorProperty() {
        let bondMovie = Movie(title: "Casino Royale", year: 2006, actor: "Daniel Craig", genre: "Action", imdbRating: 8.0, poster: "casino_royale")
        let specialMovie = Movie(title: "FIFA WM 2014", year: 2014, actor: "Die Deutsche 11", genre: "Sports", imdbRating: 10, poster: "WM_2014")
        
        XCTAssertEqual(bondMovie.bondActor, .danielCraig, "Should return correct BondActor enum")
        XCTAssertNil(specialMovie.bondActor, "Non-Bond movie should return nil for bondActor")
    }
    
    func testMovieStarsMethod() {
        let movie = Movie(title: "GoldenEye", year: 1995, actor: "Pierce Brosnan", genre: "Action", imdbRating: 7.2, poster: "goldeneye")
        
        XCTAssertTrue(movie.stars(.pierceBrosnan), "Should return true for correct actor")
        XCTAssertFalse(movie.stars(.seanConnery), "Should return false for incorrect actor")
    }
    
    // MARK: - BondActor Tests
    
    func testBondActorCount() {
        XCTAssertEqual(BondActor.allCases.count, 6, "Should have 6 Bond actors")
    }
    
    func testBondActorRawValues() {
        XCTAssertEqual(BondActor.seanConnery.rawValue, "Sean Connery")
        XCTAssertEqual(BondActor.danielCraig.rawValue, "Daniel Craig")
        XCTAssertEqual(BondActor.rogerMoore.rawValue, "Roger Moore")
    }
    
    func testBondActorAllWithFilter() {
        let allWithFilter = BondActor.allWithFilter
        
        XCTAssertEqual(allWithFilter.count, 7, "Should have 7 items (6 actors + 'All Actors')")
        XCTAssertEqual(allWithFilter.first, "All Actors", "First item should be 'All Actors'")
        XCTAssertTrue(allWithFilter.contains("Sean Connery"), "Should contain Sean Connery")
    }
    
    // MARK: - MovieService Tests
    
    func testMovieServiceBondMovies() {
        let service = MovieService.shared
        let bondMovies = service.bondMovies
        
        XCTAssertGreaterThan(bondMovies.count, 0, "Should have Bond movies")
        XCTAssertFalse(bondMovies.contains { $0.title == "WM-Halbfinale 2014" }, "Bond movies should not include WM-Halbfinale 2014")
        XCTAssertEqual(bondMovies.count, 25, "Should have 25 Bond movies")
    }
    
    func testMovieServiceBondActors() {
        let service = MovieService.shared
        let actors = service.bondActors
        
        XCTAssertEqual(actors.count, 6, "Should have 6 unique Bond actors")
        XCTAssertTrue(actors.contains("Sean Connery"), "Should include Sean Connery")
        XCTAssertTrue(actors.contains("Daniel Craig"), "Should include Daniel Craig")
    }
    
    func testMovieServiceFilterByString() {
        let service = MovieService.shared
        
        let seanConneryMovies = service.filterMovies(by: "Sean Connery")
        XCTAssertGreaterThan(seanConneryMovies.count, 0, "Should have Sean Connery movies")
        XCTAssertTrue(seanConneryMovies.allSatisfy { $0.actor == "Sean Connery" }, "All movies should star Sean Connery")
        
        let allMovies = service.filterMovies(by: "All Actors")
        XCTAssertEqual(allMovies.count, service.bondMovies.count, "'All Actors' should return all Bond movies")
    }
    
    func testMovieServiceFilterByEnum() {
        let service = MovieService.shared
        
        let danielCraigMovies = service.filterMovies(by: .danielCraig)
        XCTAssertEqual(danielCraigMovies.count, 5, "Daniel Craig should have 5 movies")
        XCTAssertTrue(danielCraigMovies.allSatisfy { $0.stars(.danielCraig) }, "All movies should star Daniel Craig")
        
        let rogerMooreMovies = service.filterMovies(by: .rogerMoore)
        XCTAssertEqual(rogerMooreMovies.count, 7, "Roger Moore should have 7 movies")
    }
    
    func testMovieServiceHasMovies() {
        let service = MovieService.shared
        
        XCTAssertTrue(service.hasMovies(for: "Sean Connery"), "Should have movies for Sean Connery")
        XCTAssertTrue(service.hasMovies(for: .danielCraig), "Should have movies for Daniel Craig")
        XCTAssertFalse(service.hasMovies(for: "NonExistent Actor"), "Should not have movies for non-existent actor")
    }
    
    func testMovieServiceFifaMovie() {
        let service = MovieService.shared
        let fifaMovie = service.fifaMovie
        
        XCTAssertEqual(fifaMovie.title, "WM-Halbfinale 2014", "Should return WM-Halbfinale 2014 movie")
        XCTAssertEqual(fifaMovie.year, 2014)
        XCTAssertEqual(fifaMovie.imdbRating, 10)
    }
    
    // MARK: - PickerViewModel Tests
    
    @MainActor
    func testPickerViewModelInitialization() {
        let viewModel = PickerViewModel()
        
        XCTAssertEqual(viewModel.selectedActor, "All Actors", "Should initialize with 'All Actors'")
        XCTAssertNil(viewModel.targetMovie, "Should initialize with no target movie")
        XCTAssertNil(viewModel.randomMovie, "Should initialize with no random movie")
        XCTAssertFalse(viewModel.triggerScrolling, "Should not be scrolling initially")
        XCTAssertGreaterThan(viewModel.filteredMovies.count, 0, "Should have filtered movies")
    }
    
    @MainActor
    func testPickerViewModelUpdateFilteredMovies() {
        let viewModel = PickerViewModel()
        
        viewModel.selectedActor = "Sean Connery"
        viewModel.updateFilteredMovies()
        
        XCTAssertGreaterThan(viewModel.filteredMovies.count, 0, "Should have Sean Connery movies")
        XCTAssertTrue(viewModel.filteredMovies.allSatisfy { $0.actor == "Sean Connery" }, "All filtered movies should star Sean Connery")
        
        viewModel.selectedActor = "All Actors"
        viewModel.updateFilteredMovies()
        XCTAssertEqual(viewModel.filteredMovies.count, 25, "Should have all Bond movies")
    }
    
    @MainActor
    func testPickerViewModelSelectMovie() {
        let viewModel = PickerViewModel()
        
        viewModel.selectMovie()
        
        XCTAssertNotNil(viewModel.targetMovie, "Should have selected a target movie")
        XCTAssertTrue(viewModel.triggerScrolling, "Should trigger scrolling")
        XCTAssertTrue(viewModel.filteredMovies.contains(viewModel.targetMovie!), "Target movie should be from filtered movies")
    }
    
    @MainActor
    func testPickerViewModelErrorHandling() {
        let viewModel = PickerViewModel()
        
        // Test with non-existent actor
        viewModel.selectedActor = "NonExistent Actor"
        viewModel.updateFilteredMovies()
        
        XCTAssertNotNil(viewModel.errorMessage, "Should have error message for non-existent actor")
        XCTAssertEqual(viewModel.filteredMovies.count, 0, "Should have no filtered movies")
    }
    
    @MainActor
    func testPickerViewModelPreventRapidSelections() {
        let viewModel = PickerViewModel()
        
        viewModel.selectMovie()
        let firstTarget = viewModel.targetMovie
        
        // Try to pick again while scrolling
        viewModel.selectMovie()
        
        XCTAssertEqual(viewModel.targetMovie, firstTarget, "Should not change target while scrolling")
    }
    
    // MARK: - DadModeViewModel Tests
    
    @MainActor
    func testDadModeViewModelInitialization() {
        let viewModel = DadModeViewModel()
        
        XCTAssertEqual(viewModel.selectedActor, "All Actors")
        XCTAssertNil(viewModel.targetMovie)
        XCTAssertEqual(viewModel.wm2014Movie.title, "WM-Halbfinale 2014")
    }
    
    @MainActor
    func testDadModeViewModelAlwaysSelectsWM2014() {
        let viewModel = DadModeViewModel()
        
        // Select multiple times
        for _ in 0..<5 {
            viewModel.targetMovie = nil
            viewModel.triggerScrolling = false
            viewModel.selectMovie()
            
            XCTAssertEqual(viewModel.targetMovie?.title, "WM-Halbfinale 2014", "Should always select WM-Halbfinale 2014")
        }
    }
    
    @MainActor
    func testDadModeViewModelFiltering() {
        let viewModel = DadModeViewModel()
        
        // Even with filtering, Dad Mode should still select WM-Halbfinale 2014
        viewModel.selectedActor = "Daniel Craig"
        viewModel.updateFilteredMovies()
        viewModel.selectMovie()
        
        XCTAssertEqual(viewModel.targetMovie?.title, "WM-Halbfinale 2014", "Should select WM-Halbfinale 2014 regardless of filter")
    }
    
    // MARK: - CustomPickerViewModel Tests
    
    @MainActor
    func testCustomPickerViewModelInitialization() {
        let viewModel = CustomPickerViewModel()
        
        XCTAssertEqual(viewModel.selectedActor, "All Actors")
        XCTAssertNil(viewModel.targetMovie)
        XCTAssertFalse(viewModel.showingSettings)
        XCTAssertNotNil(viewModel.customMovie, "Should have a default custom movie")
    }
    
    @MainActor
    func testCustomPickerViewModelSelectsCustomMovie() {
        let viewModel = CustomPickerViewModel()
        
        // Verify a custom movie exists
        guard viewModel.customMovie != nil else {
            XCTFail("No custom movie available")
            return
        }
        
        viewModel.selectMovie()
        
        XCTAssertNotNil(viewModel.targetMovie, "Should have selected target movie")
        XCTAssertTrue(viewModel.triggerScrolling, "Should trigger scrolling")
        XCTAssertEqual(viewModel.targetMovie?.title, viewModel.customMovie?.title, "Should select the custom movie")
    }
    
    @MainActor
    func testCustomPickerViewModelErrorWhenNoCustomMovie() {
        let viewModel = CustomPickerViewModel()
        let storage = CustomMovieStorage.shared
        
        // Clear custom movie
        storage.clearSelection()
        
        viewModel.selectMovie()
        
        XCTAssertNotNil(viewModel.errorMessage, "Should show error when no custom movie is set")
        XCTAssertNil(viewModel.targetMovie, "Should not select a target movie")
        
        // Restore default movie for other tests
        storage.loadSelectedMovie()
    }
    
    @MainActor
    func testCustomPickerViewModelOpenSettings() {
        let viewModel = CustomPickerViewModel()
        
        XCTAssertFalse(viewModel.showingSettings, "Settings should be closed initially")
        
        viewModel.openSettings()
        
        XCTAssertTrue(viewModel.showingSettings, "Settings should open")
    }
    
    @MainActor
    func testCustomPickerViewModelFiltering() {
        let viewModel = CustomPickerViewModel()
        
        // Custom picker should still filter Bond movies for display
        viewModel.selectedActor = "Timothy Dalton"
        viewModel.updateFilteredMovies()
        
        XCTAssertEqual(viewModel.filteredMovies.count, 2, "Timothy Dalton should have 2 movies")
        XCTAssertTrue(viewModel.filteredMovies.allSatisfy { $0.actor == "Timothy Dalton" })
        
        // But selection should still be custom movie
        viewModel.selectMovie()
        XCTAssertNotEqual(viewModel.targetMovie?.actor, "Timothy Dalton", "Should select custom movie, not filtered Bond movie")
    }
    
    // MARK: - CustomMovieStorage Tests
    
    @MainActor
    func testCustomMovieStorageInitialization() {
        let storage = CustomMovieStorage.shared
        
        XCTAssertNotNil(storage.selectedMovie, "Should have a selected movie (default if none saved)")
    }
    
    @MainActor
    func testCustomMovieStorageClearSelection() {
        let storage = CustomMovieStorage.shared
        
        storage.clearSelection()
        
        XCTAssertNil(storage.selectedMovie, "Should clear selected movie")
        XCTAssertNil(storage.posterImage, "Should clear poster image")
    }
    
    @MainActor
    func testCustomMovieStorageLoadAfterClear() {
        let storage = CustomMovieStorage.shared
        
        // Clear and reload to get default
        storage.clearSelection()
        storage.loadSelectedMovie()
        
        XCTAssertNotNil(storage.selectedMovie, "Should load default movie after clear")
        XCTAssertEqual(storage.selectedMovie?.title, "The Notebook", "Default movie should be The Notebook")
    }
    
    @MainActor
    func testCustomMovieDataToMovie() {
        let movieData = CustomMovieData(
            title: "Test Movie",
            year: 2020,
            actor: "Test Actor",
            tmdbId: 12345,
            posterImageData: nil
        )
        
        let movie = movieData.toMovie()
        
        XCTAssertEqual(movie.title, "Test Movie")
        XCTAssertEqual(movie.year, 2020)
        XCTAssertEqual(movie.actor, "Test Actor")
        XCTAssertEqual(movie.genre, "Custom")
        XCTAssertEqual(movie.imdbRating, 0.0)
    }
    
    // MARK: - Logger Tests
    
    func testLoggerCategories() {
        // Test that logger categories exist and can be accessed
        XCTAssertNotNil(AppLogger.network)
        XCTAssertNotNil(AppLogger.viewModel)
        XCTAssertNotNil(AppLogger.storage)
        XCTAssertNotNil(AppLogger.ui)
        XCTAssertNotNil(AppLogger.general)
    }
    
    func testLoggerConvenienceMethods() {
        // Test that logging methods don't crash
        AppLogger.debug("Test debug message")
        AppLogger.info("Test info message")
        AppLogger.warning("Test warning message")
        AppLogger.error("Test error message")
        AppLogger.critical("Test critical message")
        
        // Test with category
        AppLogger.debug("Test with category", category: .network)
        AppLogger.info("Test with category", category: .viewModel)
        
        // Test with error object
        let testError = NSError(domain: "test", code: 42, userInfo: nil)
        AppLogger.error("Test error with object", error: testError, category: .network)
    }
    
    func testLogPrintWrapper() {
        // Test that logPrint doesn't crash
        logPrint("Test message")
        logPrint("Multiple", "arguments", "test")
        logPrint("With category test", category: .ui)
    }
    
    // MARK: - Protocol Conformance Tests
    
    @MainActor
    func testPickerViewModelConformsToProtocol() {
        let viewModel: any MoviePickerViewModelProtocol = PickerViewModel()
        
        XCTAssertNotNil(viewModel.selectedActor)
        XCTAssertNotNil(viewModel.allMovies)
        XCTAssertNotNil(viewModel.allActors)
    }
    
    @MainActor
    func testDadModeViewModelConformsToProtocol() {
        let viewModel: any MoviePickerViewModelProtocol = DadModeViewModel()
        
        XCTAssertNotNil(viewModel.selectedActor)
        XCTAssertNotNil(viewModel.allMovies)
        XCTAssertNotNil(viewModel.allActors)
    }
    
    @MainActor
    func testCustomPickerViewModelConformsToProtocol() {
        let viewModel: any MoviePickerViewModelProtocol = CustomPickerViewModel()
        
        XCTAssertNotNil(viewModel.selectedActor)
        XCTAssertNotNil(viewModel.allMovies)
        XCTAssertNotNil(viewModel.allActors)
    }
    
    // MARK: - Integration Tests
    
    @MainActor
    func testFullPickerFlow() {
        let viewModel = PickerViewModel()
        
        // 1. Initial state
        XCTAssertEqual(viewModel.filteredMovies.count, 25)
        
        // 2. Change filter
        viewModel.selectedActor = "Pierce Brosnan"
        viewModel.updateFilteredMovies()
        XCTAssertEqual(viewModel.filteredMovies.count, 4, "Pierce Brosnan should have 4 movies")
        
        // 3. Pick movie
        viewModel.selectMovie()
        XCTAssertTrue(viewModel.targetMovie?.stars(.pierceBrosnan) ?? false, "Selected movie should star Pierce Brosnan")
        
        // 4. Reset
        viewModel.triggerScrolling = false
        viewModel.selectedActor = "All Actors"
        viewModel.updateFilteredMovies()
        XCTAssertEqual(viewModel.filteredMovies.count, 25, "Should return to all movies")
    }
    
    // MARK: - Performance Tests
    
    func testMovieServicePerformance() {
        let service = MovieService.shared
        
        measure {
            for _ in 0..<1000 {
                _ = service.filterMovies(by: .danielCraig)
            }
        }
    }
    
    @MainActor
    func testPickerViewModelPerformance() {
        let viewModel = PickerViewModel()
        
        measure {
            for _ in 0..<100 {
                viewModel.selectedActor = BondActor.allCases.randomElement()!.rawValue
                viewModel.updateFilteredMovies()
            }
        }
    }
}
