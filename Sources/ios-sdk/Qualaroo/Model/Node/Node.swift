//
//  Node.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

typealias NodeId = Int64

protocol Node {
  func nodeId() -> NodeId
  func nextId() -> NodeId?
  func accept(_ visitor: NodeVisitor)
}

extension Node {
  static func nextNodeId(fromNextMap nextMap: Any?) -> NodeId? {
    guard
      let nextMap = nextMap as? [String: Any],
      let number = nextMap["id"] as? NSNumber else { return nil }
    return number as? NodeId
  }
}

protocol NodeVisitor: class {
  func visit(_ node: Message)
  func visit(_ node: Question)
  func visit(_ node: LeadGenForm)
}
