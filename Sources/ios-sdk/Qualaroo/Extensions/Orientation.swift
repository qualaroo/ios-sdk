//
//  Orientation.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

class Orientation {
  static func scale() -> CGFloat {
    return isRegularClassSize() ? 0.66 : 1.0
  }
  
  static func isSurveyCenteredHorizontally() -> Bool {
    return !isPhonePortraitClassSize()
  }
  
  static private func isPhonePortraitClassSize() -> Bool {
    guard let keyWindow = UIApplication.shared.keyWindow else { return false }
    return keyWindow.traitCollection.horizontalSizeClass == .compact &&
           keyWindow.traitCollection.verticalSizeClass == .regular
  }
  
  static private func isRegularClassSize() -> Bool {
    guard let keyWindow = UIApplication.shared.keyWindow else { return false }
    return keyWindow.traitCollection.horizontalSizeClass == .regular &&
           keyWindow.traitCollection.verticalSizeClass == .regular
  }
}
