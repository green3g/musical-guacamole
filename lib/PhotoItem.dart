
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoItem extends StatefulWidget {
  final FileSystemEntity file;

  const PhotoItem({
    Key key,
    @required this.file,
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PhotoItemState();
  }
}


class _PhotoItemState extends State<PhotoItem> {
  bool selected = false;

  void toggle(){
    setState((){
      selected = !selected;
    });
  }

  List<Widget> getChildren(FileSystemEntity file){
    final List<Widget> children = [];
    children.add(Image.file(file));
    if(selected){
      children.add(
        Center(child: Icon(Icons.check_circle)),
      );
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Stack(
          children: getChildren(widget.file),
        ),
      ),
      onTap: () => toggle(),
    );
  }

}
