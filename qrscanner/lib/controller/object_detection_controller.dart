import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:qrscanner/utils/path_utils.dart';

class ObjectDetectionController extends GetxController {
  ObjectDetector? _objectDetector;
  DetectionMode mode = DetectionMode.stream;
  var canProcess = false.obs;
  var isBusy = false.obs;

  var text = "".obs;
  int option = 1;

  var results = <DetectedObject>[].obs;
  var imageSize = Rx<Size>(Size.zero);
  var rotation = Rx<InputImageRotation>(InputImageRotation.rotation0deg);
  var objectDetectionInferenceTime = Rx<Duration>(Duration.zero);

  final _options = {
    'default': '',
    'object_custom': 'object_labeler.tflite',
    'fruits': 'object_labeler_fruits.tflite',
    'flowers': 'object_labeler_flowers.tflite',

    'food': 'lite-model_aiy_vision_classifier_food_V1_1.tflite',
    // https://tfhub.dev/google/lite-model/aiy/vision/classifier/food_V1/1

    'plants': 'lite-model_aiy_vision_classifier_plants_V1_3.tflite',
    // https://tfhub.dev/google/lite-model/aiy/vision/classifier/plants_V1/3
  };

  @override
  Future<void> onInit() async {
    await _initializeDetector();
    super.onInit();
  }

  @override
  void onClose() {
    canProcess.value = false;
    _objectDetector?.close();
    super.dispose();
  }

  Future<void> _initializeDetector() async {
    _objectDetector?.close();
    _objectDetector = null;
    print('Set detector in mode: $mode');

    if (option == 0) {
      // use the default model
      print('use the default model');
      final options = ObjectDetectorOptions(
        mode: mode,
        classifyObjects: true,
        multipleObjects: true,
      );
      _objectDetector = ObjectDetector(options: options);
    } else if (option > 0 && option <= _options.length) {
      // use a custom model
      // make sure to add tflite model to assets/ml
      final _option = _options[_options.keys.toList()[option]] ?? '';
      final modelPath = await getAssetPath('assets/$_option');
      print('use custom model path: $modelPath');
      final options = LocalObjectDetectorOptions(
          mode: mode,
          modelPath: modelPath,
          classifyObjects: true,
          multipleObjects: true,
          maximumLabelsPerObject: 5,
          confidenceThreshold: 0.7);
      _objectDetector = ObjectDetector(options: options);
    }

    canProcess.value = true;
  }

  Future<void> processImage(InputImage inputImage) async {
    if (_objectDetector == null) return;
    if (!canProcess.value) return;
    if (isBusy.value) return;
    isBusy.value = true;
    text.value = '';
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
    } else {
      String _text = 'Objects found: ${objects.length}\n\n';
      for (final object in objects) {
        _text +=
            'Object:  trackingId: ${object.trackingId} - ${object.labels.map((e) => e.text)}\n\n';
      }
      text.value = _text;
      print(text);
    }
    isBusy.value = false;
  }

  void autoZoomToQR(var predictions, Function setCameraZoomLevel) async {
    await setCameraZoomLevel(predictions);
  }
}
