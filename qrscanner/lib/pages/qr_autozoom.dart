import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pytorch_lite/pigeon.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:qrscanner/controller/camera_view_controller.dart';
import 'package:qrscanner/controller/yolo_controller.dart';
import 'package:qrscanner/pages/bounding_box.dart';
import 'package:qrscanner/pages/camera_view.dart';

class QRAutozoom extends StatelessWidget {
  final YOLOController yoloController = Get.put(YOLOController());
  final CameraViewController controller = Get.put(CameraViewController());

  QRAutozoom({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Autozoom'),
        actions: [
          Obx(() => Text(
                "Time : ${yoloController.objectDetectionInferenceTime.value.inMilliseconds} ms",
                style: const TextStyle(fontSize: 16),
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Obx(() => Stack(children: [
            Column(
              children: [
                const CameraView(),
                Obx(
                  () => Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Zoom Level : ${controller.zoomLevel.value.toStringAsFixed(3)}",
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            "MAX Zoom : ${controller.maxZoomLevel.value}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                controller.isTakingPicture.value = true;
                                await controller.takePicture();
                                controller.isTakingPicture.value = false;
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    radius: 40,
                                    child: controller.isTakingPicture.value
                                        ? const CircularProgressIndicator()
                                        : const Icon(
                                            Icons.camera_alt_rounded,
                                            size: 52,
                                          ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(controller.isTakingPicture.value
                                      ? "Please wait..."
                                      : "Take a Picture")
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                controller.zoomLevel.value = 1;
                                await controller.cameraController
                                    ?.setZoomLevel(1);
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    radius: 40,
                                    child: const Icon(
                                      Icons.zoom_out,
                                      size: 52,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  const Text("Reset Zoom")
                                ],
                              ),
                            ),
                          ],
                        ),
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

  // add bouding boxes around QR code
  Widget boundingBoxes2(List<ResultObjectDetection>? results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results.map((e) => BoundingBox(result: e)).toList(),
    );
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   switch (state) {
  //     case AppLifecycleState.paused:
  //       controller.cameraController?.stopImageStream();
  //       break;
  //     case AppLifecycleState.resumed:
  //       if (!controller.cameraController!.value.isStreamingImages) {
  //         await controller.cameraController?.startImageStream(
  //             (CameraImage image) => yoloController.onEachCameraImage(image,
  //                 controller.camFrameRotation, controller.setCameraZoomLevel));
  //       }
  //       break;
  //     default:
  //   }
  // }
}
