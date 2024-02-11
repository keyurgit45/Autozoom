import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/navigation/app_pages.dart';
import 'package:qrscanner/navigation/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        initialRoute: AppRoutes.homepage,
        getPages: AppPages.pages);
  }
}
