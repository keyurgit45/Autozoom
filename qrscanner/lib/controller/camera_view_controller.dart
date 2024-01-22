import 'dart:io';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:qrscanner/controller/yolo_controller.dart';
import 'package:qrscanner/utils/app_logger.dart';
import 'package:qrscanner/utils/snackbar.dart';

class CameraViewController extends GetxController {
  final YOLOController _yoloController = Get.find<YOLOController>();

  CameraController? cameraController;
  List<CameraDescription>? cameras;
  CameraImage? cameraImage;
  int camFrameRotation = 0;

  double ratio = 0;

  var zoomLevel = 1.0.obs;
  var maxZoomLevel = 1.0.obs;
  var isTakingPicture = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras(); // check for available cameras
      if (cameras!.isNotEmpty) {
        cameraController = CameraController(
          cameras![0],
          ResolutionPreset.medium,
          imageFormatGroup: Platform.isAndroid
              ? ImageFormatGroup.yuv420
              : ImageFormatGroup.bgra8888,
        );

        camFrameRotation =
            Platform.isAndroid ? cameras![0].sensorOrientation : 0;

        await cameraController?.initialize().then((_) async {
          maxZoomLevel.value = await cameraController!.getMaxZoomLevel();
          // Stream of image passed to [onLatestImageAvailable] callback
          await cameraController?.startImageStream((CameraImage image) async =>
              _yoloController.onEachCameraImage(
                  image, camFrameRotation, setCameraZoomLevel));

          logger.log(level, cameraController!.value.previewSize.toString());

          ratio = cameraController!.value.aspectRatio;

          logger.log(level, ratio);
        });

        update(); // Using update() to rebuild GetBuilder widgets
      }
    } catch (e) {
      showSnackBar('Error', 'something went wrong!');
      logger.log(level, e);
    }
  }

  Future<void> takePicture() async {
    try {
      if (cameraController == null || !cameraController!.value.isInitialized) {
        showSnackBar('Error', 'select a camera first.');
        return;
      }

      if (cameraController!.value.isTakingPicture) {
        return;
      }

      // capture picture
      final XFile file = await cameraController!.takePicture();

      //save image to gallery
      await GallerySaver.saveImage(file.path).then((bool? isSaved) {
        if (isSaved ?? false) {
          showSnackBar('Success', 'Picture saved to Gallery');
        }
      });
    } on CameraException catch (e) {
      showSnackBar('Error', 'something went wrong!');
      logger.log(level, e);
      return;
    }
  }

  /// takes List of predictions and increases or decreases zoom level according to width of the QR code
  void setCameraZoomLevel(List<ResultObjectDetection> predictions) async {
    double level = zoomLevel.value;

    predictions.sort((a, b) =>
        b.score.compareTo(a.score)); // sort predictions according to score

    if (predictions.isNotEmpty) {
      if (predictions.first.rect.width <= 0.8 &&
          predictions.first.rect.left >= 0.1 &&
          predictions.first.rect.right >= 0.1 &&
          predictions.first.rect.top >= 0.1 &&
          predictions.first.rect.bottom >= 0.1) {
        if (predictions.first.rect.width > 0 &&
            predictions.first.rect.width < 0.3) {
          level += 0.3;
        } else if (predictions.first.rect.width >= 0.3 &&
            predictions.first.rect.width < 0.5) {
          level += 0.2;
        } else if (predictions.first.rect.width >= 0.5 &&
            predictions.first.rect.width < 0.7) {
          level += 0.15;
        } else if (predictions.first.rect.width >= 0.7 &&
            predictions.first.rect.width <= 0.75) {
          level += 0.1;
        }
      } else if (predictions.first.rect.width >= 0.9 &&
          predictions.first.rect.width < 1.5) {
        level -= 0.2;
      }
    }
    if (level > maxZoomLevel.value) {
      level = maxZoomLevel.value;
    } else if (level < 1) {
      level = 1;
    }
    if (zoomLevel.value != level) {
      zoomLevel.value = level;
      await cameraController?.setZoomLevel(level);
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
