//
//  Logger.swift
//  MoviePicker
//
//  Created for improved error logging and debugging
//

import Foundation
import os.log

/// Centralized logging system for the app
/// Uses iOS unified logging system for better performance and debugging
enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.moviepicker"
    
    // MARK: - Loggers by Category
    
    static let network = Logger(subsystem: subsystem, category: "Network")
    static let viewModel = Logger(subsystem: subsystem, category: "ViewModel")
    static let storage = Logger(subsystem: subsystem, category: "Storage")
    static let ui = Logger(subsystem: subsystem, category: "UI")
    static let general = Logger(subsystem: subsystem, category: "General")
    
    // MARK: - Convenience Methods
    
    /// Log a debug message
    static func debug(_ message: String, category: LogCategory = .general) {
        category.logger.debug("\(message)")
    }
    
    /// Log an info message
    static func info(_ message: String, category: LogCategory = .general) {
        category.logger.info("\(message)")
    }
    
    /// Log a warning
    static func warning(_ message: String, category: LogCategory = .general) {
        category.logger.warning("\(message)")
    }
    
    /// Log an error
    static func error(_ message: String, error: Error? = nil, category: LogCategory = .general) {
        if let error = error {
            category.logger.error("\(message): \(error.localizedDescription)")
        } else {
            category.logger.error("\(message)")
        }
    }
    
    /// Log a critical error
    static func critical(_ message: String, error: Error? = nil, category: LogCategory = .general) {
        if let error = error {
            category.logger.critical("\(message): \(error.localizedDescription)")
        } else {
            category.logger.critical("\(message)")
        }
    }
}

// MARK: - Log Categories

enum LogCategory {
    case network
    case viewModel
    case storage
    case ui
    case general
    
    var logger: Logger {
        switch self {
        case .network: return AppLogger.network
        case .viewModel: return AppLogger.viewModel
        case .storage: return AppLogger.storage
        case .ui: return AppLogger.ui
        case .general: return AppLogger.general
        }
    }
}

// MARK: - Legacy Print Wrapper (for gradual migration)

/// Wrapper for print statements that adds logging
/// Use this instead of print() for consistent logging
func logPrint(_ items: Any..., category: LogCategory = .general) {
    let message = items.map { "\($0)" }.joined(separator: " ")
    AppLogger.info(message, category: category)
}


