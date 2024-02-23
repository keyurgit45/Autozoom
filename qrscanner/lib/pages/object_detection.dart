import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:qrscanner/controller/camera_view_controller.dart';
import 'package:qrscanner/controller/object_detection_controller.dart';
import 'package:qrscanner/pages/bounding_box.dart';
import 'package:qrscanner/pages/camera_view.dart';
import 'package:qrscanner/utils/constants.dart';

class ObjectDetection extends StatelessWidget {
  const ObjectDetection({super.key});

  @override
  Widget build(BuildContext context) {
    final ObjectDetectionController objectDetectionController =
        Get.put(ObjectDetectionController());
    final CameraViewController controller = Get.put(CameraViewController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Consts.appColor,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Object Detection",
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        actions: [
          Obx(() => Text(
                "Time : ${objectDetectionController.objectDetectionInferenceTime.value.inMilliseconds} ms",
                style:
                    GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      backgroundColor: Consts.appColor,
      body: Stack(children: [
        Column(
          children: [
            SizedBox(
              child: Stack(children: [
                CameraView(),
                Positioned(
                    right: 0.0,
                    left: 0.0,
                    bottom: 8.0,
                    child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Consts.activeTrackColor,
                          thumbColor: Consts.sliderThumbColor,
                          inactiveTrackColor: Consts.inActiveTrackColor,
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 30.0),
                        ),
                        child: Obx(() => Slider(
                              min: 1.0,
                              max: controller.maxZoomLevel.value,
                              value: controller.zoomLevel.value,
                              onChanged: (val) async {
                                controller.zoomLevel.value = val;
                                await controller.cameraController
                                    ?.setZoomLevel(val);
                              },
                            ))))
              ]),
            ),
            Obx(
              () => Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Zoom Level : ${controller.zoomLevel.value.toStringAsFixed(3)}",
                        style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: controller.zoomLevel.value ==
                                    controller.maxZoomLevel.value
                                ? Colors.red
                                : Colors.white),
                      ),
                      Text(
                        "MAX Zoom : ${controller.maxZoomLevel.value}",
                        style: GoogleFonts.montserrat(
                            fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
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
                                    : const Icon(Icons.camera_alt_rounded,
                                        size: 52, color: Consts.appColor),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Text(
                                controller.isTakingPicture.value
                                    ? "Please wait..."
                                    : "Take a Picture",
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              )
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
                                child: const Icon(Icons.zoom_out,
                                    size: 52, color: Consts.appColor),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Text(
                                "Reset Zoom",
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              )
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
        Obx(() => objectDetectionController.results.value.isNotEmpty
            ? Positioned(
                top: 13,
                left: 40,
                right: 40,
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Text(
                    objectDetectionController.selectedObject.value == null
                        ? "Select any object"
                        : "Keep the object at center",
                    style: TextStyle(
                        color: Consts.appColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Container())
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
