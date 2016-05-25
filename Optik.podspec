#
# Be sure to run `pod lib lint Optik.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Optik"
  s.version          = "0.1.0"
  s.summary          = "A Swift library for displaying images from any source, local or remote."
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = "https://github.com/prolificinteractive/Optik"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "htinlinn" => "linn@prolificinteractive.com" }
  s.source           = { :git => "https://github.com/prolificinteractive/Optik.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Optik/Classes/**/*'
  s.resources = ['Optik/Assets/*.xcassets']
end
