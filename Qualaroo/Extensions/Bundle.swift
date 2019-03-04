//
//  Bundle.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

extension Bundle {
  /// Convenience way to get Qualaroo bundle.
  ///
  /// - Returns: Bundle used by Qualaroo Framework.
  static func qualaroo() -> Bundle? {
    guard let path = Bundle(for: Qualaroo.self).path(forResource: "Qualaroo", ofType: "bundle") else { return nil }
    return Bundle(path: path)
  }
}
