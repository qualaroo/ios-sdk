//
//  NetworkProtocols.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

typealias FailedRequestCallback = () -> Void

protocol SendResponseProtocol: class {
  func sendResponse(_ response: NodeResponse)
}

protocol RecordImpressionProtocol: class {
  func recordImpression()
}

protocol FetchSurveysProtocol: class {
  func fetchSurveys()
}

protocol ReportRequestProtocol: class {
  func scheduleRequest(_ url: URL)
}

protocol SimpleRequestProtocol: class {
  func scheduleRequest(_ url: String)
}

protocol ReportUrlComposerProtocol: class {
  func responseUrl(with response: NodeResponse) -> URL?
  func impressionUrl() -> URL?
}
