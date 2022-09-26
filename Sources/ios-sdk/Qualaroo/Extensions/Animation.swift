//
//  ChainedAnimation.swift
//  ChainedAnimation
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import Foundation
import UIKit

typealias AnimationBlock = () -> Void
typealias AnimationCompletion = (Bool) -> Void

protocol Animatable: class {
  func run()
  func run(withCompletion completion: @escaping AnimationCompletion)
  func duration() -> TimeInterval
}

extension Animatable {
  func run() {
    run(withCompletion: { _ in })
  }
  func then(_ animation: Animatable) -> Animatable {
    return AnimationSequence(animations: [self, animation])
  }
  func group(_ animation: Animatable) -> Animatable {
    return AnimationGroup(animations: [self, animation])
  }
  func wait(_ duration: TimeInterval) -> Animatable {
    let emptyAnimation = Animation(duration: duration, {})
    return AnimationSequence(animations: [self, emptyAnimation])
  }
}

class Animation {
  private let animation: AnimationBlock
  private let animationOptions: UIView.AnimationOptions
  private let animationTime: TimeInterval
  
  init(options: UIView.AnimationOptions = [.beginFromCurrentState],
       duration: TimeInterval,
       _ animation: @escaping AnimationBlock) {
    self.animation = animation
    self.animationOptions = options
    self.animationTime = duration
  }
  
  static func group(_ animations: [Animatable]) -> Animatable {
    return AnimationGroup(animations: animations)
  }
  static func then(_ animations: [Animatable]) -> Animatable {
    return AnimationSequence(animations: animations)
  }
}

extension Animation: Animatable {
  func run(withCompletion completion: @escaping AnimationCompletion) {
    UIView.animate(withDuration: animationTime,
                   delay: 0,
                   options: animationOptions,
                   animations: animation,
                   completion: completion)
  }
  func duration() -> TimeInterval {
    return animationTime
  }
}

private class AnimationSequence {
  private let animations: [Animatable]
  private let animationsTime: TimeInterval
  private var currentAnimation: Int = 0
  
  init(animations: [Animatable]) {
    self.animations = animations
    self.animationsTime = animations.map { $0.duration() }.reduce(0, +)
  }
}

extension AnimationSequence: Animatable {
  func run(withCompletion completion: @escaping AnimationCompletion) {
    guard currentAnimation < animations.count else {
      completion(true)
      return
    }
    animations[currentAnimation].run { _ in
      self.currentAnimation += 1
      self.run(withCompletion: completion)
    }
  }
  
  func duration() -> TimeInterval {
    return animationsTime
  }
}

private class AnimationGroup {
  private let animations: [Animatable]
  private let animationsTime: TimeInterval
  
  init(animations: [Animatable]) {
    self.animations = animations
    self.animationsTime = animations.map { $0.duration() }.max() ?? 0
  }
}

extension AnimationGroup: Animatable {
  func run(withCompletion completion: @escaping AnimationCompletion) {
    let animationGroup = DispatchGroup()
    for animation in animations {
      animationGroup.enter()
      animation.run(withCompletion: { _ in animationGroup.leave() })
    }
    animationGroup.notify(queue: .main) {
      completion(true)
    }
  }
  func duration() -> TimeInterval {
    return animationsTime
  }
}
