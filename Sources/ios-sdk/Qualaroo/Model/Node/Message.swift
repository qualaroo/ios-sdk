//
//  Message.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

inport UIKit

class MessageFactory {
  
  private let dictionary: [String: Any]
  
  init(with dictionary: [String: Any]) {
    self.dictionary = dictionary
  }
  
  func build() throws -> Message {
    return Message(messageId: try messageId(),
                   description: try description(),
                   callToAction: callToAction())
  }
  
  private func messageId() throws -> NodeId {
    guard let id = (dictionary["id"] as? NSNumber) as? NodeId else {
      throw MessageError.missingOrWrongId
    }
    return id
  }
  
  private func description() throws -> String {
    guard let description = dictionary["description"] as? String else {
      throw MessageError.missingOrWrongDescription
    }
    return description.plainText()
  }
  
  private func callToAction() -> CallToAction? {
    guard
      let ctaMap = callToActionMap(),
      let text = callToActionText(with: ctaMap),
      let url = callToActionUrl(with: ctaMap) else { return nil }
    return CallToAction(text: text, url: url)
  }
  
  private func callToActionMap() -> [String: Any]? {
    return dictionary["cta_map"] as? [String: Any]
  }
  
  private func callToActionText(with map: [String: Any]) -> String? {
    return map["text"] as? String
  }
  
  private func callToActionUrl(with map: [String: Any]) -> URL? {
    guard
      let string = map["uri"] as? String,
      let url = URL(string: string) else { return nil }
    return url
  }
  
}

enum MessageError: Int, QualarooError {
  case missingOrWrongId = 1
  case missingOrWrongDescription = 2
}

struct Message {

  let messageId: NodeId
  let description: String
  let callToAction: CallToAction?
  
}

struct CallToAction {
  
  let text: String
  let url: URL
  
}

extension Message: Node {
  func nodeId() -> NodeId {
    return messageId
  }
  func nextId() -> NodeId? {
    return nil
  }
  func accept(_ visitor: NodeVisitor) {
    visitor.visit(self)
  }
}

extension Message: Equatable {
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.messageId == rhs.messageId &&
           lhs.description == rhs.description &&
           lhs.callToAction == rhs.callToAction
  }
}

extension CallToAction: Equatable {
  static func == (lhs: CallToAction, rhs: CallToAction) -> Bool {
    return lhs.text == rhs.text &&
           lhs.url == rhs.url
  }
}
