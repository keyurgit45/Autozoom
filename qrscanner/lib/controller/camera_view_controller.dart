import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:qrscanner/controller/yolo_controller.dart';
import 'package:qrscanner/utils/app_logger.dart';

class CameraViewController extends GetxController {
  final YOLOController _yoloController = Get.find<YOLOController>();
  CameraController? cameraController;
  List<CameraDescription>? cameras;
  CameraImage? cameraImage;
  int camFrameRotation = 0;

  double ratio = 0;

  var zoomLevel = 1.0.obs;
  var maxZoomLevel = 1.0.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    if (cameras!.isNotEmpty) {
      cameraController = CameraController(
        cameras![0],
        ResolutionPreset.medium,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
      );

      camFrameRotation = Platform.isAndroid ? cameras![0].sensorOrientation : 0;
      await cameraController?.initialize().then((_) async {
        // Stream of image passed to [onLatestImageAvailable] callback
        await cameraController?.startImageStream((CameraImage image) =>
            _yoloController.onEachCameraImage(image, camFrameRotation));

        ratio = cameraController!.value.aspectRatio;
      });
      maxZoomLevel.value = await cameraController!.getMaxZoomLevel();
      logger.i(maxZoomLevel);
      update(); // Using update() to rebuild GetBuilder widgets
    }
  }

  Future<void> takePicture() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {} catch (e) {}
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
