import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'camera_utils.dart';
import 'image_utils.dart';

class FaceDetector {

  static final FaceDetector _detector = FaceDetector._internal();

  factory FaceDetector() {
    return _detector;
  }

  FaceDetector._internal();

  CameraUtils cameraUtils = CameraUtils();
  CameraImage? detectedImage;
  List<Face>? detectedFaces;

  Future<List<Face>> detectFaces(Function() onDetect) async {
    List<Face> faces = [];
    bool _isDetecting = false;
    CameraImage? cameraImage;
    cameraUtils.cameraController?.startImageStream((image) async {
      cameraImage = image;
      if(_isDetecting){
        return;
      }
      else {
        _isDetecting = true;

        final faceDetector = GoogleMlKit.vision.faceDetector();
        faces = await faceDetector.processImage(ImageUtils().convertImageToInputImage(image));

        print('${faces.length} omnia');
        _isDetecting = false;
        onDetect();
      }
    });

    final faceDetector = GoogleMlKit.vision.faceDetector();
    if(cameraImage != null){
      faces = await faceDetector.processImage(ImageUtils().convertImageToInputImage(cameraImage!));
    }
    detectedImage = cameraImage;
    detectedFaces = faces;
    return faces;
  }

  void stopDetection({
    required Function(CameraImage? detectedImage, List<Face>? faces) onImageCaptured
  }){
    cameraUtils.cameraController?.stopImageStream();
    onImageCaptured(detectedImage, detectedFaces);
  }
}