//
//  QualarooJSONLibrary.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit
@testable import Qualaroo

class JsonLibrary {
  static func newColorTheme() -> [String: Any] {
    var theme = [String: Any]()
    theme["background_color"] = "#000000"
    theme["text_color"] = "#000000"
    theme["ui_normal"] = "#000000"
    theme["ui_selected"] = "#000000"
    theme["button_enabled_color"] = "#000000"
    theme["button_disabled_color"] = "#000000"
    theme["button_text_enabled"] = "#000000"
    theme["button_text_disabled"] = "#000000"
    theme["dim_type"] = "dark"
    return theme
  }
  static func oldColorTheme() -> [String: Any] {
    return ["background_color": "#ffffff",
            "border_color": "#ffffff",
            "text_color": "#ffffff",
            "dim_type": "light",
            "button_text_color": "#ffffff",
            "button_disabled_color": "#ffffff",
            "button_enabled_color": "#ffffff"]
  }
  static func optionMap(mandatory: Bool) -> [String: Any] {
    return ["color_theme_map": newColorTheme(),
            "mandatory": mandatory]
  }
  static func survey(id surveyId: Int? = 1,
                     name: String? = "name",
                     active: Bool? = true,
                     siteId: Int? = 1,
                     canonicalName: String? = "canonicalName",
                     questionList: [String: Any]? = [:],
                     messagesList: [String: Any]? = [:],
                     leadGenFormList: [String: Any]? = [:],
                     startMap: [String: Any]? = [:],
                     languagesList: [String]? = [],
                     requireMap: [String: Any]? = [:],
                     mandatory: Bool = true) -> [String: Any] {
    var survey = [String: Any]()
    survey["id"] = surveyId ?? NSNull()
    survey["name"] = name ?? NSNull()
    survey["active"] = active ?? NSNull()
    survey["site_id"] = siteId ?? NSNull()
    survey["canonical_name"] = canonicalName ?? NSNull()
    survey["kind"] = "embed"
    var spec = [String: Any]()
    spec["id"] = surveyId ?? NSNull()
    spec["name"] = name ?? NSNull()
    spec["question_list"] = questionList ?? NSNull()
    spec["msg_screen_list"] = messagesList ?? NSNull()
    spec["qscreen_list"] = leadGenFormList ?? NSNull()
    spec["start_map"] = startMap ?? NSNull()
    spec["survey_variations"] = languagesList ?? NSNull()
    spec["require_map"] = requireMap ?? NSNull()
    spec["option_map"] = optionMap(mandatory: mandatory)
    survey["spec"] = spec
    return survey
  }
  static func leadGenForm(id leadGenFormId: NodeId? = 1,
                          description: String? = "description",
                          sendText: String? = "Next",
                          nextMap: [String: Any]? = [:],
                          questionIdList: [NodeId]? = [NodeId](),
                          isRequired: Bool? = nil) -> [String: Any] {
    var form = [String: Any]()
    form["id"] = leadGenFormId ?? NSNull()
    form["description"] = description ?? NSNull()
    if sendText != nil {
      form["send_text"] = sendText
    }
    form["next_map"] = nextMap ?? NSNull()
    form["question_list"] = questionIdList ?? NSNull()
    form["is_required"] = isRequired ?? NSNull()
    return form
  }
  static func message(id messageId: NodeId? = 1,
                      description: String? = "description",
                      ctaMap: [String: Any]? = [:]) -> [String: Any] {
    var message = [String: Any]()
    message["id"] = messageId ?? NSNull()
    message["description"] = description ?? NSNull()
    message["cta_map"] = ctaMap ?? NSNull()
    return message
  }
  static func question(id questionId: NodeId = 1,
                       alias: String? = nil,
                       type: String = "text",
                       title: String = "title",
                       description: String? = nil,
                       answerList: [[String: Any]] = [],
                       disableRandom: Bool = true,
                       anchorLast: Bool = false,
                       isRequired: Bool = false) -> [String: Any] {
    var question = [String: Any]()
    question["id"] = questionId
    question["type"] = type
    question["alias"] = alias ?? NSNull()
    question["title"] = title
    question["description"] = description ?? NSNull()
    question["answer_list"] = answerList
    question["disable_random"] = disableRandom
    question["anchor_last"] = anchorLast
    question["send_text"] = "Next"
    question["is_required"] = isRequired
    return question
  }
  static func answer(id answerId: AnswerId? = 1,
                     title: String? = "title",
                     nextMap: [String: Any]? = [:]) -> [String: Any] {
    var answer = [String: Any]()
    answer["id"] = answerId ?? NSNull()
    answer["title"] = title ?? NSNull()
    answer["next_map"] = nextMap ?? NSNull()
    return answer
  }
  static func goodMessage() -> [String: Any] {
    return ["id": 345690,
            "type": "message",
            "show_checkmark": true,
            "description": "Thank you!"]
  }
  static func leadGenItem(id: NodeId = 1,
                          title: String = "title",
                          canonicalName: String? = nil,
                          alias: String? = nil,
                          keyboardType: UIKeyboardType = .alphabet,
                          isRequired: Bool = false) -> LeadGenFormItem {
    return (id, canonicalName, alias, title, keyboardType, isRequired)
  }
  static func questionResponse(id: NodeId = 1,
                               alias: String? = nil,
                               selected: [AnswerId] = []) -> NodeResponse {
    let answers = selected.map { AnswerResponse(id: $0, alias: nil, text: nil) }
    let model = QuestionResponse(id: id, alias: alias, answerList: answers)
    return NodeResponse.question(model)
  }
  static func emptyLeadGenResponse(id: NodeId = 1,
                                   alias: String? = nil) -> NodeResponse {
    let model = LeadGenResponse(id: id, alias: alias, questionList: [])
    return NodeResponse.leadGen(model)
  }
}
