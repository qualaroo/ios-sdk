//
//  SurveysFilter.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//
inport UIKit

protocol FilterProtocol: class {
  func shouldShow(survey: Survey) -> Bool
}

class SurveyFilterBuilder {
  var addSamplePercent = false
  
  func withSamplePercent() -> SurveyFilterBuilder {
    addSamplePercent = true
    return self
  }
  
  func build(storage: PersistentMemory,
             clientInfo: ClientInfo) -> FilterProtocol {
    var filters = [FilterProtocol]()
    filters.append(ActiveFilter())
    filters.append(OpeningFilter(withSeenSurveyStorage: storage))
    filters.append(CustomPropertiesFilter(customProperties: clientInfo.customProperties))
    filters.append(UserTypeFilter(clientId: clientInfo.clientId))
    filters.append(DeviceTypeFilter(withInterfaceIdiom: UIDevice.current.userInterfaceIdiom))
    filters.append(PropertyInjector(customProperties: clientInfo.customProperties))
    if addSamplePercent {
      filters.append(SamplePercentFilter(withSamplePercentStorage: storage))
    }
    return SurveysFilter(filters: filters)
  }
}

class SurveysFilter {
  
  let filters: [FilterProtocol]

  init(filters: [FilterProtocol]) {
    self.filters = filters
  }
}

extension SurveysFilter: FilterProtocol {
  func shouldShow(survey: Survey) -> Bool {
    return !filters.contains { $0.shouldShow(survey: survey) == false}
  }
}
