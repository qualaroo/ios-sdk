//
//  Question.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class QuestionFactory {

  private let dictionary: [String: Any]
  private let randomiser: ListRandomizer

  init(with dictionary: [String: Any],
       listRandomizer: ListRandomizer = ListRandomizer()) {
    self.dictionary = dictionary
    self.randomiser = listRandomizer
  }

  func build() throws -> Question {
    try checkCohesion()
    return Question(questionId: try questionId(),
                    type: try type(),
                    title: try title(),
                    fontStyleQuestion: fontStyleQuestion(),
                    description: description(),
                    fontStyleDescription: fontStyleDescription(),
                    descriptionPlacement: descriptionPlacement(),
                    buttonText: buttonText(),
                    shouldShowButton: shouldShowButton(),
                    answerList: try answerList(),
                    nextNodeId: nextNodeId(),
                    alias: alias(),
                    canonicalName: canonicalName(),
                    npsMinText: npsMinText(),
                    npsMaxText: npsMaxText(),
                    isRequired: try isRequired(),
                    minAnswersCount: try minAnswersCount(),
                    maxAnswersCount: try maxAnswersCount())
  }

  private func questionId() throws -> NodeId {
    guard let id = (dictionary["id"] as? NSNumber) as? NodeId else {
      throw QuestionError.missingOrWrongId
    }
    return id
  }
  
  private func type() throws -> Question.Category {
    guard let string = dictionary["type"] as? String else {
      throw QuestionError.missingQuestionType
    }
    let type = Question.Category(rawValue: string)
    if type == .unknown {
      throw QuestionError.unknownQuestionType
    }
    return type
  }
  
  private func title() throws -> String {
    guard let title = dictionary["title"] as? String else {
      throw QuestionError.missingOrWrongTitle
    }
    return title.plainText()
  }
    private func fontStyleQuestion()  -> String {
       let style = dictionary["font_style_question"] as? String
        return style?.plainText() ?? "normal"
    }
  
  private func description() -> String {
    let description = dictionary["description"] as? String
    return description?.plainText() ?? ""
  }
    
    private func fontStyleDescription()  -> String {
       let style = dictionary["font_style_description"] as? String
        return style?.plainText() ?? "normal"
    }
  
  private func descriptionPlacement() -> Question.DescriptionPlacement {
    if description().isEmpty {
      return .none
    }
    let string = dictionary["description_placement"] as? String
    return Question.DescriptionPlacement(rawValue: string)
  }
  
  private func answerList() throws -> [Answer] {
    let answers = try answerDefaultSequenceList()
    if try shouldShuffleAnswerList() {
      return randomiser.shuffleList(answers, keepLast: anchorCount())
    }
    return answers
  }
  
  private func answerDefaultSequenceList() throws -> [Answer] {
    return try answerDicts().map { try AnswerFactory(with: $0).build() }
  }
    
  private func answerDicts() throws -> [[String: Any]] {
    guard let answerDicts = dictionary["answer_list"] as? [[String: Any]] else {
      throw QuestionError.missingOrWrongAnswerList
    }
    return answerDicts
  }
  
  private func shouldShuffleAnswerList() throws -> Bool {
    guard let randomOrderDisabled = dictionary["disable_random"] as? Bool else {
      throw QuestionError.missingOrWrongRandomFlag
    }
    return !randomOrderDisabled
  }
  
  private func anchorCount() -> Int {
    if let count = anchorLastCount() {
      return count
    }
    if anchorOnlyLast() {
      return 1
    }
    return 0
  }
  
  private func anchorLastCount() -> Int? {
    return dictionary["anchor_last_count"] as? Int
  }
  
  private func anchorOnlyLast() -> Bool {
    guard let shouldAnchorLast = dictionary["anchor_last"] as? Bool else { return false }
    return shouldAnchorLast
  }

  private func nextNodeId() -> NodeId? {
    guard
      let nextMap = dictionary["next_map"] as? [String: Any],
      let number = nextMap["id"] as? NSNumber else { return nil }
    return number as? NodeId
  }
  
  private func buttonText() -> String {
    guard let buttonText = dictionary["send_text"] as? String else {
      return ""
    }
    return buttonText
  }

  private func shouldShowButton() -> Bool {
    guard let showButton = dictionary["always_show_send"] as? Bool else { return true }
    return showButton
  }

  private func alias() -> String? {
    return dictionary["alias"] as? String
  }
  
  private func canonicalName() -> String? {
    return dictionary["cname"] as? String
  }
  
  private func isRequired() throws -> Bool {
    return try (baseRequired() || interfeeredRequired())
  }
  
  private func baseRequired() -> Bool {
    guard let isRequired = dictionary["is_required"] as? Bool else { return false }
    return isRequired
  }
  
  private func interfeeredRequired() throws -> Bool {
    switch try type() {
    case .nps, .radio, .dropdown: return true
    default: return false
    }
  }
  
  private func npsMinText() -> String? {
    return dictionary["nps_min_label"] as? String
  }

  private func npsMaxText() -> String? {
    return dictionary["nps_max_label"] as? String
  }
  
  private func minAnswersCount() throws -> Int? {
    if let minCount = dictionary["min_answers_count"] as? Int {
      return minCount
    }
    return try isRequired() ? 1 : 0
  }
  
  private func maxAnswersCount() throws -> Int? {
    if let maxCount = dictionary["max_answers_count"] as? Int {
      return maxCount
    }
    return try answerDefaultSequenceList().count
  }

  private func checkCohesion() throws {
    try checkTypeRequirements()
    try checkAnswerCount()
  }
  
  private func checkTypeRequirements() throws {
    if try type() == .nps &&
       !isNspTypeRequirementsFulfilled() {
      throw QuestionError.npsTypeCorruption
    }
  }
  
  private func isNspTypeRequirementsFulfilled() -> Bool {
    return npsMinText() != nil && npsMaxText() != nil
  }
  
  private func checkAnswerCount() throws {
    switch try type() {
    case .nps:
      if try answerList().count != 11 {
        throw QuestionError.wrongAnswerNumber
      }
    case .binary:
      if try answerList().count != 2 {
        throw QuestionError.wrongAnswerNumber
      }
    case .radio, .checkbox, .dropdown:
      if try answerList().count == 0 {
        throw QuestionError.wrongAnswerNumber
      }
    case .emoji:
        if try answerList().count != 5 {
            throw QuestionError.wrongAnswerNumber
        }
    case .thumb:
        if try answerList().count != 2 {
            throw QuestionError.wrongAnswerNumber
        }
        
    case .text:
      if try answerList().count != 0 {
        throw QuestionError.wrongAnswerNumber
      }
    case .unknown:
      return
    }
  }
}

enum QuestionError: Int, QualarooError {
  case missingOrWrongId = 1
  case missingQuestionType = 2
  case unknownQuestionType = 3
  case missingOrWrongTitle = 4
  case missingOrWrongAnswerList = 5
  case missingOrWrongRandomFlag = 6
  case npsTypeCorruption = 7
  case wrongAnswerNumber = 8
}

struct Question {
  
  enum Category {
    case nps, checkbox, radio, text, dropdown, binary,emoji, thumb, unknown
    init(rawValue: String) {
      switch rawValue {
      case "nps": self = .nps
      case "checkbox": self = .checkbox
      case "radio": self = .radio
      case "dropdown": self = .dropdown
      case "text": self = .text
      case "text_single": self = .text
      case "binary": self = .binary
      case "emoji": self = .emoji
      case "thumb": self = .thumb
      default: self = .unknown
      }
    }
  }
  
  enum DescriptionPlacement {
    case after, before, none
    init(rawValue: String?) {
      switch rawValue {
      case "after"?: self = .after
      case "before"?: self = .before
      default: self = .after
      }
    }
  }
  
  let questionId: NodeId
  let type: Category
  let title: String
  let fontStyleQuestion:String
  let description: String
  let fontStyleDescription:String
  let descriptionPlacement: DescriptionPlacement
  let buttonText: String
  let shouldShowButton: Bool
  let answerList: [Answer]
  let nextNodeId: NodeId?
  let alias: String?
  let canonicalName: String?
  let npsMinText: String?
  let npsMaxText: String?
  let isRequired: Bool
  let minAnswersCount: Int?
  let maxAnswersCount: Int?
}

extension Question: Node {
  func nodeId() -> NodeId {
    return questionId
  }
  func nextId() -> NodeId? {
    return nextNodeId
  }
  func accept(_ visitor: NodeVisitor) {
    visitor.visit(self)
  }
}

extension Question: Equatable {
  static func == (lhs: Question, rhs: Question) -> Bool {
    return lhs.questionId == rhs.questionId &&
      lhs.type == rhs.type &&
      lhs.alias == rhs.alias &&
      lhs.title == rhs.title &&
      lhs.description == rhs.description &&
      lhs.descriptionPlacement == rhs.descriptionPlacement &&
      lhs.answerList == rhs.answerList &&
      lhs.nextNodeId == rhs.nextNodeId &&
      lhs.buttonText == rhs.buttonText &&
      lhs.shouldShowButton == rhs.shouldShowButton &&
      lhs.canonicalName == rhs.canonicalName &&
      lhs.isRequired == rhs.isRequired &&
      lhs.npsMinText == rhs.npsMinText &&
      lhs.npsMaxText == rhs.npsMaxText  }
}

class ListRandomizer {
  func shuffleList<T>(_ list: [T], keepLast anchorCount: Int) -> [T] {
    guard list.count >= anchorCount else {
      return list
    }
    let lastElements = list.suffix(anchorCount)
    var newList = Array(list.dropLast(anchorCount))
    newList = newList.shuffled()
    newList.append(contentsOf: lastElements)
    return newList
  }
}
