import 'dart:io';

import 'package:flutter/material.dart';

import 'package:banuba_video_editor/banuba_video_editor.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: TextButton(
          child: Text("Open editor"),
          onPressed: () async {
            final result = await BanubaVideoEditor.startEditorFromCamera();
            print("RESULT: ${result.filepath}");
            if (result.coverPath?.isNotEmpty ?? false) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => Image.file(File(result.coverPath!))));
            }
          },
        ),
      ),
    );
  }
}
