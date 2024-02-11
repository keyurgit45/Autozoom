import 'package:get/get.dart';
import 'package:qrscanner/navigation/app_routes.dart';
import 'package:qrscanner/pages/home_page.dart';
import 'package:qrscanner/pages/qr_autozoom.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.homepage, page: () => HomePage()),
    GetPage(
        name: AppRoutes.qrautozoom,
        page: () => QRAutozoom(
              model: Get.arguments["model"],
              label: Get.arguments["label"],
              imgz: Get.arguments["imgz"],
              numberOfClasses: Get.arguments["numberOfClasses"],
            ),
        transition: Transition.cupertino)
  ];
}
