import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:qrscanner/utils/app_logger.dart';
import 'package:image/image.dart' as img;

class YOLOController extends GetxController {
  ModelObjectDetection? _objectModel;
  var isDetecting = false.obs;
  var results = Rxn<List<ResultObjectDetection>>([]);
  var objectDetectionInferenceTime = Rx<Duration>(Duration.zero);

  @override
  Future<void> onInit() async {
    await loadModel();
    super.onInit();
  }

  Future loadModel() async {
    String pathObjectDetectionModel = "assets/bestv2.torchscript";
    try {
      _objectModel = await PytorchLite.loadObjectDetectionModel(
          pathObjectDetectionModel, 1, 224, 224,
          labelPath: "assets/labels.txt",
          objectDetectionModelType: ObjectDetectionModelType.yolov8);
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  onEachCameraImage(CameraImage cameraImage, var camFrameRotation) async {
    runObjectDetection(cameraImage, camFrameRotation);
  }

  Future<void> runObjectDetection(
      CameraImage cameraImage, var camFrameRotation) async {
    if (isDetecting.value) {
      return;
    }

    isDetecting.value = true;

    if (_objectModel != null) {
      // Start the stopwatch
      Stopwatch stopwatch = Stopwatch()..start();

      List<ResultObjectDetection> objDetect =
          await _objectModel!.getCameraImagePrediction(
        cameraImage,
        camFrameRotation,
        minimumScore: 0.5,
        iOUThreshold: 0.5,
      );

      // Stop the stopwatch
      stopwatch.stop();
      // logger.i(objDetect);
      // logger.i(stopwatch);

      results.value = objDetect;

      objectDetectionInferenceTime.value = stopwatch.elapsed;
      for (var element in results.value!) {
        print({
          "rect": {
            "left": element.rect.left,
            "top": element.rect.top,
            "width": element.rect.width,
            "height": element.rect.height,
            "right": element.rect.right,
            "bottom": element.rect.bottom,
            "time to process": stopwatch.elapsed
          },
        });
      }
    }

    isDetecting.value = false;
  }
}
