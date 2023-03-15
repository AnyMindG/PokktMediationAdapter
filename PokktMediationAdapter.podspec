Pod::Spec.new do |s|
    s.name              = 'PokktMediationAdapter'

    s.version           = '8.2.0'

    s.summary           = 'PokktMediationAdapter'

    s.homepage          = 'https://github.com/AnyMindG/AnyManagerSDK.git'

    s.author            = { 'Name' => 'plugindev@pokkt.com' }

    s.license           = { :type => 'Apache License, Version 2.0', :text => <<-LICENSE
    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
    LICENSE
  }

    s.platform          = :ios

    s.source            = { :http => 'https://github.com/AnyMindG/AnyManagerSDK/releases/download/5000.22.0/PokktAds.zip'}

    s.source_files = 'PokktAds/*.{h,m,swift}' 
    s.vendored_frameworks = 'PokktAds/PokktSDK.xcframework'

    s.ios.deployment_target = '11.0'

    s.static_framework = true
    
    s.frameworks = "CoreData", "MediaPlayer", "Foundation", "UIKit", "CoreTelephony", "AdSupport", "CoreGraphics", "CoreMotion", "MessageUI", "EventKit", "EventKitUI", "CoreLocation", "AVFoundation", "CFNetwork", "StoreKit", "WebKit", "PassKit" , "AudioToolbox" , "CoreMedia" , "JavaScriptCore" , "CoreServices" , "SafariServices" , "Social" , "AppTrackingTransparency" , "MobileCoreServices"

    s.libraries = "xml2.2", "c++", "xml2" , "z" , "sqlite3" , "z.1.2.5"

    s.ios.framework   = 'SystemConfiguration'
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    
 

    s.dependency "Google-Mobile-Ads-SDK"
    s.dependency "PersonalizedAdConsent"
   
  
end