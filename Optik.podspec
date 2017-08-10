Pod::Spec.new do |s|
  s.name             = "Optik"
  s.version          = "0.2.0"
  s.summary          = "A Swift library for displaying images from any source, local or remote."
  s.description      = <<-DESC
Optik provides a simple viewing experience for a set of images, whether stored locally or remotely.
                       DESC

  s.homepage         = "https://github.com/prolificinteractive/Optik"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "htinlinn" => "linn@prolificinteractive.com" }
  s.source           = { :git => "https://github.com/prolificinteractive/Optik.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Optik/Classes/**/*'
  s.resources = ['Optik/Assets/*.xcassets']
end
