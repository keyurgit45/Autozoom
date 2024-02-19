import 'package:get/get.dart';
import 'package:qrscanner/navigation/app_routes.dart';
import 'package:qrscanner/pages/home_page.dart';
import 'package:qrscanner/pages/object_detection.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.homepage, page: () => HomePage()),
    GetPage(
        name: AppRoutes.objectdetection,
        page: () => ObjectDetection(),
        transition: Transition.cupertino)
  ];
}
