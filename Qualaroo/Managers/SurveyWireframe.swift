//
//  SurveyWireframe.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class SurveyWireframe {
  
  private let survey: Survey
  private let preferredLanguages: [String]
  
  init(survey: Survey, languages: [String]) {
    self.survey = survey
    self.preferredLanguages = languages
  }
  
  private func supportedLanguage() -> String {
    let preferedLanguage = preferredLanguages.first { isLanguageSupported($0) }
    return preferedLanguage ?? survey.languagesList.first!
  }
  private func isLanguageSupported(_ language: String) -> Bool {
    return survey.languagesList.contains(language)
  }
  
  func nextNodeId(for nodeId: NodeId?, answerId: AnswerId?) -> NodeId? {
    guard
      let nodeId = nodeId,
      let node = node(nodeId) else { return nil }
    if let id = answerId {
      let chosenAnswer = answer(id, forQuestionId: nodeId)
      return chosenAnswer?.nextNodeId ?? node.nextId()
    }
    return node.nextId()
  }
  
  func node(_ nodeId: NodeId?) -> Node? {
    return survey.nodeList.first { $0.nodeId() == nodeId }
  }
  
  func answer(_ answerId: AnswerId, forQuestionId questionId: NodeId) -> Answer? {
    guard let question = node(questionId) as? Question else { return nil }
    return question.answerList.first { $0.answerId == answerId }
  }

}

extension SurveyWireframe: SurveyWireframeProtocol {
  
  func firstNode() -> Node? {
    return node(survey.startMap[supportedLanguage()])
  }
  
  func nextNode(for nodeId: NodeId?, response: NodeResponse?) -> Node? {
    let answerId = selectedId(for: response)
    let nextId = nextNodeId(for: nodeId, answerId: answerId)
    return node(nextId)
  }
  private func selectedId(for response: NodeResponse?) -> AnswerId? {
    guard let response = response else { return nil }
    switch response {
    case .leadGen: return nil
    case .question(let model): return model.answerList.first?.id
    }
  }
  
  func currentSurveyId() -> Int {
    return survey.surveyId
  }
  
  func isMandatory() -> Bool {
    return survey.mandatory
  }
}
