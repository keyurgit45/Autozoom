import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class PatternController extends GetxController
    with GetTickerProviderStateMixin {
  final _animation = Rxn<Animation<double>>();
  Animation<double>? get animation => _animation.value;

  final _controller = Rxn<AnimationController>();
  AnimationController? get controller => _controller.value;

  @override
  void onInit() {
    super.onInit();
    _controller.value =
        AnimationController(duration: const Duration(seconds: 4), vsync: this)
          ..repeat(reverse: false);

    _animation.value =
        (Tween<double>(begin: -400, end: 0).animate(_controller.value!))
          ..addListener(() {
            update();
          });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.value?.dispose();
  }
}
