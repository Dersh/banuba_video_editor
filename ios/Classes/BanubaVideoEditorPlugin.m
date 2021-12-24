#import "BanubaVideoEditorPlugin.h"
#if __has_include(<banuba_video_editor/banuba_video_editor-Swift.h>)
#import <banuba_video_editor/banuba_video_editor-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "banuba_video_editor-Swift.h"
#endif

@implementation BanubaVideoEditorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBanubaVideoEditorPlugin registerWithRegistrar:registrar];
}
@end
