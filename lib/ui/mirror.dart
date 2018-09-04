//import "dart:async";
import "package:flutter/material.dart";
import "../core/util.dart";

class MirrorApp extends StatefulWidget {
  @override
  _MirrorAppState createState() => _MirrorAppState();
}

class _MirrorAppState extends State<MirrorApp> {
  GlobalKey<CameraWidgetState> _cameraWidgetStateKey = new GlobalKey<CameraWidgetState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("Will show ads here"),
        backgroundColor: Colors.blue
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new CameraWidget(
              key: _cameraWidgetStateKey,
            ),
          ),
          new Row(
            children: <Widget>[
              new IconButton(
                  icon: new Icon(Icons.camera_front),
                  onPressed: () => _cameraSwitcher()
              ),
              new IconButton(
                  icon: new Icon(Icons.photo_camera),
                  onPressed: () => _photoClicked()
              ),
              new IconButton(
                  icon: new Icon(Icons.photo),
                  onPressed: () => _photoGallery()
              ),
              new IconButton(
                  icon: new Icon(Icons.share),
                  onPressed: () => _shareOnSocialMedia()
              )
            ],
          )
        ],
      ),
    );
  }

  _cameraSwitcher() {
    _cameraWidgetStateKey.currentState.toggleCamera();// = 0; //   toggleCamera();
  }

  _photoClicked() {
    debugPrint("Photo clicked!!");
    _cameraWidgetStateKey.currentState.clickPicture(_scaffoldKey);
  }

  _photoGallery() { return debugPrint("Open Photo gallery!!");}

  _shareOnSocialMedia() { return debugPrint("Share on social media");}

}

