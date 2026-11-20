//
//  DeviceHelper.swift
//  MoviePicker
//
//  Size-class and geometry-based layout helpers for iPhone and iPadOS
//

import SwiftUI

/// Layout metrics derived from size class and available size (Split View / Stage Manager safe)
struct AdaptiveLayoutMetrics {
    let horizontalSizeClass: UserInterfaceSizeClass?
    let verticalSizeClass: UserInterfaceSizeClass?
    let size: CGSize
    
    var isRegularWidth: Bool {
        horizontalSizeClass == .regular
    }
    
    var isCompactHeight: Bool {
        verticalSizeClass == .compact
    }
    
    /// Centered readable column on wide windows
    var contentMaxWidth: CGFloat {
        isRegularWidth ? min(size.width, 720) : size.width
    }
    
    /// Portrait poster card width
    var posterWidth: CGFloat {
        if isRegularWidth {
            return min(380, contentMaxWidth * 0.55)
        }
        return min(340, size.width * 0.78)
    }
    
    /// Meta band under the poster image
    var posterMetaHeight: CGFloat {
        isCompactHeight ? 72 : 92
    }
    
    /// Ideal 2:3 poster image height from width
    private var idealPosterImageHeight: CGFloat {
        posterWidth * 1.5
    }
    
    /// Total card height (image + meta), clamped for short screens
    var posterHeight: CGFloat {
        let ideal = idealPosterImageHeight + posterMetaHeight
        let maxH = isCompactHeight ? size.height * 0.55 : size.height * 0.62
        return min(ideal, maxH)
    }
    
    /// Image area height after clamping total card height
    var posterImageHeight: CGFloat {
        max(96, posterHeight - posterMetaHeight)
    }
    
    /// Clearance under the floating menu button
    var pickerTopPadding: CGFloat {
        if isCompactHeight { return 28 }
        return isRegularWidth ? 72 : 100
    }
    
    var chromeSpacing: CGFloat {
        isRegularWidth ? 20 : 12
    }
    
    var buttonHorizontalPadding: CGFloat {
        isRegularWidth ? 28 : 20
    }
    
    var menuPanelWidth: CGFloat {
        min(320, size.width * 0.4)
    }
    
    var secretHitSize: CGFloat {
        isRegularWidth ? 72 : 56
    }
}

/// Legacy idiom helpers (prefer AdaptiveLayoutMetrics for layout)
enum DeviceHelper {
    static var isiPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isiPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}

/// Chooses horizontal vs vertical content based on size class
struct AdaptiveStack<Content: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    let horizontalContent: Content
    let verticalContent: Content
    
    init(@ViewBuilder horizontal: () -> Content, @ViewBuilder vertical: () -> Content) {
        self.horizontalContent = horizontal()
        self.verticalContent = vertical()
    }
    
    var body: some View {
        if horizontalSizeClass == .regular {
            horizontalContent
        } else {
            verticalContent
        }
    }
}
