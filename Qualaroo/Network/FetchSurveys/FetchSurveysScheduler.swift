//
//  FetchSurveysScheduler.swift
//  QualarooSDKiOS
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

typealias FetchSurveysCallback = (FetchSurveysResult) -> Void

enum FetchSurveysResult {
  case success([Survey])
  case failure(Error)
}

protocol FetchSurveysDelegate: class {
  func fetchedSurveys(_ surveys: [Survey])
  func fetchingFinishedWithError(_ error: Error)
}

class FetchSurveysScheduler {
  
  private struct Const {
    static let surveyFetchInterval = TimeInterval(60 * 60)
  }
  
  private let url: URL
  private let authentication: String
  private let reachability: Reachability?
  private let imageStorage: ImageStorage
  private weak var delegate: FetchSurveysDelegate?
  private var timer = Timer()

  init(url: URL,
       authentication: String,
       reachability: Reachability?,
       imageStorage: ImageStorage,
       delegate: FetchSurveysDelegate) {
    self.url = url
    self.authentication = authentication
    self.reachability = reachability
    self.imageStorage = imageStorage
    self.delegate = delegate
  }
  
  deinit {
    stopObservingInternetAvailability()
  }
  
  @objc private func tryToSendRequest() {
    if isInternetAvailable() {
      sendRequest()
    } else {
      observeForInternetAvailability()
    }
  }
  
  private func sendRequest() {
    let operation = FetchSurveysOperation(url: url, authorization: authentication, imageStorage: imageStorage)
    operation.fetchSurveys { [weak self] result in
      switch result {
      case .success(let surveys):  self?.delegate?.fetchedSurveys(surveys)
      case .failure(let error): self?.delegate?.fetchingFinishedWithError(error)
      }
    }
  }
  
  private func setNewTimer() {
    timer.invalidate()
    let time = Const.surveyFetchInterval
    timer = Timer(timeInterval: time, target: self, selector: #selector(tryToSendRequest), userInfo: nil, repeats: true)
    timer.fire()
  }
}

// MARK: - Internet
extension FetchSurveysScheduler {
  
  private var center: NotificationCenter {
    return NotificationCenter.`default`
  }
  
  private func observeForInternetAvailability() {
    stopObservingInternetAvailability()
    center.addObserver(self, selector: #selector(reachabilityChanged), name: reachabilityModified, object: nil)
    try? reachability?.startNotifier()
  }
  
  private func stopObservingInternetAvailability() {
    center.removeObserver(self, name: reachabilityModified, object: reachability)
  }
  
  @objc private func reachabilityChanged() {
    guard isInternetAvailable() else { return }
    stopObservingInternetAvailability()
    fetchSurveys()
  }
  
  private func isInternetAvailable() -> Bool {
    guard let reachability = reachability else { return false }
    return reachability.currentReachabilityStatus != .notReachable
  }
}

// MARK: - FetchSurveysProtocol
extension FetchSurveysScheduler: FetchSurveysProtocol {
  
  func fetchSurveys() {
    setNewTimer()
    tryToSendRequest()
  }
}
