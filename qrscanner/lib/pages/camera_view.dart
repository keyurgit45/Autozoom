import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/controller/camera_view_controller.dart';

/// Shows camera preview
class CameraView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CameraViewController>(
      init: CameraViewController(),
      builder: (controller) {
        if (controller.cameraController == null ||
            !controller.cameraController!.value.isInitialized) {
          return Center(child: CircularProgressIndicator());
        }
        return CameraPreview(controller.cameraController!);
      },
    );
  }
}
