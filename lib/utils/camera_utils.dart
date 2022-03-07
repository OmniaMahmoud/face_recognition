import 'package:camera/camera.dart';

class CameraUtils {

  static final CameraUtils _cameraUtils = CameraUtils._internal();

  factory CameraUtils() {
    return _cameraUtils;
  }

  CameraUtils._internal();

  List<CameraDescription> _mobileAvailableCameras = [];
  CameraController? _cameraController;


  Future<void> initializeCamera() async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
    }
    _mobileAvailableCameras = await availableCameras();
    _cameraController = CameraController(
    _mobileAvailableCameras[1], ResolutionPreset.max,
    enableAudio: false
    );
    await _cameraController?.initialize();
  }

  CameraController? get cameraController => _cameraController;
  List<CameraDescription>? get mobileAvailableCameras => _mobileAvailableCameras;

  bool isCameraInitialized(){
    return _cameraController != null && (_cameraController?.value.isInitialized ?? false);
  }

  void dispose() {
    // TODO: implement dispose
    _cameraController?.dispose();
  }
}