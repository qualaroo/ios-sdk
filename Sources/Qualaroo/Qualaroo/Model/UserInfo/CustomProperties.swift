//
//  CustomProperties.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

struct CustomProperties {

  var dictionary: [String: String]
  
  init(_ dictionary: [String: String]) {
    self.dictionary = dictionary
  }
  
  func checkForMissing(withKeywords keywords: [String]) -> [String] {
    var missingProperties = [String]()
    for keyword in keywords {
      if !dictionary.keys.contains(keyword) {
        missingProperties.append(keyword)
      }
    }
    return missingProperties
  }
  
}
