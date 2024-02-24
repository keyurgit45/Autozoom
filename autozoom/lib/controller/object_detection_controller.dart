import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:autozoom/enums.dart';
import 'package:autozoom/utils/app_logger.dart';
import 'package:autozoom/utils/constants.dart';
import 'package:autozoom/utils/path_utils.dart';

class ObjectDetectionController extends GetxController {
  ObjectDetector? _objectDetector;
  DetectionMode mode = DetectionMode.stream;
  var canProcess = false.obs;
  var isBusy = false.obs;

  var results = <DetectedObject>[].obs;
  var imageSize = Rx<Size>(Size.zero);
  var rotation = Rx<InputImageRotation>(InputImageRotation.rotation90deg);
  var objectDetectionInferenceTime = Rx<Duration>(Duration.zero);

  // var uniqueClasses = 0.obs;
  var selectedObject = Rxn<DetectedObject>();
  var detectionMode = Rx(Mode.Single);

  @override
  Future<void> onInit() async {
    await _initializeDetector();
    super.onInit();
  }

  @override
  void onClose() {
    canProcess.value = false;
    _objectDetector?.close();
    super.onClose();
  }

  Future<void> _initializeDetector() async {
    _objectDetector?.close();
    _objectDetector = null;
    logger.i('Set detector in mode: $mode');

    final modelPath = await getAssetPath(Consts.modelPath);
    logger.i('use custom model path: $modelPath');
    final options = LocalObjectDetectorOptions(
        mode: mode,
        modelPath: modelPath,
        classifyObjects: true,
        multipleObjects: true,
        maximumLabelsPerObject: 1,
        confidenceThreshold: 0.7);
    _objectDetector = ObjectDetector(options: options);

    canProcess.value = true;
  }

  Future<void> processImage(
      InputImage inputImage, Function setCameraZoomLevel) async {
    if (_objectDetector == null) return;
    if (!canProcess.value) return;
    if (isBusy.value) return;
    isBusy.value = true;

    Stopwatch stopwatch = Stopwatch()..start();
    final objects = await _objectDetector!.processImage(inputImage);
    stopwatch.stop();

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      // filter only those results that have non-empty labels
      results.value =
          objects.where((element) => element.labels.isNotEmpty).toList();
      imageSize.value = inputImage.metadata!.size;
      rotation.value = inputImage.metadata!.rotation;
      objectDetectionInferenceTime.value = stopwatch.elapsed;

      // Set<String> set = Set.from(
      //     results.map((element) => element.labels.first.text).toList());
      // uniqueClasses.value = set.length;

      // if there is only one objected in frame, zoom to that object
      if (results.length == 1) {
        if (detectionMode.value == Mode.Multiple) {
          selectedObject.value = null;
        }
        detectionMode.value = Mode.Single;
        selectObject(results.first);
        if (selectedObject.value != null) {
          autoZoomToObject(
              selectedObject.value!, setCameraZoomLevel, imageSize.value);
        }
      } else {
        // if there are multiple objects, let user choose the object to zoom
        if (detectionMode.value == Mode.Single) {
          selectedObject.value = null;
        }
        detectionMode.value = Mode.Multiple;
        if (selectedObject.value != null) {
          DetectedObject? obj = results
              .where((o) => o.trackingId == selectedObject.value?.trackingId)
              .firstOrNull;
          if (obj != null) {
            autoZoomToObject(obj, setCameraZoomLevel, imageSize.value);
          }
        }
      }
    }
    isBusy.value = false;
  }

  void selectObject(DetectedObject object) {
    selectedObject.value = object;
  }

  void autoZoomToObject(DetectedObject object, Function setCameraZoomLevel,
      Size imageSize) async {
    await setCameraZoomLevel(object, imageSize);
  }
}
