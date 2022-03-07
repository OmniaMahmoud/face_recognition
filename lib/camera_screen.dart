import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'widgets/face_painter.dart';

class CameraScreen extends StatefulWidget {

  @override
  _CameraScreenState createState() {
    // TODO: implement createState
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {

  List<CameraDescription> mobileAvailableCameras = [];
  CameraController? cameraController;
  Size imageSize = Size(0, 0);
  List<Face> faces = [];
  bool _isDetecting = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeCamera();

  }

  void initializeCamera(){
    Future.microtask(() async {
      if (cameraController != null) {
        await cameraController!.dispose();
      }
      mobileAvailableCameras = await availableCameras();
      for(CameraDescription camera in mobileAvailableCameras){
        print(camera.name);
      }
      cameraController = CameraController(
          mobileAvailableCameras[1], ResolutionPreset.max,
          enableAudio: false
      );
      await cameraController?.initialize();
      if(!mounted){
        return;
      }
      setState(() {});
      detectFace();
    });

  }

  void detectFace(){
      cameraController?.startImageStream((image) {
        Future.delayed(const Duration(milliseconds: 0),() async{
          if(_isDetecting){
            return;
          }
          else {
            _isDetecting = true;
            final WriteBuffer allBytes = WriteBuffer();
            for (Plane plane in image.planes) {
              allBytes.putUint8List(plane.bytes);
            }
            final bytes = allBytes.done().buffer.asUint8List();

            imageSize = Size(image.width.toDouble(), image.height.toDouble());

            final imageRotation =
                InputImageRotationMethods.fromRawValue(cameraController?.description.sensorOrientation ??
                    mobileAvailableCameras[1].sensorOrientation) ??
                    InputImageRotation.Rotation_0deg;

            final InputImageFormat inputImageFormat =
                InputImageFormatMethods.fromRawValue(image.format.raw) ??
                    InputImageFormat.NV21;

            final planeData = image.planes.map(
                  (Plane plane) {
                return InputImagePlaneMetadata(
                  bytesPerRow: plane.bytesPerRow,
                  height: plane.height,
                  width: plane.width,
                );
              },
            ).toList();

            final inputImageData = InputImageData(
              size: imageSize,
              imageRotation: imageRotation,
              inputImageFormat: inputImageFormat,
              planeData: planeData,
            );

            final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
            final faceDetector = GoogleMlKit.vision.faceDetector();
            faces = await faceDetector.processImage(inputImage);

            print('${faces.length} omnia');
            if(mounted){
              setState(() {

              });
            }
            _isDetecting = false;
          }
        });
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
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CameraPreview(
                cameraController!,
                child: Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: ElevatedButton(
                      onPressed: (){
                        cameraController?.stopImageStream();
                      },
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
            if(faces.isNotEmpty)
              CustomPaint(
                size: MediaQuery.of(context).size,
                painter:
                FacePainter(
                    imageSize: Size(
                      cameraController?.value.previewSize?.height ?? 0,
                      cameraController?.value.previewSize?.width ?? 0,
                    ),
                    face: faces.last),
              ),
          ],
        ),

      ),
    ): Container();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (cameraController == null || !(cameraController?.value.isInitialized ?? false)) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (cameraController != null) {
        initializeCamera();
      }
    }
  }
}