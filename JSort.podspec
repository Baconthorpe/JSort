Pod::Spec.new do |s|
  s.name             = 'JSort'
  s.version          = '0.6'
  s.summary          = 'JSort is a simple framework for parsing JSON data in Swift.'

  s.description      = <<-DESC
JSort is a simple framework for parsing JSON data in Swift, written by Zeke Abuhoff.
                       DESC

  s.homepage         = 'https://github.com/Baconthorpe/LogCountry'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ezekiel Abuhoff' => 'zabuhoff@gmail.com' }
  s.source           = { :git => 'https://github.com/Baconthorpe/JSort.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'JSort/*.{swift,plist,h}'

end
