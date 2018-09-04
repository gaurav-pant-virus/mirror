import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class CameraWidget extends StatefulWidget {
  static CameraWidgetState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<CameraWidgetState>());

  CameraWidget({Key key}) : super(key: key);

  @override
  CameraWidgetState createState() => CameraWidgetState();

}

class CameraWidgetState extends State<CameraWidget> {
  List<CameraDescription> cameras;
  CameraController controller;
  bool isReady= false;
  int selectedCamera = 1;
  bool noCameraDevice = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    try {
      // initialize cameras.
      cameras = await availableCameras();
      // initialize camera controllers.
      controller = new CameraController(
          cameras[selectedCamera], ResolutionPreset.medium
      );
      await controller.initialize();
    } on CameraException catch (_) {
      //debugPrint("Some error occured!").
    }
    if (!mounted) return;
    setState(() {
      isReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return new Container();
    }
    return new AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: new CameraPreview(controller));
  }

  void toggleCamera(){
    setState(() {
      selectedCamera= (selectedCamera==1)? 0: 1;
      _setupCamera();
    });
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();
  void showInSnackBar(_scaffoldKey, String message) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    debugPrint('Error: ${e.code}\n${e.description}');
  }

  void clickPicture(_scaffoldKey) async {
    takePicture().then((String filePath) {
      if (mounted) {
        debugPrint("within click photo!!$filePath");
        setState(() { });
      }
      if (filePath != null) showInSnackBar(_scaffoldKey, 'Picture saved to $filePath');
    });
  }
}