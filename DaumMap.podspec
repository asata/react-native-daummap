require 'json'
pjson = JSON.parse(File.read('package.json'))

Pod::Spec.new do |s|

  s.name            = "DaumMap"
  s.version         = pjson["version"]
  s.homepage        = "https://github.com/pksung1/react-native-daummap"
  s.summary         = pjson["description"]
  s.license         = pjson["license"]
  s.author          = { "JeongHun Kang" => "asata@teamsf.co.kr" }
  
  s.ios.deployment_target = '9.0'

  s.source          = { :git => "https://github.com/pksung1/react-native-daummap", :tag => "v#{s.version}" }
  s.ios.source_files = "ios/**/*.{h,m}"
  
  s.ios.framework = "SystemConfiguration", "CoreLocation", "QuartzCore", "OpenGLES"
  s.ios.library = 'xml2', 'c++', 'sqlite3'
  s.dependency 'React'
end