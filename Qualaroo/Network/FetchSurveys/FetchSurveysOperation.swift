//
//  FetchSurveyRequest.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation

class FetchSurveysOperation {
  
  let url: URL
  let authorization: String
  weak var imageStorage: ImageStorage?
  
  init(url: URL,
       authorization: String,
       imageStorage: ImageStorage) {
    self.url = url
    self.authorization = authorization
    self.imageStorage = imageStorage
  }
  
  func fetchSurveys(with completion: @escaping FetchSurveysCallback) {
    session().dataTask(with: url) { (data, _, error) in
      if let error = error {
        completion(.failure(error))
        return
      }
      guard let data = data else {
        completion(.failure(FetchSurveyError.noDataFetched))
        return
      }
      do {
        let surveyList = try self.surveys(from: data)
        completion(.success(surveyList))
      } catch let error {
        completion(.failure(error))
      }
    }.resume()
  }
  
  private func session() -> URLSession {
    return URLSession(configuration: configuration())
  }
  
  private func configuration() -> URLSessionConfiguration {
    let configuration = URLSessionConfiguration.`default`
    configuration.httpAdditionalHeaders = ["Authorization": authorization]
    configuration.requestCachePolicy = .useProtocolCachePolicy
    return configuration
  }

  private func surveys(from data: Data) throws -> [Survey] {
    let dict = try self.rawDict(from: data)
    return self.prefetchedSurveys(dict: dict)
  }
  
  private func rawDict(from data: Data) throws -> [[String: Any]] {
    let json = try JSONSerialization.jsonObject(with: data, options: [])
    guard let dict = json as? [[String: Any]] else {
        throw FetchSurveyError.noDataFetched
    }
    return dict
  }
  
  private func prefetchedSurveys(dict: [[String: Any]]) -> [Survey] {
    let parsedSurveys = surveys(from: dict)
    parsedSurveys.forEach { prefetchLogo(for: $0) }
    return parsedSurveys
  }
  
  private func surveys(from dictionaries: [[String: Any]]) -> [Survey] {
    return dictionaries.map { createSurveyWithErrorThrowing(from: $0) }.removeNils()
  }
  
  private func createSurveyWithErrorThrowing(from dict: [String: Any]) -> Survey? {
    do {
      return try SurveyFactory(with: dict).build()
    } catch SurveyError.surveyIsInactive {
      Qualaroo.log("Survey is inactive. Activate it on dashboard.")
    } catch let error {
      Qualaroo.log(error)
    }
    return nil
  }
  
  private func prefetchLogo(for survey: Survey) {
    imageStorage?.getImage(forUrl: survey.theme.logoUrlString)
  }
    
  enum FetchSurveyError: Int, QualarooError {
    case noDataFetched = 1
    case emptyOrMalformedDataFetched = 2
  }
}
