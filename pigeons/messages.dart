import 'package:pigeon/pigeon.dart';

class VideoEditResult {
  String? filepath;
}

@HostApi()
abstract class BanubaVideoEditorApi {
  @async
  VideoEditResult startEditorFromCamera();
}
