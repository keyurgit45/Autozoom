import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:qrscanner/utils/app_logger.dart';
import 'package:qrscanner/utils/snackbar.dart';

class YOLOController extends GetxController {
  ModelObjectDetection? _objectModel;
  var isDetecting = false.obs;
  var results = Rxn<List<ResultObjectDetection>>([]);
  var objectDetectionInferenceTime = Rx<Duration>(Duration.zero);
  static const String _modelPath = "assets/bestv2.torchscript";
  static const String _labelPath = "assets/labels.txt";
  static const int _imgsz = 224; // image size
  static const int _numberOfClasses = 1;
  static const ObjectDetectionModelType _objectDetectionModelType =
      ObjectDetectionModelType.yolov8;

  @override
  Future<void> onInit() async {
    await loadModel();
    super.onInit();
  }

  Future loadModel() async {
    try {
      _objectModel = await PytorchLite.loadObjectDetectionModel(
          _modelPath, _numberOfClasses, _imgsz, _imgsz,
          labelPath: _labelPath,
          objectDetectionModelType: _objectDetectionModelType);
      logger.i("Model loaded");
    } catch (e) {
      if (e is PlatformException) {
        showSnackBar("Error", "Only supported for android");
      } else {
        showSnackBar("Error", "Failed to load model!");
      }
    }
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  onEachCameraImage(CameraImage cameraImage, var camFrameRotation,
      Function setCameraZoomLevel) async {
    runObjectDetection(cameraImage, camFrameRotation, setCameraZoomLevel);
  }

  Future<void> runObjectDetection(CameraImage cameraImage, var camFrameRotation,
      Function setCameraZoomLevel) async {
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
        boxesLimit: 5,
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
        logger.i({
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

      autoZoomToQR(objDetect, setCameraZoomLevel);
    }

    isDetecting.value = false;
  }

  void autoZoomToQR(List<ResultObjectDetection> predictions,
      Function setCameraZoomLevel) async {
    await setCameraZoomLevel(predictions);
  }
}
