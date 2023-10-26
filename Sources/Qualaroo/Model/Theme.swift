//
//  Theme.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation
import UIKit

struct ColorTheme : Equatable {
  
  let background: UIColor
  let text: UIColor
  let uiNormal: UIColor
  let uiSelected: UIColor
  let buttonEnabled: UIColor
  let buttonDisabled: UIColor
  let buttonTextEnabled: UIColor
  let buttonTextDisabled: UIColor
  let npsBackgroundColor: UIColor
  let npsSelectedColor: UIColor
  let ansColor: UIColor
  let ansSelectedColor: UIColor
  
  init(background: UIColor,
       text: UIColor,
       uiNormal: UIColor,
       uiSelected: UIColor,
       buttonEnabled: UIColor,
       buttonDisabled: UIColor,
       buttonTextEnabled: UIColor,
       buttonTextDisabled: UIColor,
       npsBackgroundColor: UIColor,
       npsSelectedColor: UIColor,
       ansColor: UIColor,
       ansSelectedColor: UIColor
  ) {
    self.background = background
    self.text = text
    self.uiNormal = uiNormal
    self.uiSelected = uiSelected
    self.buttonDisabled = buttonDisabled
    self.buttonEnabled = buttonEnabled
    self.buttonTextEnabled = buttonTextEnabled
    self.buttonTextDisabled = buttonTextDisabled
    self.npsBackgroundColor = npsBackgroundColor
    self.npsSelectedColor = npsSelectedColor
    self.ansColor = ansColor
    self.ansSelectedColor = ansSelectedColor
  }
  
  static func == (lhs: ColorTheme, rhs: ColorTheme) -> Bool {
    return lhs.background == rhs.background &&
      lhs.text == rhs.text &&
      lhs.buttonDisabled == rhs.buttonDisabled &&
      lhs.buttonEnabled == rhs.buttonEnabled &&
      lhs.buttonTextEnabled == rhs.buttonTextEnabled &&
      lhs.buttonTextDisabled == rhs.buttonTextDisabled
  }
}

struct Theme: Equatable {

  let colors: ColorTheme
  let logoUrlString: String
  let dimType: UIBlurEffect.Style
  let dimAlpha: CGFloat
  let keyboardStyle: UIKeyboardAppearance
  let fullscreen: Bool
  let closeButtonVisible: Bool
  let progressBarLocation: ProgressBarLocation
  
  private init(colors: ColorTheme,
               logoUrlString: String,
               dimType: UIBlurEffect.Style,
               dimAlpha: CGFloat,
               fullscreen: Bool,
               closeButtonVisible: Bool,
               progressBarLocation: ProgressBarLocation) {
    self.colors = colors
    self.logoUrlString = logoUrlString
    self.dimType = dimType
    self.dimAlpha = dimAlpha
    self.keyboardStyle = (dimType == .dark) ? UIKeyboardAppearance.dark : UIKeyboardAppearance.light
    self.fullscreen = fullscreen
    self.closeButtonVisible = closeButtonVisible
    self.progressBarLocation = progressBarLocation
  }
  
  static func create(with dictionary: [String: Any],
                     logoUrlString: String,
                     fullscreen: Bool,
                     closeButtonVisible: Bool,
                     progressBar: String) -> Theme? {
    
    let progressBarLocation = ProgressBarLocation.fromValue(progressBar)
    let colors = getColorTheme(from: dictionary)                  
    let dimOpacity = dictionary["dim_opacity"] as? CGFloat ?? 1
    let dimStyleName = dictionary["dim_type"] as? String
    let dimType = Theme.dimStyle(dimStyleName)
    return Theme(colors: colors,
                 logoUrlString: logoUrlString,
                 dimType: dimType,
                 dimAlpha: dimOpacity,
                 fullscreen: fullscreen,
                 closeButtonVisible: closeButtonVisible,
                 progressBarLocation: progressBarLocation)
  }

  private static func getColorTheme(from dictionary: [String: Any]) -> ColorTheme {
    if let theme = Theme.newStyleColors(dictionary) {
      return theme
    }
    if let theme = Theme.oldStyleColors(dictionary) {
      return theme
    }
    return fallbackColorTheme()
  }
  
  private static func newStyleColors(_ dictionary: [String: Any]) -> ColorTheme? {
    guard
      let background = UIColor(fromHex: dictionary["background_color"]),
      let text = UIColor(fromHex: dictionary["text_color"]),
      let uiNormal = UIColor(fromHex: dictionary["ui_normal"]),
      let uiSelected = UIColor(fromHex: dictionary["ui_selected"]),
      let buttonEnabled = UIColor(fromHex: dictionary["button_enabled_color"]),
      let buttonDisabled = UIColor(fromHex: dictionary["button_disabled_color"]),
      let buttonTextEnabled = UIColor(fromHex: dictionary["button_text_enabled"]),
      let buttonTextDisabled = UIColor(fromHex: dictionary["button_text_disabled"]),
      let npsBackgroundColor  = UIColor(fromHex: dictionary["nps_background_color"]),
      let npsSelectedColor  = UIColor(fromHex: dictionary["nps_selected_color"]),
      let ansColor = UIColor(fromHex: dictionary["ans_color"]),
      let ansSelectedColor = UIColor(fromHex: dictionary["ans_selected_color"]) else { return nil }
  return ColorTheme(background: background,
                    text: text,
                    uiNormal: uiNormal,
                    uiSelected: uiSelected,
                    buttonEnabled: buttonEnabled,
                    buttonDisabled: buttonDisabled,
                    buttonTextEnabled: buttonTextEnabled,
                    buttonTextDisabled: buttonTextDisabled,
                    npsBackgroundColor: npsBackgroundColor,
                    npsSelectedColor: npsSelectedColor,
                    ansColor: ansColor,
                    ansSelectedColor: ansSelectedColor)
  }
  
  private static func oldStyleColors(_ dictionary: [String: Any]) -> ColorTheme? {
    guard
      let background = UIColor(fromHex: dictionary["background_color"]),
      let border = UIColor(fromHex: dictionary["border_color"]),
      let text = UIColor(fromHex: dictionary["text_color"]),
      let buttonText = UIColor(fromHex: dictionary["button_text_color"]),
      let buttonDisabled = UIColor(fromHex: dictionary["button_disabled_color"]),
      let buttonEnabled = UIColor(fromHex: dictionary["button_enabled_color"]),
      let npsBackgroundColor  = UIColor(fromHex: dictionary["nps_background_color"]),
      let npsSelectedColor  = UIColor(fromHex: dictionary["nps_selected_color"]),
      let ansColor = UIColor(fromHex: dictionary["ans_color"]),
      let ansSelectedColor = UIColor(fromHex: dictionary["ans_selected_color"]) else { return nil }
    return ColorTheme(background: background,
                      text: text,
                      uiNormal: border,
                      uiSelected: border,
                      buttonEnabled: buttonEnabled,
                      buttonDisabled: buttonDisabled,
                      buttonTextEnabled: buttonText,
                      buttonTextDisabled: buttonText,
                      npsBackgroundColor: npsBackgroundColor,
                      npsSelectedColor: npsSelectedColor,
                      ansColor: ansColor,
                      ansSelectedColor: ansSelectedColor)
  }
  
  internal static func fallbackColorTheme() -> ColorTheme {
    return ColorTheme(background: UIColor.white,
                      text: UIColor.black,
                      uiNormal: UIColor.darkGray,
                      uiSelected: UIColor.black,
                      buttonEnabled: UIColor.darkGray,
                      buttonDisabled: UIColor.lightGray,
                      buttonTextEnabled: UIColor.black,
                      buttonTextDisabled: UIColor.black,
                      npsBackgroundColor: UIColor.darkGray,
                      npsSelectedColor: UIColor.black,
                      ansColor: UIColor.darkGray,
                      ansSelectedColor: UIColor.black
    )
  }
    
  private static func dimStyle(_ string: String?) -> UIBlurEffect.Style {
    switch string {
    case "very_light":
      return .extraLight
    case "light":
      return .light
    case "dark":
      return .dark
    default:
      return .dark
    }
  }
  
  static func == (lhs: Theme, rhs: Theme) -> Bool {
    return lhs.logoUrlString == rhs.logoUrlString &&
           lhs.colors.background == rhs.colors.background &&
           lhs.colors.text == rhs.colors.text &&
           lhs.colors.buttonDisabled == rhs.colors.buttonDisabled &&
           lhs.colors.buttonEnabled == rhs.colors.buttonEnabled &&
           lhs.colors.buttonTextEnabled == rhs.colors.buttonTextEnabled &&
           lhs.colors.buttonTextDisabled == rhs.colors.buttonTextDisabled &&
           lhs.dimType == rhs.dimType &&
           lhs.dimAlpha == rhs.dimAlpha &&
           lhs.keyboardStyle == rhs.keyboardStyle &&
           lhs.fullscreen == rhs.fullscreen &&
           lhs.closeButtonVisible == rhs.closeButtonVisible
  }

  enum ProgressBarLocation {
    case top, bottom, none
    
    static func fromValue(_ value: String) -> ProgressBarLocation {
      switch value {
      case "top":
        return ProgressBarLocation.top
      case "bottom":
        return ProgressBarLocation.bottom
      default:
        return ProgressBarLocation.none
      }
    }
  }
}
