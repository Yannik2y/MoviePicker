//
//  AppConstants.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI

/// Layout constants for consistent UI spacing and sizing
enum Layout {
    static let pickerButtonTopPadding: CGFloat = 120
    static let actorPickerTopPadding: CGFloat = 130
    static let menuButtonTopSpacing: CGFloat = 20
    static let menuOffsetHidden: CGFloat = -300
    
    static let posterFrameWidth: CGFloat = 375
    static let posterFrameHeight: CGFloat = 330
    static let posterImageHeight: CGFloat = 200
    static let posterCornerRadius: CGFloat = 10
    static let posterVerticalOffset: CGFloat = -5
    
    static let buttonCornerRadius: CGFloat = 40
    static let buttonBorderWidth: CGFloat = 5
    static let buttonPadding: CGFloat = 10
    
    static let errorMessageBottomPadding: CGFloat = 50
    static let errorMessageHorizontalPadding: CGFloat = 20
    static let errorMessageCornerRadius: CGFloat = 10
    
    static let emptyStateIconSize: CGFloat = 80
    static let emptyStateSpacing: CGFloat = 20
}

/// Animation timing constants
enum AnimationTiming {
    static let scrollAnimationCount: Int = 6
    static let scrollAnimationDelay: TimeInterval = 0.3
    static let errorDismissDelay: TimeInterval = 4.0
}

/// Color constants for consistent theming
enum AppColors {
    static let posterBackground = Color.white.opacity(0.5)
    static let menuBackground = Color.black.opacity(0.8)
    static let menuButtonBackground = Color.black.opacity(0.5)
    static let errorBackground = Color.red.opacity(0.9)
    static let buttonBackground = Color.white
    static let buttonForeground = Color.black
}

/// String constants (now using localized strings)
enum Strings {
    static var allActorsFilter: String { L10n.Filter.allActors }
    static var bondPickerTitle: String { L10n.Button.bondPicker }
    static var moviePickerTitle: String { L10n.Button.moviePicker }
    static var dadModeTitle: String { L10n.Menu.dadMode }
    static let pickingMovieMessage = "Picking movie..." // Not user-facing
    
    
    enum Accessibility {
        static var pickerButtonLabel: String { L10n.Accessibility.pickerButtonLabel }
        static var pickerButtonHint: String { L10n.Accessibility.pickerButtonHint }
    }
    
    enum ErrorMessages {
        static var noMoviesForActor: String { L10n.Error.noMoviesForActor }
        static var unableToSelect: String { L10n.Error.unableToSelect }
        static func noMoviesFound(for actor: String) -> String {
            L10n.Error.noMoviesFound(for: actor)
        }
    }
    
    enum EmptyState {
        static var noMoviesAvailable: String { L10n.Empty.noMovies }
        static var tryDifferentActor: String { L10n.Empty.tryDifferent }
    }
}

