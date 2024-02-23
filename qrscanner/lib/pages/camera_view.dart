import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/controller/camera_view_controller.dart';
import 'package:qrscanner/utils/constants.dart';

/// Shows camera preview
class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraViewController>(
      init: CameraViewController(),
      builder: (controller) {
        if (controller.cameraController == null ||
            !controller.cameraController!.value.isInitialized) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        }
        return CameraPreview(controller.cameraController!);
      },
    );
  }
}
