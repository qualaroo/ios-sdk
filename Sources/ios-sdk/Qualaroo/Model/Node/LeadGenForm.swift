//
//  LeadGenForm.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class LeadGenFormFactory {
  
  let dictionary: [String: Any]
  var questions: [Question]
  
  init(with dictionary: [String: Any]) {
    self.dictionary = dictionary
    self.questions = []
  }
  
  func inject(_ questions: [Question]) throws {
    let idList = try questionIdList()
    let questionList = try idList.map({ try searchQuestionFromList(questions, forId: $0) })
    self.questions = questionList
  }
  
  private func questionIdList() throws -> [NodeId] {
    guard let list = dictionary["question_list"] as? [NSNumber],
      let questionIdList = list as? [NodeId] else {
        throw LeadGenFormError.wrongOrMissingQuestionIdList
    }
    return questionIdList
  }
  
  private func searchQuestionFromList(_ questionList: [Question],
                                      forId requiredId: NodeId) throws -> Question {
    guard let question = questionList.first(where: { $0.questionId == requiredId }) else {
      throw LeadGenFormError.noQuestionMatchId
    }
    return question
  }

  func build() throws -> LeadGenForm {
    try checkCohesion()
    return LeadGenForm(leadGenFormId: try leadGenFormId(),
                       alias: alias(),
                       description: description(),
                       font_style_decription: fontStyleDescription(),
                       buttonText: buttonText(),
                       nextNodeId: nextNodeId(),
                       questionList: questions)
  }
  
  private func checkCohesion() throws {
    guard try questionIdList().count == questions.count else {
      throw LeadGenFormError.wrongQuestionCount
    }
  }

  private func leadGenFormId() throws -> NodeId {
    guard let id = (dictionary["id"] as? NSNumber) as? NodeId else {
      throw LeadGenFormError.missingOrWrongId
    }
    return id
  }
  
  private func alias() -> String? {
    return dictionary["alias"] as? String
  }
  
  private func description() -> String {
    guard let description = dictionary["description"] as? String else {
      return ""
    }
    return description.plainText()
  }
    private func fontStyleDescription() -> String {
      guard let font_style_description = dictionary["font_style_description"] as? String else {
        return "normal"
      }
      return font_style_description.plainText()
    }
  
  private func buttonText() -> String {
    guard let nextButtonText = dictionary["send_text"] as? String else {
      return ""
    }
    return nextButtonText.plainText()
  }
  
  private func nextNodeId() -> NodeId? {
    guard
      let nextMap = dictionary["next_map"] as? [String: Any],
      let number = nextMap["id"] as? NSNumber else { return nil }
    return number as? NodeId
  }
  
}

enum LeadGenFormError: Int, QualarooError {
  case missingOrWrongId = 1
  case wrongOrMissingQuestionIdList = 2
  case noQuestionMatchId = 3
  case wrongQuestionCount = 4
}

struct LeadGenForm {

  let leadGenFormId: NodeId
  let alias: String?
  let description: String
  let font_style_decription:String
  let buttonText: String
  let nextNodeId: NodeId?
  let questionList: [Question]
  
}

extension LeadGenForm: Node {
  func nodeId() -> NodeId {
    return leadGenFormId
  }
  func nextId() -> NodeId? {
    return nextNodeId
  }
  func accept(_ visitor: NodeVisitor) {
    visitor.visit(self)
  }
}

extension LeadGenForm: Equatable {
  static func == (lhs: LeadGenForm, rhs: LeadGenForm) -> Bool {
    return lhs.leadGenFormId == rhs.leadGenFormId &&
           lhs.alias == rhs.alias &&
           lhs.description == rhs.description &&
           lhs.font_style_decription == rhs.font_style_decription &&
           lhs.buttonText == rhs.buttonText &&
           lhs.nextNodeId == rhs.nextNodeId &&
           lhs.questionList == rhs.questionList
  }
}
