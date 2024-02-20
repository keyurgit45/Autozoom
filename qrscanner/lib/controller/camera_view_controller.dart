import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:qrscanner/controller/object_detection_controller.dart';
import 'package:qrscanner/utils/app_logger.dart';
import 'package:qrscanner/utils/snackbar.dart';

class CameraViewController extends FullLifeCycleController
    with FullLifeCycleMixin {
  final ObjectDetectionController _controller =
      Get.find<ObjectDetectionController>();

  CameraController? cameraController;
  List<CameraDescription>? cameras;
  CameraImage? cameraImage;
  int camFrameRotation = 0;

  double ratio = 0;

  var zoomLevel = 1.0.obs;
  var maxZoomLevel = 1.0.obs;
  var isTakingPicture = false.obs;

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void onInit() {
    initializeCamera();
    super.onInit();
  }

  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras(); // check for available cameras
      if (cameras!.isNotEmpty) {
        cameraController = CameraController(
          cameras![0],
          ResolutionPreset.medium,
          enableAudio: false,
          imageFormatGroup: Platform.isAndroid
              ? ImageFormatGroup.nv21
              : ImageFormatGroup.bgra8888,
        );

        await cameraController?.initialize().then((_) async {
          maxZoomLevel.value = await cameraController!.getMaxZoomLevel();
          // Stream of image passed to [onLatestImageAvailable] callback
          await cameraController?.startImageStream((CameraImage image) async {
            InputImage? inputImage = _inputImageFromCameraImage(image);
            if (inputImage != null) {
              _controller.processImage(inputImage, setCameraZoomLevel);
            }
          });

          ratio = cameraController!.value.aspectRatio;
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

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (cameraController == null) return null;
    final camera = cameras![0];
    final sensorOrientation = camera.sensorOrientation;
    /* 
    get image rotation
    it is used in android to convert the InputImage from Dart to Java
   `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C:
    in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas:
    print( 'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    */
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[cameraController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    // validate format depending on platform. supported formats: nv21 for Android, bgra8888 for iOS

    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }

  /// takes List of predictions and increases or decreases zoom level according to width of the QR code
  void setCameraZoomLevel(
      List<DetectedObject> predictions, Size imageSize) async {
    double level = zoomLevel.value;

    if (predictions.isNotEmpty) {
      // predictions.sort((a, b) => b.labels.first.confidence.compareTo(
      //     a.labels.first.confidence)); // sort predictions according to score

      // double height = predictions.first.boundingBox.height / imageSize.width;
      double width = predictions.first.boundingBox.width / imageSize.height;

      double left = predictions.first.boundingBox.left / imageSize.height;
      double right = predictions.first.boundingBox.right / imageSize.width;
      double top = predictions.first.boundingBox.top / imageSize.height;
      double bottom = predictions.first.boundingBox.bottom / imageSize.width;
      if (width <= 0.8 &&
          left >= 0.1 &&
          right >= 0.1 &&
          top >= 0.1 &&
          bottom >= 0.1) {
        level += 0.02;
      } else if (width >= 0.9 && width < 1.5) {
        level -= 0.05;
      }
    }

    // check if zoom level is outside [1, maxZoomLevel]
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
  void onDetached() {
    logger.i('onDetached called');
  }

  @override
  void onInactive() {
    logger.i('onInative called');
  }

  @override
  void onPaused() async {
    // pause image stream
    await cameraController?.stopImageStream();
    logger.i('onPaused called');
  }

  @override
  void onResumed() async {
    logger.i('onResumed called');
    // start image stream again
    if (!cameraController!.value.isStreamingImages) {
      await cameraController?.startImageStream((CameraImage image) async {
        InputImage? inputImage = _inputImageFromCameraImage(image);
        if (inputImage != null) {
          _controller.processImage(inputImage, setCameraZoomLevel);
        }
      });
    }
  }

  @override
  void onHidden() {
    logger.i('onHidden called');
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
