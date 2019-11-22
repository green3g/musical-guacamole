


import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_photo/PhotoItem.dart';
import 'package:flutter_photo/TakePhotoScreen.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {

  try {

    runApp(
      MaterialApp(
        theme: ThemeData.dark(),
        home: HomeScreen(),
      ),
    );
  } catch (e){
    print(e);
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  List<PhotoItem> photos = [];

  @override
  void initState() {
    // TODO: implement initState
    refreshFiles();
    super.initState();
  }

  void deleteSelected() async {
    List<Future> deletes = [];
    photos.forEach((photo) {
      deletes.add(photo.file.delete());
    });

    await Future.wait(deletes);
    refreshFiles();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
        actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteSelected,
          ),
        ],
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 150,
        padding: EdgeInsets.all(4),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: photos,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () {
            refreshFiles();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TakePhotoScreen())
            );
          },
        ),
    );
  }

  void refreshFiles() async {
    final directory = await getTemporaryDirectory();
    final files = await _getImages(directory);

    setState(() {
      photos = files.map((file) => PhotoItem(file: file)).toList();
    });
  }


  Future<List<FileSystemEntity>> _getImages(Directory dir) {
    final files = <FileSystemEntity>[];
    final completer = new Completer<List<FileSystemEntity>>();
    final lister = dir.list(recursive: false);

    lister.listen(
      (file) => files.add(file),
      onDone: () => completer.complete(files),
    );

    return completer.future;
  }

}

