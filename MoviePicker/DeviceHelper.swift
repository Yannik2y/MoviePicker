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
    
    var posterWidth: CGFloat {
        if isRegularWidth {
            return min(500, contentMaxWidth * 0.7)
        }
        return min(Layout.posterFrameWidth, size.width * 0.92)
    }
    
    var posterHeight: CGFloat {
        let maxH = isCompactHeight ? size.height * 0.42 : size.height * 0.45
        let ideal = posterWidth * (isRegularWidth ? 0.88 : 0.88)
        return min(ideal, maxH, isRegularWidth ? 440 : Layout.posterFrameHeight)
    }
    
    var posterImageHeight: CGFloat {
        min(Layout.posterImageHeight * (isRegularWidth ? 1.15 : 1.0), posterHeight * 0.55)
    }
    
    var pickerTopPadding: CGFloat {
        if isCompactHeight { return 24 }
        return isRegularWidth ? 48 : 56
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
