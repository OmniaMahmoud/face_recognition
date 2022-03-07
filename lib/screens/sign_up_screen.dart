import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as imglib;

class SignUpScreen extends StatefulWidget {
  imglib.Image image;

  SignUpScreen({Key? key, required this.image}) : super(key: key);


  @override
  SignUpScreenState createState() {
    // TODO: implement createState
    return SignUpScreenState();
  }

}

class SignUpScreenState extends State<SignUpScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(

      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.file(
            File.fromRawPath(Uint8List.fromList(imglib.encodeIco(widget.image)))
        ),
      ),
    );
  }
}