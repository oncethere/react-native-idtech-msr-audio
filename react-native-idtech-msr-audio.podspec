require 'json'

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = package["name"]
  s.version      = package["version"]
  s.summary      = package["description"]
  s.license      = package["license"]
  s.authors      = package["author"]
  s.homepage     = package["homepage"]
  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/oncethere/react-native-idtech-msr-audio.git", :tag => "v#{s.version}" }

  s.source_files = "ios/**/*.{h,m}"
  s.dependency   "React"
  s.frameworks   = "AudioToolbox", "AVFoundation", "MediaPlayer"
  s.xcconfig     = {
    "LIBRARY_SEARCH_PATHS" => "\"$(PROJECT_DIR)/../node_modules/#{s.name}/ios/uniMag-SDK\""
  }

  s.vendored_libraries = 'ios/uniMag-SDK/libIDTECH_UniMag.a'
  s.libraries = 'IDTECH_UniMag'
end
