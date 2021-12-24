flutter pub run pigeon \
  --input pigeons/messages.dart \
  --dart_out lib/banuba_video_editor_api.dart \
  --objc_header_out ios/Classes/BanubaVideoEditorPluginApi.h \
  --objc_source_out ios/Classes/BanubaVideoEditorPluginApi.m \
  --objc_prefix FLT \
  --java_out android/src/main/java/com/levl/banuba/banuba_video_editor/BanubaVideoEditorPluginApi.java \
  --java_package "com.levl.banuba.banuba_video_editor"