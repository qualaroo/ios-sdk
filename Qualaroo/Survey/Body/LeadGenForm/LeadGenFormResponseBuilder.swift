//
//  LeadGenFormResponseBuilder.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class LeadGenFormResponseBuilder {
  
  let items: [LeadGenFormItem]
  let leadGenId: NodeId
  let leadGenAlias: String?
  init(id: NodeId,
       alias: String?,
       items: [LeadGenFormItem]) {
    self.leadGenId = id
    self.leadGenAlias = alias
    self.items = items
  }
  
  func response(with texts: [String]) -> NodeResponse? {
    guard let questions = questionModels(texts) else { return nil }
    let response = LeadGenResponse(id: leadGenId,
                                   alias: leadGenAlias,
                                   questionList: questions)
    return NodeResponse.leadGen(response)
  }
  private func questionModels(_ texts: [String]) -> [QuestionResponse]? {
    guard texts.count == items.count else { return nil }
    var responses = [QuestionResponse]()
    for (index, text) in texts.enumerated() {
      responses.append(questionModel(text: text, item: items[index]))
    }
    return responses
  }
  private func questionModel(text: String, item: LeadGenFormItem) -> QuestionResponse {
    let answer = AnswerResponse(id: nil,
                                alias: nil,
                                text: text)
    return QuestionResponse(id: item.questionId,
                            alias: item.questionAlias,
                            answerList: [answer])
  }

}
