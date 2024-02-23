import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class PatternController extends GetxController
    with GetTickerProviderStateMixin {
  var animation = Rxn<Animation<double>>();
  late AnimationController controller;

  @override
  void onInit() {
    super.onInit();
    controller =
        AnimationController(duration: Duration(seconds: 4), vsync: this)
          ..repeat(reverse: false);

    animation.value = (Tween<double>(begin: -400, end: 0).animate(controller))
      ..addListener(() {
        update();
      });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
