
Pod::Spec.new do |s|
  s.name             = 'SourceModel'
  s.version          = '1.3.3'
  s.summary          = 'SourceModel design pattern'

  s.description      = <<-DESC
  SourceModel is a design pattern framework that removes the boiler plate code from list view.
                       DESC

  s.homepage         = 'https://github.com/stanwood/SourceModel_iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'stanwood' => 'ios.frameworks@stanwood.io' }
  s.source           = {
      :git => 'https://github.com/stanwood/SourceModel_iOS.git', :tag => s.version.to_s }
  
  s.swift_version = '5.0'
  s.ios.deployment_target = '10.0'

  s.source_files = [
  'Sources/SourceModel/Core/**/*',
  'Sources/SourceModel/Protocols/**/*'
  ]
end
