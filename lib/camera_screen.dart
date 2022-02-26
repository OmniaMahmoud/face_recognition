import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {

  @override
  _CameraScreenState createState() {
    // TODO: implement createState
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> {

  List<CameraDescription>? mobileAvailableCameras;
  CameraController? cameraController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      mobileAvailableCameras = await availableCameras();
      for(CameraDescription camera in mobileAvailableCameras ?? []){
        print(camera.name);
      }
      cameraController = CameraController(
          const CameraDescription(
              name: '1',
              sensorOrientation: 0,
              lensDirection: CameraLensDirection.front
          ), ResolutionPreset.max,
          enableAudio: false
      );
      await cameraController?.initialize();
      if(!mounted){
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cameraController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ((cameraController?.value.isInitialized ?? false) && cameraController != null)?
    Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: CameraPreview(
            cameraController!,
            child: Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: ElevatedButton(
                  onPressed: (){},
                  child: Text('Done'),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.lightGreen),
                      textStyle: MaterialStateProperty.all(
                          TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          )
                      )
                  )),
            ),
          ),
        ),

      ),
    ): Container();
  }
}