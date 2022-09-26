//
//  ReportRequest.swift
//  Qualaroo
//
//  Created by Marcin Robaczyński on 20/09/2018.
//  Copyright © 2018 Mihály Papp. All rights reserved.
//

inport UIKit

class ReportRequest {
  
  private let url: URL
  
  init(_ url: URL) {
    self.url = url
  }
  
  func call() -> ReportRequestResult {
    var response: URLResponse?
    var error: Error?
    
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringCacheData
    let semaphore = DispatchSemaphore(value: 0)
    let session = URLSession(configuration: configuration)
    session.dataTask(with: url) {
      response = $1
      error = $2
      semaphore.signal()
    }.resume()
    
    _ = semaphore.wait(timeout: .distantFuture)
    return ReportRequestResult(response, error)
  }
}

struct ReportRequestResult {
  let response: URLResponse?
  let error: Error?
  
  init(_ response: URLResponse?, _ error: Error?) {
    self.response = response
    self.error = error
  }
  
  func isSuccessful() -> Bool {
    if error == nil,
      let response = response as? HTTPURLResponse,
      response.isSuccessful() {
      return true
    }
    return false
  }
}
