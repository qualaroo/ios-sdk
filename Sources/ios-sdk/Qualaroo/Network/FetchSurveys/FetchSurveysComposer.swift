//
//  FetchSurveysComposer.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class FetchSurveysComposer {
  
  let siteId: String
  let deviceId: String
  let appId: String?
  let environment: Qualaroo.Environment
  
  init(siteId: String, deviceId: String, appId: String? = nil, environment: Qualaroo.Environment) {
    self.siteId = siteId
    self.deviceId = deviceId
    self.appId = appId ?? Bundle.main.bundleIdentifier
    self.environment = environment
  }

  func url() -> URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = surveysHost()
    components.path = "/api/v1.5/surveys"
    components.queryItems = query()
    return components.url
  }

  private func query() -> [URLQueryItem] {
    return requiredPath() + basicAnalitycsPath()
  }
  
  private func requiredPath() -> [URLQueryItem] {
    return [URLQueryItem(name: "site_id", value: siteId),
            URLQueryItem(name: "spec", value: "1"),
            URLQueryItem(name: "no_superpack", value: "1")]
  }

  private func basicAnalitycsPath() -> [URLQueryItem] {
    return versionQuery() + appIdQuery() + deviceQuery()
  }

  private func versionQuery() -> [URLQueryItem] {
    guard let version = Bundle.qualaroo()?.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
      return []
    }
    return [URLQueryItem(name: "sdk_version", value: version)]
  }

  private func appIdQuery() -> [URLQueryItem] {
    if let appId = appId {
      return [URLQueryItem(name: "client_app", value: appId)]
    }
    return [URLQueryItem(name: "client_app", value: "unknown")]
  }
  
  private func deviceQuery() -> [URLQueryItem] {
    return [URLQueryItem(name: "device_type", value: UIDevice.current.model),
            URLQueryItem(name: "os_version", value: UIDevice.current.systemVersion),
            URLQueryItem(name: "os", value: "iOS"),
            URLQueryItem(name: "device_id", value: deviceId)]

  }

  func authentication(apiKey: String, apiSecret: String) -> String {
    let data = "\(apiKey):\(apiSecret)".data(using: .utf8)
    let encodedKey = (data != nil) ? data!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0)) : ""
    return  "Basic \(encodedKey)"
  }

  private func surveysHost() -> String {
    switch environment {
    case .production:
      return "api.qualaroo.com"
    case .staging:
        return "staging.qualaroo.com"
    }
  }

}
