# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SocialApp' do
  use_frameworks!

pod 'IQKeyboardManager'
pod 'Toast-Swift'
pod 'SwiftyJSON'
pod 'INTULocationManager'
pod 'SDWebImage'
pod 'Localize'
#pod 'NVActivityIndicatorView'
pod 'Alamofire' ,'~> 5.0'
pod 'PKHUD'
pod 'Koloda'
pod 'iOSDropDown'
pod 'CountryPickerView'
pod 'Firebase'
pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'Firebase/Storage'
pod 'Firebase/Messaging'
pod 'Firebase/Core'
pod 'SwiftyStoreKit'
pod 'GooglePlaces'
pod 'ZLSwipeableViewSwift'
pod 'UIColor+FlatColors'
pod 'Cartography'
pod 'SVGKit'
pod 'Giphy'
pod 'AgoraRtcEngine_iOS'
pod 'AuthorizeNetAccept'
pod 'ABGaugeViewKit'

  # Pods for SocialApp

end
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end
