import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:qrscanner/controller/camera_view_controller.dart';
import 'package:qrscanner/controller/object_detection_controller.dart';
import 'package:qrscanner/pages/bounding_box.dart';
import 'package:qrscanner/pages/camera_view.dart';

class QRAutozoom extends StatelessWidget {
  QRAutozoom(
      {required this.model,
      required this.label,
      required this.imgz,
      required this.numberOfClasses});
  final String model;
  final String label;
  final int imgz;
  final int numberOfClasses;

  @override
  Widget build(BuildContext context) {
    final ObjectDetectionController objectDetectionController =
        Get.put(ObjectDetectionController());
    final CameraViewController controller = Get.put(CameraViewController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Object Detection"),
        actions: [
          Obx(() => Text(
                "Time : ${objectDetectionController.objectDetectionInferenceTime.value.inMilliseconds} ms",
                style: const TextStyle(fontSize: 16),
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Stack(children: [
        Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: AspectRatio(
                child: CameraView(),
                aspectRatio: 9.0 / 16.0,
              ),
            ),
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
                            await controller.cameraController?.setZoomLevel(1);
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
        Obx(() => boundingBoxes2(
            objectDetectionController.results.value,
            objectDetectionController.imageSize.value,
            objectDetectionController.rotation.value)),
        // Obx(() => objectDetectionController.detectedClasses.value > 1
        //     ? Positioned(
        //         top: 13,
        //         left: 20,
        //         right: 20,
        //         child: Container(
        //           height: 30,
        //           alignment: Alignment.center,
        //           decoration: const BoxDecoration(
        //               color: Colors.white,
        //               borderRadius: BorderRadius.all(Radius.circular(12))),
        //           child: Text(
        //             "Please keep only 1 object in frame",
        //             style: TextStyle(
        //                 color: Colors.grey.shade700,
        //                 fontSize: 16,
        //                 fontWeight: FontWeight.bold),
        //             textAlign: TextAlign.center,
        //           ),
        //         ),
        //       )
        //     : Container())
      ]),
    );
  }

  // add bouding boxes around QR code
  Widget boundingBoxes2(List<DetectedObject>? results, Size imageSize,
      InputImageRotation rotation) {
    if (results == null || results.isEmpty) {
      return Container();
    }
    return Stack(
      children: results
          .map((e) =>
              BoundingBox(result: e, imageSize: imageSize, rotation: rotation))
          .toList(),
    );
  }
}
