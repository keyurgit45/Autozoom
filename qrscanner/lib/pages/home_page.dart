import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:qrscanner/controller/camera_view_controller.dart';
import 'package:qrscanner/controller/yolo_controller.dart';
import 'package:qrscanner/pages/bounding_box.dart';
import 'package:qrscanner/pages/camera_view.dart';

class HomePage extends StatelessWidget {
  final YOLOController yoloController = Get.put(YOLOController());
  final CameraViewController controller = Get.put(CameraViewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Detector'),
        actions: [
          Obx(() => Text(
                "${yoloController.objectDetectionInferenceTime.value.inMilliseconds} ms",
                style: TextStyle(fontSize: 16),
              )),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Obx(() => Stack(children: [
            Column(
              children: [
                CameraView(),
                Obx(
                  () => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Text("1"),
                          Expanded(
                            child: Slider(
                              min: 1.0,
                              max: controller.maxZoomLevel.value,
                              onChanged: (value) {
                                controller.cameraController
                                    ?.setZoomLevel(value);
                                controller.zoomLevel.value = value;
                              },
                              value: controller.zoomLevel.value,
                            ),
                          ),
                          Text(
                              controller.maxZoomLevel.value.toInt().toString()),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                      Text(
                        "Zoom Level : ${controller.zoomLevel.value.toStringAsFixed(3)}",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ),
              ],
            ), // Bounding boxes
            boundingBoxes2(yoloController.results.value)
          ])),
    );
  }

  Widget boundingBoxes2(List<ResultObjectDetection>? results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results.map((e) => BoundingBox(result: e)).toList(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        controller.cameraController?.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!controller.cameraController!.value.isStreamingImages) {
          await controller.cameraController?.startImageStream(
              (CameraImage image) => yoloController.onEachCameraImage(
                  image, controller.camFrameRotation, controller.setCameraZoomLevel));
        }
        break;
      default:
    }
  }
}
