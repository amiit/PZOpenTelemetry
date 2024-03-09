#
#  Be sure to run `pod spec lint PZOpenTelemetry.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "PZOpenTelemetry"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of PZOpenTelemetry."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = "This project is to support open telemetry for cocoapod projects"

  spec.homepage     = "https://github.com/amiit/PZOpenTelemetry.git"
  spec.author             = { "Amit Tiwari" => "amiit111tiwari@gmail.com" }
  spec.source       = { :git => "git@github.com:amiit/PZOpenTelemetry.git", :tag => "#{spec.version}" }
  spec.ios.deployment_target = '13.4'


  spec.source_files = 'PZOpenTelemetry/Classes/**/*'

end
