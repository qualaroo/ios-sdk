//
//  LeadGenFormValidator.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class LeadGenFormValidator {
  
  let items: [LeadGenFormItem]
  init(items: [LeadGenFormItem]) {
    self.items = items
  }
  
  func isValid(with texts: [String]) -> Bool {
    guard texts.count == items.count else { return false }
    for (index, text) in texts.enumerated() {
      let isRequired = items[index].isRequired
      if isRequired &&
         text.count == 0 {
        return false
      }
    }
    return true
  }

}
