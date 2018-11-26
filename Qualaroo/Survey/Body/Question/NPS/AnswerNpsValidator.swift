//
//  AnswerNpsValidator.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class AnswerNpsValidator: AbstractAnswerViewValidator {
  
  func isValid(selectedId: Int?) -> Bool {
    if question.isRequired {
      if let selectedId = selectedId {
      return selectedId != UISegmentedControl.noSegment &&
             selectedId < question.answerList.count
      }
    }
    return true
  }
}
