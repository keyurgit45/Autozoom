import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:qrscanner/controller/object_detection_controller.dart';
import 'package:qrscanner/utils/constants.dart';

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
    final ObjectDetectionController controller =
        Get.find<ObjectDetectionController>();
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
        child: Obx(
          () => GestureDetector(
            onTap: () => controller.selectObject(result),
            child: Container(
              width: translateX(result.boundingBox.width, size, imageSize,
                  rotation, cameraLensDirection),
              height: translateX(result.boundingBox.height, size, imageSize,
                  rotation, cameraLensDirection),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: (controller.selectedObject.value != null &&
                              controller.selectedObject.value!.trackingId ==
                                  result.trackingId)
                          ? Consts.boundingBoxSelected
                          : Consts.boundingBoxNotSelected,
                      width: 3),
                  borderRadius: const BorderRadius.all(Radius.circular(2))),
              child: Align(
                alignment: Alignment.topLeft,
                child: FittedBox(
                  child: Container(
                    color: (controller.selectedObject.value != null &&
                            controller.selectedObject.value!.trackingId ==
                                result.trackingId)
                        ? Consts.boundingBoxSelected
                        : Consts.boundingBoxNotSelected,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          result.labels.isNotEmpty
                              ? result.labels.first.text
                              : "N/A",
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                            result.labels.isNotEmpty
                                ? result.labels.first.confidence
                                    .toStringAsFixed(2)
                                : ".",
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
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
