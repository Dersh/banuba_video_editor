#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint banuba_video_editor.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'banuba_video_editor'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'
  s.dependency 'BanubaARCloudSDK', '1.20.0' #optional
  s.dependency 'BanubaVideoEditorSDK', '1.20.0'
  s.dependency 'BanubaAudioBrowserSDK', '1.20.0' #optional
  s.dependency 'BanubaMusicEditorSDK', '1.20.0'
  s.dependency'BanubaOverlayEditorSDK', '1.20.0'
  s.dependency 'BanubaEffectPlayer', '1.20.0' #optional
  s.dependency 'BanubaSDK', '1.20.0' #optional
  s.dependency 'BanubaSDKSimple', '1.20.0'
  s.dependency 'BanubaSDKServicing', '1.20.0'
  s.dependency 'VideoEditor', '1.20.0'
  s.dependency 'BanubaUtilities', '1.20.0'
  s.dependency 'BanubaVideoEditorGallerySDK', '1.20.0' #optional
  s.dependency 'BanubaVideoEditorEffectsSDK', '1.20.0'
  s.dependency 'BanubaLicenseServicingSDK', '1.20.0'
  s.dependency 'BanubaVideoEditorTrimSDK', '1.20.0'
  s.dependency 'BNBLicenseUtils', '1.20.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
