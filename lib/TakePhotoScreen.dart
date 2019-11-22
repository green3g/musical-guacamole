import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_photo/DisplayPhotoScreen.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class TakePhotoScreen extends StatefulWidget {

  const TakePhotoScreen({
    Key key,
  }) : super(key: key);

  @override
  TakePhotoScreenState createState() => TakePhotoScreenState();
}

class TakePhotoScreenState extends State<TakePhotoScreen> {
  CameraController _controller;
  CameraDescription _camera;
  Future<void> _initializeControllerFuture;

  @override 
  void initState() {
    super.initState();

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _initCamera();
  }

  Future<void> _initCamera() async {

    final cameras = await availableCameras();
    _camera = cameras.first;


    _controller = new CameraController(

      // get a specific camera from the list of available cameras
      _camera,

      // resolution to use
      ResolutionPreset.medium,
    );

    return _controller.initialize();

  }
  

  @override 
  void dispose() {

    // dispose of the controller when widget is disposed
    _controller.dispose();
    super.dispose();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // wait until the controller is initialized before 
      // showing the preview

      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.white38,

        // when pressed callback
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final tempDir = await getTemporaryDirectory();

            // path to where photo is saved
            final path = join(
              tempDir.path,
              '${DateTime.now()}.png',
            );

            // attempt to take photo
            await _controller.takePicture(path);

            // if we make it this far, we have a photo
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPhotoScreen(imagePath: path),
              )
            );
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}