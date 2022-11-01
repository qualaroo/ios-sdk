//
//  AnswerTextValidator.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//
import Foundation

class AnswerTextValidator: AbstractAnswerViewValidator {
  
  func isValid(text: String) -> Bool {
    if question.isRequired {
      return text.count > 0
    }
    return true
  }
}
