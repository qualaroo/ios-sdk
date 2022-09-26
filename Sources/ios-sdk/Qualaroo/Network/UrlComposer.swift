//
//  UrlComposer.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

class UrlComposer {
  
  struct ParamName {
    static let identity = "i"
    static let deviceId = "au"
    static let surveyId = "id"
    static let sessionId = "u"
  }
  
  struct UrlPiece {
    static let scheme = "https"
    static let responsePath = "/r.js"
    static let impressionPath = "/c.js"
  }
  
  struct TrackingParams {
    static let sdkVersion = "sdk_version"
    static let appId = "app_id"
    static let deviceModel = "device_model"
    static let osVersion = "os_version"
    static let platform = "os"
    static let resolution = "resolution"
    static let deviceType = "device_type"
    static let language = "language"
  }
  
  let sessionInfo: SessionInfo
  let customProperties: CustomProperties
  let host: String
  let sdkSession: SdkSession
  
  init(sessionInfo: SessionInfo,
       customProperties: CustomProperties,
       environment: Qualaroo.Environment,
       sdkSession: SdkSession) {
    self.sessionInfo = sessionInfo
    self.customProperties = customProperties
    self.host = UrlComposer.turboHost(environment: environment)
    self.sdkSession = sdkSession
  }
  
  private static func turboHost(environment: Qualaroo.Environment) -> String {
    switch environment {
    case .production:
      return "turbo.qualaroo.com"
    case .staging:
        return "turbo-staging.qualaroo.com"
    }
  }
  private func commonUrlComponents() -> URLComponents {
    var components = URLComponents()
    components.scheme = UrlPiece.scheme
    components.host = host
    return components
  }
  private func query(_ response: NodeResponse) -> [URLQueryItem] {
    switch response {
    case .question(let model):
      return query(model)
    case .leadGen(let model):
      return model.questionList.flatMap { query($0) }
    }
  }
  private func query(_ model: QuestionResponse) -> [URLQueryItem] {
    return model.answerList.map { queryItem(from: $0, with: model.id) }.removeNils()
  }
  private func queryItem(from model: AnswerResponse, with questionId: NodeId) -> URLQueryItem? {
    switch (model.id, model.text) {
    case (.some(let id), .none): return indexOnlyItem(index: id, with: questionId)
    case (.some(let id), .some(let text)): return indexAndTextItem(index: id, text: text, with: questionId)
    case (.none, .some(let text)): return textOnlyItem(text: text, with: questionId)
    case (.none, .none): return nil
    }
  }
  private func textOnlyItem(text: String, with questionId: NodeId) -> URLQueryItem? {
    return URLQueryItem(name: "r[\(questionId)][text]",
                        value: text)
  }
  private func indexOnlyItem(index: AnswerId, with questionId: NodeId) -> URLQueryItem? {
    return URLQueryItem(name: "r[\(questionId)][]",
                        value: "\(index)")
  }
  private func indexAndTextItem(index: AnswerId, text: String, with questionId: NodeId) -> URLQueryItem? {
    return URLQueryItem(name: "re[\(questionId)][\(index)]",
                        value: text)
  }
  private func sessionInfoQuery() -> [URLQueryItem] {
    return [surveyIdItem(sessionInfo.surveyId),
            deviceIdItem(sessionInfo.deviceId),
            sessionIdItem(sessionInfo.sessionId),
            clientIdItem(sessionInfo.clientId)].removeNils()
  }
  private func surveyIdItem(_ surveyId: Int) -> URLQueryItem {
    return URLQueryItem(name: ParamName.surveyId,
                        value: "\(surveyId)")
  }
  private func deviceIdItem(_ deviceId: String) -> URLQueryItem {
    return URLQueryItem(name: ParamName.deviceId,
                        value: deviceId)
  }
  private func sessionIdItem(_ sessionId: String) -> URLQueryItem {
    return URLQueryItem(name: ParamName.sessionId,
                        value: sessionId)
  }
  private func clientIdItem(_ clientId: String?) -> URLQueryItem? {
    guard let clientId = clientId else { return nil }
    return URLQueryItem(name: ParamName.identity,
                        value: clientId)
  }
  private func customPropertiesQuery() -> [URLQueryItem] {
    return customProperties.dictionary.map { URLQueryItem(name: "rp[\($0)]", value: $1) }
  }
  
  private func sdkSessionParameters() -> [URLQueryItem] {
    var result = [URLQueryItem]()
    result.append(queryItem(TrackingParams.sdkVersion, sdkSession.sdkVersion))
    result.append(queryItem(TrackingParams.appId, sdkSession.appId))
    result.append(queryItem(TrackingParams.deviceModel, sdkSession.deviceModel))
    result.append(queryItem(TrackingParams.osVersion, sdkSession.osVersion))
    result.append(queryItem(TrackingParams.platform, sdkSession.platform))
    result.append(queryItem(TrackingParams.resolution, sdkSession.resolution))
    result.append(queryItem(TrackingParams.deviceType, sdkSession.deviceType))
    result.append(queryItem(TrackingParams.language, sdkSession.language))
    return result
  }
  
  private func queryItem(_ name: String, _ value: String) -> URLQueryItem {
    return URLQueryItem(name: name, value: value)
  }
  
}

extension UrlComposer: ReportUrlComposerProtocol {
  func responseUrl(with response: NodeResponse) -> URL? {
    var components = commonUrlComponents()
    components.path = UrlPiece.responsePath
    components.queryItems = responseQuery(response)
    return components.url
  }
  private func responseQuery(_ response: NodeResponse) -> [URLQueryItem] {
    return [sessionInfoQuery(),
            customPropertiesQuery(),
            sdkSessionParameters(),
            query(response)].flatMap { $0 }
  }
  func impressionUrl() -> URL? {
    var components = commonUrlComponents()
    components.path = UrlPiece.impressionPath
    components.queryItems = impressionQuery()
    return components.url
  }
  private func impressionQuery() -> [URLQueryItem] {
    return sessionInfoQuery()
  }
}
