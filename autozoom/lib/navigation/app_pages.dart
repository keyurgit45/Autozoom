import 'package:get/get.dart';
import 'package:autozoom/navigation/app_routes.dart';
import 'package:autozoom/pages/home_page.dart';
import 'package:autozoom/pages/object_detection.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.homepage, page: () => HomePage()),
    GetPage(
        name: AppRoutes.objectdetection,
        page: () => ObjectDetection(),
        transition: Transition.cupertino)
  ];
}
