//
//  UIButton.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit
import UIKit

extension UIButton {
  func setBackgroundColor(color: UIColor, forState state: UIControl.State) {
    UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
    if let currentContext = UIGraphicsGetCurrentContext() {
        currentContext.setFillColor(color.cgColor)
        currentContext.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
    }    
    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.setBackgroundImage(colorImage, for: state)
  }
}
