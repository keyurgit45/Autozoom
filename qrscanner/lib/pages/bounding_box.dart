import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

/// Individual bounding box
class BoundingBox extends StatelessWidget {
  final DetectedObject result;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection = CameraLensDirection.back;
  final bool showPercentage;
  const BoundingBox({
    Key? key,
    required this.result,
    this.showPercentage = true,
    required this.imageSize,
    required this.rotation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Positioned(
      left: translateX(result.boundingBox.left, size, imageSize, rotation,
          cameraLensDirection),
      top: translateX(result.boundingBox.top, size, imageSize, rotation,
          cameraLensDirection),
      width: translateX(result.boundingBox.width, size, imageSize, rotation,
          cameraLensDirection),
      height: translateX(result.boundingBox.height, size, imageSize, rotation,
          cameraLensDirection),
      child: Container(
        width: translateX(result.boundingBox.width, size, imageSize, rotation,
            cameraLensDirection),
        height: translateX(result.boundingBox.height, size, imageSize, rotation,
            cameraLensDirection),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF318CE7), width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        child: Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            child: Container(
              color: const Color(0xFF318CE7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    result.labels.isNotEmpty ? result.labels.first.text : "N/A",
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                      " ${result.labels.isNotEmpty ? result.labels.first.confidence.toStringAsFixed(2) : "."}",
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double translateX(
    double x,
    Size canvasSize,
    Size imageSize,
    InputImageRotation rotation,
    CameraLensDirection cameraLensDirection,
  ) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
        return x *
            canvasSize.width /
            (Platform.isIOS ? imageSize.width : imageSize.height);
      case InputImageRotation.rotation270deg:
        return canvasSize.width -
            x *
                canvasSize.width /
                (Platform.isIOS ? imageSize.width : imageSize.height);
      case InputImageRotation.rotation0deg:
      case InputImageRotation.rotation180deg:
        switch (cameraLensDirection) {
          case CameraLensDirection.back:
            return x * canvasSize.width / imageSize.width;
          default:
            return canvasSize.width - x * canvasSize.width / imageSize.width;
        }
    }
  }

  double translateY(
    double y,
    Size canvasSize,
    Size imageSize,
    InputImageRotation rotation,
    CameraLensDirection cameraLensDirection,
  ) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return y *
            canvasSize.height /
            (Platform.isIOS ? imageSize.height : imageSize.width);
      case InputImageRotation.rotation0deg:
      case InputImageRotation.rotation180deg:
        return y * canvasSize.height / imageSize.height;
    }
  }
}
