//
//  AnswerListValidator.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class AnswerListValidator: AbstractAnswerViewValidator {
  
  func isValid(idsAndTexts: [(Int, String?)]) -> Bool {
    guard let minAnswersCount = question.minAnswersCount else { return true }
    return idsAndTexts.count >= minAnswersCount
  }
}
