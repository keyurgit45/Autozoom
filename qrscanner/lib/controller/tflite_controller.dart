import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:qrscanner/utils/app_logger.dart';
import 'package:tflite_v2/tflite_v2.dart';

class TfliteController extends GetxController {
  var isWorking = false.obs;
  var result = "".obs;

  @override
  onInit() async {
    super.onInit();
    await loadModel();
  }

  loadModel() async {
    var res = await Tflite.loadModel(
        model: "assets/best_float32.tflite", labels: "assets/labels.txt");
    log(res ?? "NULL");
  }

  runModelOnStreamFrames(CameraImage cameraImage) async {
    var recognitions = await Tflite.detectObjectOnFrame(
        bytesList: cameraImage.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        threshold: 0.1,
        asynch: true);

    result.value = "";
    recognitions?.forEach((response) {
      result.value += response["label"] +
          "  " +
          (response["confidence"] as double).toStringAsFixed(2) +
          "\n\n";
    });

    logger.i(result.value);

    isWorking.value = false;
  }

  @override
  Future<void> onClose() async {
    await Tflite.close();
    super.onClose();
  }
}
