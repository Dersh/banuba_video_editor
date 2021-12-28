import 'dart:async';

import 'banuba_video_editor_api.dart';

class BanubaVideoEditor {
  static late final BanubaVideoEditorApi _api = BanubaVideoEditorApi();
  static Future<VideoEditResult> startEditorFromCamera() =>
      _api.startEditorFromCamera();
}
