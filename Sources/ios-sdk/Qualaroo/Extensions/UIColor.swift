//
//  UIColor.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

extension UIColor {
  convenience init?(red: UInt, green: UInt, blue: UInt) {
    guard red <= 255, green <= 255, blue <= 255 else { return nil }
    self.init(red: CGFloat(red) / 255.0,
              green: CGFloat(green) / 255.0,
              blue: CGFloat(blue) / 255.0,
              alpha: 1.0)
  }
  
  convenience init?(fromHex hex: Any?) {
    guard let hex = hex as? String,
              hex.hasPrefix("#"),
              hex.count == 7 else {
      return nil
    }
    let string = hex.replacingOccurrences(of: "#", with: "")
    let scanner = Scanner(string: string)
    var hexNumber: UInt64 = 0
    if scanner.scanHexInt64(&hexNumber) == false { return nil }
    let red = UInt((hexNumber & 0xff0000) >> 16)
    let green = UInt((hexNumber & 0x00ff00) >> 8)
    let blue = UInt(hexNumber & 0x0000ff)
    self.init(red: red, green: green, blue: blue)
  }
}
