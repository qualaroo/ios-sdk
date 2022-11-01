//
//  String.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation
import UIKit

extension String {
  /// Used to count height that text needs to display properly.
  ///
  /// - Parameters:
  ///   - width: CGFloat value that is maximum width which text can use.
  ///   - font: UIFont used to display text.
  /// - Returns: Height that label will need to display text properly
  func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect,
                                        options: .usesLineFragmentOrigin,
                                        attributes: [NSAttributedString.Key.font: font],
                                        context: nil)
    return boundingBox.height
  }
  
  func range(from nsRange: NSRange) -> Range<String.Index> {
    guard
      let start16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
      let end16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
      let start = start16.samePosition(in: self),
      let end = end16.samePosition(in: self)
      else { return startIndex ..< startIndex }
    return start ..< end
  }
  
  func plainText() -> String {
    return self.removeParagraphs().parseNewLines()
  }
  
  private func removeParagraphs() -> String {
    return self.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "</p>", with: "")
  }
  
  private func parseNewLines() -> String {
    return self.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<br/>", with: "\n")
  }
  
  subscript (bounds: CountableRange<Int>) -> String {
    let start = index(startIndex, offsetBy: bounds.lowerBound)
    let end = index(startIndex, offsetBy: bounds.upperBound)
    return String(self[start..<end])
  }
  var isNumber: Bool {
    return Double(self) != nil
  }

}
