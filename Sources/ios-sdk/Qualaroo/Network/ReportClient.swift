//
//  ReportClient.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class ReportClient {
  
  private let reportRequestProtocol: ReportRequestProtocol
  private let urlComposer: ReportUrlComposerProtocol
  private let memory: ReportRequestMemoryProtocol
  
  init(_ reportRequestProtocol: ReportRequestProtocol,
       _ urlComposer: ReportUrlComposerProtocol,
       _ memory: ReportRequestMemoryProtocol) {
    self.reportRequestProtocol = reportRequestProtocol
    self.urlComposer = urlComposer
    self.memory = memory
  }
}

extension ReportClient: SendResponseProtocol {
  func sendResponse(_ response: NodeResponse) {
    guard let url = urlComposer.responseUrl(with: response) else { return }
    memory.store(reportRequest: url.absoluteString)
    reportRequestProtocol.scheduleRequest(url)
  }
}

extension ReportClient: RecordImpressionProtocol {
  func recordImpression() {
    guard let url = urlComposer.impressionUrl() else { return }
    memory.store(reportRequest: url.absoluteString)
    reportRequestProtocol.scheduleRequest(url)
  }
}
