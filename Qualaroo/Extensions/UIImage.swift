//
//  UIImage.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

extension UIImage {
  
  func tinted(with color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
    defer { UIGraphicsEndImageContext() }
    guard let context = UIGraphicsGetCurrentContext() else { return self }
    context.scaleBy(x: 1.0, y: -1.0)
    context.translateBy(x: 0.0, y: -self.size.height)
    context.setBlendMode(.multiply)
    let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
    context.clip(to: rect, mask: self.cgImage!)
    color.setFill()
    context.fill(rect)
    guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
    return newImage
  }
}
