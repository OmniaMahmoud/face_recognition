import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import 'camera_utils.dart';
import 'package:image/image.dart';

class ImageUtils {

  static final ImageUtils _imageUtils = ImageUtils._internal();

  factory ImageUtils() {
    return _imageUtils;
  }

  ImageUtils._internal();

  Uint8List convertImageToBytes(CameraImage image){
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    Uint8List bytes = allBytes.done().buffer.asUint8List();
    return bytes;
  }

  InputImage convertImageToInputImage(CameraImage image){
    final bytes = convertImageToBytes(image);

    Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    InputImageRotation imageRotation = InputImageRotation.Rotation_0deg;
    if(CameraUtils().cameraController != null){
      imageRotation =
          InputImageRotationMethods.fromRawValue(CameraUtils().cameraController!.description.sensorOrientation) ??
              InputImageRotation.Rotation_0deg;
    }

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

    return InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
  }

  Image? cropFace(CameraImage image, Face face){
    // create an img.Image from your original image file for processing
    Image? originalImage = decodeImage(convertImageToBytes(image));
    // now crop out only the detected face boundry, below will crop out the first face from the list
    if(originalImage != null){
      Image croppedFace = copyCrop(
        originalImage,
        face.boundingBox.left.toInt(),
        face.boundingBox.top.toInt(),
        face.boundingBox.width.toInt(),
        face.boundingBox.height.toInt(),
      );
      return croppedFace;
    }
    return null;
  }

}