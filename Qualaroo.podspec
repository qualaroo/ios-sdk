#
#  Be sure to run `pod spec lint QualarooSDKiOS.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "Qualaroo"
  s.version      = "1.13.1"
  s.summary      = "Qualaroo makes it easy to survey specific groups of application users to gain qualitative information."
  s.description  = <<-DESC
		     Growing your business starts by understanding what your customers and potential customers want and what’s preventing them from achieving it. Qualaroo makes it easy to uncover these critical insights with our website and mobile application survey software. Uncover visitor confusion with your product offerings, understand objections in your purchase funnel, and more.
		     Qualaroo surveys lets you target questions to users anywhere inside your application, within your product or deep in your conversion funnel. When you understand the intent of your application users and customers you can more effectively address the concerns and issues that are preventing them from achieving their goals.
		   DESC
  s.homepage     = "https://qualaroo.com"
  s.screenshots  = "https://qualaroo.com/app/themes/qualaroo/dist/images/svg/logo_c18c4539.svg"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = { :type => "BSD", :file => "LICENSE.md" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author       = { "Mihály Papp" => "mihaly@qualaroo.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = '8.0'

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/qualaroo/ios-sdk.git", :tag => s.version }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files = 'Qualaroo/**/*.{h,m,swift}'
  s.requires_arc = true
  s.resource_bundles = {
    'Qualaroo' => ['Qualaroo/Survey/QualarooStoryboard.storyboard', 'Qualaroo/QualarooImages.xcassets', 'Qualaroo/Survey/**/*.xib']
  }
  s.public_header_files = 'Qualaroo/Qualaroo.h'
  s.swift_version = '4.2'
  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.framework  = "UIKit"

end
