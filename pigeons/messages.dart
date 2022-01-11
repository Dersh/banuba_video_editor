import 'package:pigeon/pigeon.dart';

class VideoEditResult {
  String? filepath;
  String? coverPath;
}

@HostApi()
abstract class BanubaVideoEditorApi {
  @async
  VideoEditResult startEditorFromCamera();
}
