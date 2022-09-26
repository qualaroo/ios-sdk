//
//  SurveyEventsDelegate.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

/// Delegate that handles events sent by Survey.
@objc(QualarooSurveyDelegate)
public protocol SurveyDelegate: class {
  /// Survey view has loaded.
  func surveyDidStart()
  /// User has dismissed survey before finishing it.
  func surveyDidDismiss()
  /// User finished survey (or dismissed it on last message).
  func surveyDidFinish()
  /// Some internal error occured. Survey was closed and probably not finished.
  func surveyDidClose(errorMessage: String)
  /// Some question will be sending callbacks after user has responded. This method is optional.
  @objc optional func userDidAnswerQuestion(_ response: UserResponse)
}

/// Class used for getting info about how user answered questions.
public class UserResponse: NSObject {
  public typealias QuestionAlias = String
  public typealias AnswerAlias = String
  
  let questionAlias: QuestionAlias
  let selectedAnswers: [UserAnswer]
  
  init(questionAlias: String,
       selectedAnswers: [UserAnswer]) {
    self.questionAlias = questionAlias
    self.selectedAnswers = selectedAnswers
  }
  
  class UserAnswer: NSObject {
    
    let alias: String
    let text: String?
    
    init(answerAlias: AnswerAlias,
         answerText: String?) {
      self.alias = answerAlias
      self.text = answerText
    }
  }
  
  /// Returns alias of question that user responded to.
  ///
  /// - Returns: String that is used as identifier of answered question.
  @objc public func getQuestionAlias() -> QuestionAlias {
    return questionAlias
  }
  /// Returns array of selected options. If question was radio, dropdown, or NPS type then array contain only one element.
  /// For text questions array will contain only element with alias "text".
  ///
  /// - Returns: Array of strings that represent selected elements.
  @objc public func getFilledElements() -> [AnswerAlias] {
    return selectedAnswers.map { $0.alias }
  }
  /// Returns text associated with selected element.
  /// This represents a text answer provided by the user.
  ///
  /// - Parameter alias: Identifier of element we want to check.
  /// - Returns: Text provided by the user, or nil it there was none.
  @objc public func getElementText(_ alias: AnswerAlias) -> String? {
    return selectedAnswers.first(where: { $0.alias == alias })?.text
  }
  
}
