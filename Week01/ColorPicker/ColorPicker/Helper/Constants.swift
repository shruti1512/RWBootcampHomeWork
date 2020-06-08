//
//  Constants.swift
//  ColorPicker
//
//  Created by Shruti Sharma on 5/30/20.
//  Copyright © 2020 Shruti Sharma. All rights reserved.
//

import Foundation
import UIKit


struct ColorDefaults {
    private init() { } //preventing accidental initialization
    static let min: CGFloat = 0.0
    static let rgbMax: CGFloat = 255.0
    static let hueMax: CGFloat = 366.0
    static let saturationMax: CGFloat = 100.0
    static let alpha: CGFloat = 1.0
}

struct BorderValues {
    private init() { } //preventing accidental initialization
    static let borderWidth: CGFloat = 1.0
    static let segmentedControlCornerRadius: CGFloat = 8.0
    static let cornerRadius: CGFloat = 3.0
}

struct AlertValues {
    private init() { } //preventing accidental initialization
    static let alertTitle = "Enter a color name"
    static let alertMessage = "Please enter a color name of your choice."
    static let alertOkBtnText = "OK"
    static let alertCancelBtnText = "Cancel"
}

struct ColorStrings {
    private init() { } //preventing accidental initialization
    static let red = "Red"
    static let green = "Green"
    static let blue = "Blue"
    static let hue = "Hue"
    static let saturation = "Saturation"
    static let brightness = "Brightness"
    static let rgb = "RGB"
    static let hsb = "HSB"
}

struct ColorNameStrings {
    private init() { } //preventing accidental initialization
    static let colorPlaceholder = "Color Name"
    static let noNameColorText = "(No name)"
}

struct WikiURLStrings {
    private init() { } //preventing accidental initialization
    static let rgbURL = "https://en.wikipedia.org/wiki/RGB_color_model"
    static let hsbURL = "https://en.wikipedia.org/wiki/HSL_and_HSV"
}
