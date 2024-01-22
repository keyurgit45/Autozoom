import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/pages/home_page.dart';
import 'package:qrscanner/pages/qr_autozoom.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(
            name: '/qrautozoom',
            page: () => QRAutozoom(),
            transition: Transition.cupertino)
      ],
    );
  }
}
