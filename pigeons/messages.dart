import 'package:pigeon/pigeon.dart';

class VideoEditResult {
  String? filePath;
  String? coverPath;
}

@HostApi()
abstract class BanubaVideoEditorApi {
  @async
  VideoEditResult startEditorFromCamera();
}
