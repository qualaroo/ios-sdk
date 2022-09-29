//
//  SurveyView.swift
//  Qualaroo
//
//  Copyright (c) 2018, Qualaroo, Inc. All Rights Reserved.
//
//  Please refer to the LICENSE.md file for the terms and conditions
//  under which redistribution and use of this file is permitted.
//

import UIKit

let kAnimationTime = 0.4

class SurveyView: UIViewController {
  
  struct BodyViewModel {
    let backgroundColor: UIColor
    let dimStyle: UIBlurEffect.Style
    let dimAlpha: CGFloat
    let fullscreen: Bool
  }
  
  struct ProgressViewModel {
    let trackColor: UIColor
    let progressColor: UIColor
    let location: Theme.ProgressBarLocation
  }
  
  
  
  struct Const {
    static let buttonsCornerRadius: CGFloat = 10
    static let buttonsHeight: CGFloat = 44
    static let edgeMargin: CGFloat = 20
  }
  
  private var bodyViewModel: BodyViewModel!
  private var presenter: SurveyViewDelegate!
  private var imageStorage: ImageStorage!
  
  // MARK: - Outlets
  @IBOutlet weak var dimView: UIVisualEffectView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var header: SurveyHeaderView!
  @IBOutlet weak var bodyContainerView: UIView!
  @IBOutlet weak var bodyContainerHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var footer: SurveyButtonsView!
  @IBOutlet weak var containerCenterConstraint: NSLayoutConstraint!
  @IBOutlet weak var containerBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var dimRecognizer: UITapGestureRecognizer!
  @IBOutlet weak var topProgressBar: UIProgressView!
  @IBOutlet weak var topProgressHeight: NSLayoutConstraint!
  @IBOutlet weak var bottomProgressBar: UIProgressView!
  @IBOutlet weak var bottomProgressBarHeight: NSLayoutConstraint!
  
  @IBOutlet weak var topProgressBarLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var topProgressBarTrailingConstraint: NSLayoutConstraint!
  @IBOutlet weak var topProgressBarLeadingFullscreenConstraint: NSLayoutConstraint!
  @IBOutlet weak var topProgressBarTrailingFullscreenConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomProgressBarLeadingFullscreenConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomProgressBarLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomProgressBarTrailingConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomProgressBarTrailingFullscreenConstraint: NSLayoutConstraint!
  @IBOutlet weak var topProgressBarBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var topProgressBarTopConstraint: NSLayoutConstraint!
  
  weak var embeddedBody: UIView?
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    passDelegate()
    presenter.viewLoaded(self)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    presenter.viewDisplayed(self)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    adjustWidth()
    adjustCorners()
  }
  
  func attach(presenter: SurveyPresenter,
              imageStorage: ImageStorage) {
    self.presenter = presenter
    self.imageStorage = imageStorage
  }
  
  private func passDelegate() {
      print("footer is nil? = \(footer == nil)")
      print("\(footer == nil)")
      print("\(footer.delegate == nil)")
      print("\(presenter == nil)")
    footer.delegate = presenter
    header.delegate = presenter
  }
  
  @IBAction func backgroundDimTapped(_ sender: UITapGestureRecognizer) {
    presenter.backgroundDimTapped()
  }
}

// MARK: - SurveyView Position & Styles
extension SurveyView {
  private func coverWholeScreen() {
    moveToCenter()
    disableDimView(withColor: bodyViewModel.backgroundColor)
  }
  private func coverWithDimView() {
    moveToBottom()
    enableDimView()
  }
  private func enableDimView() {
    dimView.backgroundColor = .clear
    dimView.effect = UIBlurEffect(style: bodyViewModel.dimStyle)
    dimView.alpha = 0
    dimRecognizer.isEnabled = true
    
  }
  private func disableDimView(withColor color: UIColor) {
    dimView.backgroundColor = color
    dimView.effect = nil
    dimView.alpha = 1
    dimRecognizer.isEnabled = false
  }
  private func moveToCenter() {
    containerCenterConstraint.priority = UILayoutPriorityVeryHigh
    containerBottomConstraint.priority = .defaultLow
  }
  private func moveToBottom() {
    containerCenterConstraint.priority = .defaultLow
    containerBottomConstraint.priority = UILayoutPriorityVeryHigh
  }
  private func adjustWidth() {
    guard let keyWindow = UIApplication.shared.keyWindow else { return }
    containerWidthConstraint.constant = min(keyWindow.bounds.height, keyWindow.bounds.width) * Orientation.scale()
  }
  private func adjustCorners() {
    containerView.layer.cornerRadius = 0.0
  }
}

// MARK: - Animations
extension SurveyView {
  private func replaceEmbeddedView(with newEmbeddedView: UIView,
                                   duration: TimeInterval) -> Animatable {
    view.endEditing(true)
    let replace = Animation(duration: 0) {
      newEmbeddedView.frame = self.bodyContainerView.bounds
      self.embeddedBody?.removeFromSuperview()
      self.bodyContainerView.addSubview(newEmbeddedView)
      newEmbeddedView.layoutIfNeeded()
      self.embeddedBody = newEmbeddedView
    }
    let fill = Animation(duration: duration) {
      NSLayoutConstraint.fillView(self.bodyContainerView, with: newEmbeddedView)
      self.view.layoutIfNeeded()
    }
    return Animation.group([replace, fill])
  }
  private func hideCurrentViewAnimation(withDuration duration: TimeInterval) -> Animatable {
    let hide = Animation(duration: duration*0.5) {
      self.embeddedBody?.alpha = 0
      self.bodyContainerHeightConstraint.constant = self.bodyContainerView.bounds.size.height
      self.bodyContainerHeightConstraint.priority = UILayoutPriorityVeryHigh
      self.bodyContainerHeightConstraint.constant = 0
      self.bodyContainerHeightConstraint.priority = UILayoutPriorityVeryHigh
      self.view.layoutIfNeeded()
    }
    let remove = Animation(duration: 0) {
      self.embeddedBody?.removeFromSuperview()
    }
    return hide.wait(duration*0.5).then(remove)
  }
}

// MARK: - SurveyViewInterface
extension SurveyView: SurveyViewInterface {
    
  func setup(backgroundColor: UIColor,
             textColor: UIColor,
             buttonViewModel: SurveyButtonsView.ViewModel,
             logoUrl: String,
             closeButtonViewModel: SurveyHeaderView.CloseButtonViewModel,
             surveyBodyViewModel: BodyViewModel,
             progressViewModel: ProgressViewModel) {
    header.setupView(backgroundColor: backgroundColor,
                     textColor: textColor,
                     logoUrl: logoUrl,
                     imageStorage: imageStorage)
    header.setupCloseButton(viewModel: closeButtonViewModel)
    footer.setup(viewModel: buttonViewModel)
    setupBody(viewModel: surveyBodyViewModel)
    setupProgressBars(progressViewModel, isFullscreen: surveyBodyViewModel.fullscreen)
  }
  private func setupBody(viewModel: BodyViewModel) {
    bodyViewModel = viewModel
    if viewModel.fullscreen {
      coverWholeScreen()
    } else {
      coverWithDimView()
    }
    containerView.backgroundColor = viewModel.backgroundColor
  }
  
  private func setupProgressBars(_ viewModel: ProgressViewModel, isFullscreen: Bool) {
    switch viewModel.location {
    case .top:
      setTopProgressBar(visible: true)
      setBottomProgressBar(visible: false)
    case .bottom:
      setTopProgressBar(visible: false)
      setBottomProgressBar(visible: true)
    case .none:
      setTopProgressBar(visible: false)
      setBottomProgressBar(visible: false)
    }
    let fullscreenConstraints = [
      topProgressBarLeadingFullscreenConstraint,
      topProgressBarTrailingFullscreenConstraint,
      bottomProgressBarLeadingFullscreenConstraint,
      bottomProgressBarTrailingFullscreenConstraint,
      topProgressBarTopConstraint
    ]
    let nonFullscreenConstraints = [
      topProgressBarLeadingConstraint,
      topProgressBarTrailingConstraint,
      bottomProgressBarLeadingConstraint,
      bottomProgressBarTrailingConstraint,
      topProgressBarBottomConstraint
    ]
    fullscreenConstraints.forEach { $0?.isActive = isFullscreen }
    nonFullscreenConstraints.forEach { $0?.isActive = !isFullscreen }
    [topProgressBar, bottomProgressBar].forEach {
      $0?.trackTintColor = viewModel.trackColor
      $0?.progressTintColor = viewModel.progressColor
    }
  }
  
  private func setTopProgressBar(visible: Bool) {
    topProgressHeight.constant = visible ? 6 : 0
    topProgressBar.isHidden = !visible
  }
  
  private func setBottomProgressBar(visible: Bool) {
    bottomProgressBarHeight.constant = visible ? 6 : 0
    bottomProgressBar.isHidden = !visible
  }
  
  func displayMessage(withText text: String,
                      buttonModel: SurveyButtonsView.ButtonViewModel,
                      fullscreen: Bool) {
    header.displayMessage(message: text, duration: kAnimationTime, isFullscreen: fullscreen).run()
    hideCurrentViewAnimation(withDuration: kAnimationTime).run()
    footer.configureButton(with: buttonModel, duration: kAnimationTime).run()
  }
  func displayQuestion(viewModel: SurveyHeaderView.CopyViewModel,
                       answerView: UIView,
                       buttonModel: SurveyButtonsView.ButtonViewModel) {
    header.displayQuestion(with: viewModel, duration: kAnimationTime).run()
    replaceEmbeddedView(with: answerView, duration: kAnimationTime).run()
    footer.configureButton(with: buttonModel, duration: kAnimationTime).run()
  }
  func displayLeadGenForm(with text: String,
                          fontStyleTitle:String,
                          leadGenView: LeadGenFormView,
                          buttonModel: SurveyButtonsView.ButtonViewModel) {
      header.displayLeadGenForm(title: text, duration: kAnimationTime,fontStyleTitle: fontStyleTitle).run()
    replaceEmbeddedView(with: leadGenView, duration: kAnimationTime).run()
    footer.configureButton(with: buttonModel, duration: kAnimationTime).run()
  }
  
  func focusOnInput() {
    if let embeddedView = embeddedBody as? FocusableAnswerView {
      embeddedView.getFocus()
    }
  }
  
  func enableNextButton() {
    footer.nextButton.isEnabled = true
  }
  
  func disableNextButton() {
    footer.nextButton.isEnabled = false
  }
  
  func closeSurvey(withDim dimming: Bool) {
    view.isUserInteractionEnabled = false
    view.endEditing(true)
    if dimming {
      UIView.animate(withDuration: kAnimationTime, animations: {
        self.dimView.alpha = 0
      }, completion: { _ in
        self.dismiss(animated: true, completion: nil)
      })
    } else {
      self.dismiss(animated: true, completion: nil)
    }
  }
  
  func keyboardChangedSize(height: CGFloat, animationTime: TimeInterval) {
    Animation(duration: animationTime) {
      self.containerBottomConstraint.constant = height
      self.containerCenterConstraint.constant = -height/2
      self.view.layoutIfNeeded()
      }.run()
  }
  
  func dimBackground() {
    Animation(duration: kAnimationTime) {
      self.dimView.alpha = self.bodyViewModel.dimAlpha
      }.run()
  }
    
  func setProgress(progress: Float) {
    [topProgressBar, bottomProgressBar].forEach {
      $0?.setProgress(progress, animated: true)
    }
  }
}
