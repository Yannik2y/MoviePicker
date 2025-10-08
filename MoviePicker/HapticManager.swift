//
//  HapticManager.swift
//  MoviePicker
//
//  Created by Yannik Chlechowitz on 03.04.23.
//

import Foundation
import SwiftUI
import UIKit

/// Manages haptic feedback throughout the app
/// Follows Apple's Human Interface Guidelines for haptic feedback
@MainActor
final class HapticManager {
    static let shared = HapticManager()
    
    private let impactLight = UIImpactFeedbackGenerator(style: .light)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private let selection = UISelectionFeedbackGenerator()
    private let notification = UINotificationFeedbackGenerator()
    
    private init() {
        // Prepare generators for better responsiveness
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        selection.prepare()
        notification.prepare()
    }
    
    /// Light impact - for scrolling through movies
    func lightImpact() {
        impactLight.impactOccurred()
        impactLight.prepare()
    }
    
    /// Medium impact - for button presses
    func mediumImpact() {
        impactMedium.impactOccurred()
        impactMedium.prepare()
    }
    
    /// Heavy impact - for final selection
    func heavyImpact() {
        impactHeavy.impactOccurred()
        impactHeavy.prepare()
    }
    
    /// Selection changed - for picker changes
    func selectionChanged() {
        selection.selectionChanged()
        selection.prepare()
    }
    
    /// Success notification - when movie is selected
    func success() {
        notification.notificationOccurred(.success)
        notification.prepare()
    }
    
    /// Warning notification - for errors
    func warning() {
        notification.notificationOccurred(.warning)
        notification.prepare()
    }
    
    /// Error notification - for critical errors
    func error() {
        notification.notificationOccurred(.error)
        notification.prepare()
    }
}


