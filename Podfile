# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'NetworkModule' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NetworkModule
  pod 'PromiseKit', '~> 6.13.1'
  pod 'Alamofire', '~> 5.4.1'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
