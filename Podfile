platform :ios, '13.0'
inhibit_all_warnings!

install! 'cocoapods', :warn_for_unused_master_specs_repo => false

target 'Biamp' do
  use_frameworks!
  
  #Common
  pod 'R.swift'
  pod 'SwiftLint'
  pod 'SegueManager/R.swift'
  pod "SimpleKeychain"
  
  # Reactive
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxSwiftExt'
  pod 'Action'
  pod 'RxDataSources'
  
  # UI
  pod 'PKHUD'
  
  # Network
  pod 'Moya/RxSwift'
  pod 'ObjectMapper'
  
  # Database
  pod 'RealmSwift', '10.1.4'

  target 'BiampTests' do
    use_frameworks!

    #Tests
    pod 'RxTest'
    pod 'RxBlocking'
    pod 'Nimble'

  end

end

post_install do |installer|
     installer.pods_project.targets.each do |target|
         target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.0
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
         end
     end
end
