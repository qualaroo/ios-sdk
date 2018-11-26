//
//  SurveyQuestionView.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

class SurveyHeaderView: XibView {
  
  struct CopyViewModel {
    let title: String
    let description: String?
    let descriptionPlacement: Question.DescriptionPlacement
  }
  
  struct CloseButtonViewModel {
    let color: UIColor
    let hidden: Bool
  }
  
  weak var delegate: SurveyViewDelegate?
  private var realLogoImage: UIImage?
  private weak var imageStorage: ImageStorage?

  private struct Const {
    static let textToLogoDistance: CGFloat = 6
    static let logoCornerRadius: CGFloat = 10
    static let logoContainerDefaultSize: CGFloat = 56
    static let logoContainerExtendedSize: CGFloat = 66
    static let questionTitleFont = UIFont.boldSystemFont(ofSize: 16)
    static let questionDescriptionFont = UIFont.systemFont(ofSize: 16)
    static let messageFont = UIFont.systemFont(ofSize: 18)
  }
  
  // MARK: - Outlets
  @IBOutlet weak var logoContainer: UIView!
  @IBOutlet weak var logoImage: UIImageView!
  @IBOutlet weak var upperLabel: UILabel!
  @IBOutlet weak var lowerLabel: UILabel!
  @IBOutlet weak var closeButton: UIButton!
  
  // MARK: - Constraints
  @IBOutlet weak var logoToTextConstraint: NSLayoutConstraint!
  @IBOutlet weak var logoVerticalCenterConstraint: NSLayoutConstraint!
  @IBOutlet weak var edgeToLogoConstraint: NSLayoutConstraint!
  @IBOutlet weak var logoHorizontalCenterConstraint: NSLayoutConstraint!
  @IBOutlet weak var logoToTextVerticalConstraint: NSLayoutConstraint!
  @IBOutlet weak var edgeToTextConstraint: NSLayoutConstraint!
  @IBOutlet weak var textMarginConstraint: NSLayoutConstraint!
  @IBOutlet weak var logoContainerSizeConstraint: NSLayoutConstraint!
  @IBOutlet weak var lowerContainerHeightConstraint: NSLayoutConstraint!
  
  // MARK: - Configuration
  func setupView(backgroundColor: UIColor, textColor: UIColor, logoUrl: String, imageStorage: ImageStorage) {
    self.imageStorage = imageStorage
    self.backgroundColor = .clear
    upperLabel.textColor = textColor
    lowerLabel.textColor = textColor
    configureLogo(backgroundColor: backgroundColor, logoUrl: logoUrl)
  }
  
  private func configureLogo(backgroundColor: UIColor, logoUrl: String) {
    logoContainer.layer.cornerRadius = Const.logoCornerRadius
    logoContainer.backgroundColor = backgroundColor
    logoContainer.clipsToBounds = true
    logoImage.image = imageStorage?.defaultLogoImage()
    imageStorage?.getImage(forUrl: logoUrl) { self.realLogoImage = $0 }
    logoImage.layer.cornerRadius = Const.logoCornerRadius/2
    logoImage.backgroundColor = backgroundColor
    logoImage.clipsToBounds = true
  }
  
  func setupCloseButton(viewModel: CloseButtonViewModel) {
    setCloseButton(tintColor: viewModel.color)
    setCloseButton(hidden: viewModel.hidden)
  }
  
  private func setCloseButton(tintColor: UIColor) {
    let image = closeButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
    closeButton.tintColor = tintColor
    closeButton.setImage(image, for: .normal)
  }
  
  private func setCloseButton(hidden: Bool) {
    closeButton.isHidden = hidden
    closeButton.alpha = hidden ? 0 : 1
  }
  
  func displayQuestion(with model: CopyViewModel, duration: TimeInterval) -> Animatable {
    let description = model.description ?? ""
    switch model.descriptionPlacement {
    case .none: return applyTitleOnlyState(title: model.title, duration: duration)
    case .after: return applyTitleLeadingState(title: model.title, description: description, duration: duration)
    case .before: return applyDescriptionLeadingState(title: model.title, description: description, duration: duration)
    }
  }
  
  func displayMessage(message: String, duration: TimeInterval, isFullscreen: Bool) -> Animatable {
    let changeUpperText = changeUpperTextToMessageAnimation(message, duration: duration)
    let hideLowerText = hideLowerTextAnimation(duration: duration)
    let changeLogoToReal = changeLogoToRealAnimation(duration: duration)
    let showCloseButton = showCloseButtonAnimation(duration: duration)
    var animation = Animation.group([changeUpperText, hideLowerText, changeLogoToReal, showCloseButton])
    if !isFullscreen {
      animation = animation.group(moveLogoToCenterAnimation(duration: duration))
    }
    return animation
  }
  
  func displayLeadGenForm(title: String, duration: TimeInterval) -> Animatable {
    return applyTitleOnlyState(title: title, duration: duration)
  }
  
  // MARK: - Animations
  private func applyTitleOnlyState(title: String, duration: TimeInterval) -> Animatable {
    let changeUpperText = changeUpperTextToTitleAnimation(title, duration: duration)
    let hideLowerText = hideLowerTextAnimation(duration: duration)
    let changeToQuestion = changeToQuestionAnimation(duration: duration)
    return Animation.group([changeUpperText, hideLowerText, changeToQuestion])
  }
  
  private func applyTitleLeadingState(title: String, description: String, duration: TimeInterval) -> Animatable {
    let changeUpperText = changeUpperTextToTitleAnimation(title, duration: duration)
    let changeLowerText = changeLowerTextToDescriptionAnimation(description, duration: duration)
    let changeToQuestion = changeToQuestionAnimation(duration: duration)
    return Animation.group([changeUpperText, changeLowerText, changeToQuestion])
  }
  
  private func applyDescriptionLeadingState(title: String, description: String, duration: TimeInterval) -> Animatable {
    let changeUpperText = changeUpperTextToDescriptionAnimation(description, duration: duration)
    let changeLowerText = changeLowerTextToTitleAnimation(title, duration: duration)
    let changeToQuestion = changeToQuestionAnimation(duration: duration)
    return Animation.group([changeUpperText, changeLowerText, changeToQuestion])
  }

  private func changeToQuestionAnimation(duration: TimeInterval) -> Animatable {
    let moveLogoToLeft = moveLogoToLeftAnimation(duration: duration)
    let changeLogoToReal = changeLogoToRealAnimation(duration: duration)
    return Animation.group([moveLogoToLeft, changeLogoToReal])
  }
  
  private func changeLogoToRealAnimation(duration: TimeInterval) -> Animatable {
    guard let realLogo = self.realLogoImage else {
      return Animation(duration: duration) {}
    }
    self.realLogoImage = nil
    let hideLogoAnimation = Animation(duration: duration/2) {
      self.logoImage.alpha = 0
    }
    let showNewLogoAnimation = Animation(duration: duration/2) {
      self.logoImage.image = realLogo
      self.logoImage.alpha = 1
    }
    return hideLogoAnimation.then(showNewLogoAnimation)
  }
  private func moveLogoToLeftAnimation(duration: TimeInterval) -> Animatable {
    return Animation(duration: duration) {
      self.moveLogoToLeft()
      self.superview?.superview?.layoutIfNeeded()
    }
  }
  
  private func moveLogoToCenterAnimation(duration: TimeInterval) -> Animatable {
    return Animation(duration: duration) {
      self.moveLogoToCenter()
      self.superview?.superview?.layoutIfNeeded()
    }
  }
  
  private func changeUpperTextToTitleAnimation(_ title: String, duration: TimeInterval) -> Animatable {
    return changeUpperTextAnimation(title, font: Const.questionTitleFont, duration: duration)
  }
  
  private func changeUpperTextToDescriptionAnimation(_ description: String, duration: TimeInterval) -> Animatable {
    return changeUpperTextAnimation(description, font: Const.questionDescriptionFont, duration: duration)
  }
  
  private func changeUpperTextToMessageAnimation(_ message: String, duration: TimeInterval) -> Animatable {
    return changeUpperTextAnimation(message, font: Const.messageFont, duration: duration)
  }
  
  private func changeUpperTextAnimation(_ text: String, font: UIFont, duration: TimeInterval) -> Animatable {
    let hideTextAniamtion = Animation(duration: duration/2) {
      self.upperLabel.alpha = 0
    }
    let showNewTextAnimation = Animation(duration: duration/2) {
      self.upperLabel.font = font
      self.upperLabel.text = text
      self.upperLabel.alpha = 1
    }
    return hideTextAniamtion.then(showNewTextAnimation)
  }
  
  private func changeLowerTextToTitleAnimation(_ title: String, duration: TimeInterval) -> Animatable {
    return changeLowerTextAnimation(title, font: Const.questionTitleFont, duration: duration)
  }
  
  private func changeLowerTextToDescriptionAnimation(_ description: String, duration: TimeInterval) -> Animatable {
    return changeLowerTextAnimation(description, font: Const.questionDescriptionFont, duration: duration)
  }
  
  private func changeLowerTextAnimation(_ text: String, font: UIFont, duration: TimeInterval) -> Animatable {
    let prepareContainer = Animation(duration: duration/2) {
      self.lowerContainerHeightConstraint.priority = UILayoutPriority.defaultLow
      self.lowerLabel.alpha = 0
      self.lowerLabel.text = text
      self.lowerLabel.font = font
      self.superview?.superview?.layoutIfNeeded()
    }
    let showNewText = Animation(duration: duration/2) {
      self.lowerLabel.alpha = 1
    }
    return prepareContainer.then(showNewText)
  }
  
  private func hideLowerTextAnimation(duration: TimeInterval) -> Animatable {
    let hideCurrentText = Animation(duration: duration/2) {
      self.lowerLabel.alpha = 0
    }
    let collapseContainer = Animation(duration: duration/2) {
      self.lowerContainerHeightConstraint.priority = UILayoutPriorityVeryHigh
      self.superview?.superview?.layoutIfNeeded()
    }
    let resetState = Animation(duration: 0) {
       self.lowerLabel.text = ""
    }
    return hideCurrentText.then(collapseContainer).then(resetState)
  }
  
  private func showCloseButtonAnimation(duration: TimeInterval) -> Animatable {
    return Animation(duration: duration) {
      self.closeButton.isHidden = false
      self.closeButton.alpha = 1
    }
  }
  
  private func moveLogoToCenter() {
    logoToTextConstraint.priority = .defaultLow
    logoVerticalCenterConstraint.priority = .defaultLow
    edgeToLogoConstraint.priority = .defaultLow
    logoHorizontalCenterConstraint.priority = UILayoutPriorityVeryHigh
    logoToTextVerticalConstraint.priority = UILayoutPriorityVeryHigh
    edgeToTextConstraint.priority = UILayoutPriorityVeryHigh
    logoContainerSizeConstraint.constant = Const.logoContainerExtendedSize
    textMarginConstraint.constant = Const.logoContainerExtendedSize/2
    upperLabel.textAlignment = .center
  }
  
  private func moveLogoToLeft() {
    logoToTextConstraint.priority = UILayoutPriorityVeryHigh
    logoVerticalCenterConstraint.priority = UILayoutPriorityVeryHigh
    edgeToLogoConstraint.priority = UILayoutPriorityVeryHigh
    logoHorizontalCenterConstraint.priority = .defaultLow
    logoToTextVerticalConstraint.priority = .defaultLow
    edgeToTextConstraint.priority = .defaultLow
    logoContainerSizeConstraint.constant = Const.logoContainerDefaultSize
    textMarginConstraint.constant = Const.textToLogoDistance
    upperLabel.textAlignment = .left
  }
  
  // MARK: - User Actions
  @IBAction func closeButtonPressed(_ sender: UIButton) {
    delegate?.closeButtonPressed()
  }
}
