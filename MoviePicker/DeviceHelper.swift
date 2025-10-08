//
//  DeviceHelper.swift
//  MoviePicker
//
//  Device detection and layout helpers
//

import SwiftUI

/// Device type and layout helpers
enum DeviceHelper {
    /// Check if running on iPad
    static var isiPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// Check if running on iPhone
    static var isiPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    /// Get screen width
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    /// Get screen height
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    /// Adaptive spacing based on device
    static func spacing(_ base: CGFloat) -> CGFloat {
        isiPad ? base * 1.5 : base
    }
    
    /// Adaptive font size based on device
    static func fontSize(_ base: CGFloat) -> CGFloat {
        isiPad ? base * 1.3 : base
    }
}

/// Layout values that adapt to device
extension Layout {
    static var adaptivePosterWidth: CGFloat {
        DeviceHelper.isiPad ? 500 : posterFrameWidth
    }
    
    static var adaptivePosterHeight: CGFloat {
        DeviceHelper.isiPad ? 440 : posterFrameHeight
    }
    
    static var adaptiveButtonPadding: CGFloat {
        DeviceHelper.isiPad ? 20 : 16
    }
    
    static var adaptivePickerTop: CGFloat {
        DeviceHelper.isiPad ? 180 : pickerButtonTopPadding
    }
    
    static var adaptiveActorPickerTop: CGFloat {
        DeviceHelper.isiPad ? 190 : actorPickerTopPadding
    }
}

/// Size class helper for SwiftUI views
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

