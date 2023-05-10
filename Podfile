platform :ios, '15.0'
inhibit_all_warnings!

install! 'cocoapods', :warn_for_unused_master_specs_repo => false

target 'ProgressApp' do
  use_frameworks!
  
  #Common
  pod 'R.swift'
  pod 'SwiftLint'
  
  # Database
  pod 'RealmSwift', '~> 10.25.0'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'

end

post_install do |installer|
     installer.pods_project.targets.each do |target|
         target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 15.0
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            end
         end
     end
end
