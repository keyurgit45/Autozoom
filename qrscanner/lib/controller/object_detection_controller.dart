import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:qrscanner/utils/app_logger.dart';
import 'package:qrscanner/utils/constants.dart';
import 'package:qrscanner/utils/path_utils.dart';

class ObjectDetectionController extends GetxController {
  ObjectDetector? _objectDetector;
  DetectionMode mode = DetectionMode.stream;
  var canProcess = false.obs;
  var isBusy = false.obs;

  var results = <DetectedObject>[].obs;
  var imageSize = Rx<Size>(Size.zero);
  var rotation = Rx<InputImageRotation>(InputImageRotation.rotation90deg);
  var objectDetectionInferenceTime = Rx<Duration>(Duration.zero);

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
        maximumLabelsPerObject: 5,
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
    // print('Objects found: ${objects.length}\n\n');
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      // print(inputImage.metadata?.size);
      // print(objects.toList());

      results.value =
          objects.where((element) => element.labels.isNotEmpty).toList();
      imageSize.value = inputImage.metadata!.size;
      rotation.value = inputImage.metadata!.rotation;
      objectDetectionInferenceTime.value = stopwatch.elapsed;

      autoZoomToQR(results.value, setCameraZoomLevel, imageSize.value);
    }
    isBusy.value = false;
  }

  void autoZoomToQR(List<DetectedObject> predictions,
      Function setCameraZoomLevel, Size imageSize) async {
    await setCameraZoomLevel(predictions, imageSize);
  }
}
