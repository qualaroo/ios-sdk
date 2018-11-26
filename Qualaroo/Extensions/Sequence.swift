//
//  Sequence.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

protocol OptionalType {
  associatedtype Wrapped
  func map<U>(_ element: (Wrapped) throws -> U) rethrows -> U?
}

extension Optional: OptionalType {}

extension Sequence where Iterator.Element: OptionalType {
  func removeNils() -> [Iterator.Element.Wrapped] {
    var result: [Iterator.Element.Wrapped] = []
    for element in self {
      if let element = element.map({ $0 }) {
        result.append(element)
      }
    }
    return result
  }
}
