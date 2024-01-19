import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pytorch_lite/pigeon.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:qrscanner/controller/camera_view_controller.dart';

/// Individual bounding box
class BoundingBox extends StatelessWidget {
  final ResultObjectDetection result;
  final Color? boxesColor;
  final bool showPercentage;
  const BoundingBox(
      {Key? key,
      required this.result,
      this.boxesColor,
      this.showPercentage = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final CameraViewController controller = Get.find<CameraViewController>();

    Color? usedColor;

    Size currSize = MediaQuery.of(context).size;
    Size screenSize = Size(currSize.width, currSize.width * (controller.ratio));

    //print(screenSize);
    double factorX = screenSize.width;
    double factorY = screenSize.height;
    if (boxesColor == null) {
      //change colors for each label
      usedColor = Colors.primaries[
          ((result.className ?? result.classIndex.toString()).length +
                  (result.className ?? result.classIndex.toString())
                      .codeUnitAt(0) +
                  result.classIndex) %
              Colors.primaries.length];
    } else {
      usedColor = boxesColor;
    }

    return Positioned(
      left: result.rect.left * factorX,
      top: result.rect.top * factorY,
      width: result.rect.width * factorX,
      height: result.rect.height * factorY,
      child: Container(
        width: result.rect.width * factorX,
        height: result.rect.height * factorY,
        decoration: BoxDecoration(
            border: Border.all(color: usedColor!, width: 3),
            borderRadius: const BorderRadius.all(Radius.circular(2))),
        child: Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            child: Container(
              color: usedColor,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(result.className ?? result.classIndex.toString()),
                  Text(" ${result.score.toStringAsFixed(2)}"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
