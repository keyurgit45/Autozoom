import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscanner/navigation/app_routes.dart';
import 'package:qrscanner/utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Camera Intelligent Autozoom',
            style: GoogleFonts.montserrat(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 4,
          backgroundColor: Consts.appColor,
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Text(
                    "Camera with intelligent autozoom in Flutter",
                    style: GoogleFonts.montserrat(
                        fontSize: 26, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    "QR Code Autozoom is a Flutter application that addresses the challenge of intelligent autozoom in the camera. Inspired by the problem statement, the app enables users to take pictures of objects, specifically focusing on scenarios like capturing images of dogs or cats. In this app, I have used a QR code detection model inspired by Google Pay's autozoom feature. The app utilizes Ultralytics YOLO v8 model to intelligently recognize QR codes, ensuring that the object in view is captured with optimal clarity.",
                    style: GoogleFonts.montserrat(fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  GestureDetector(
                      onTap: () =>
                          Get.toNamed(AppRoutes.qrautozoom, arguments: {
                            "model": Consts.modelPath1,
                            "label": Consts.modelLabels1,
                            "imgz": Consts.modelImgz1,
                            "numberOfClasses": Consts.modelClasses1
                          }),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                            color: Consts.appColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: Text(
                          Consts.modelName1,
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  GestureDetector(
                      onTap: () =>
                          Get.toNamed(AppRoutes.qrautozoom, arguments: {
                            "model": Consts.modelPath2,
                            "label": Consts.modelLabels2,
                            "imgz": Consts.modelImgz2,
                            "numberOfClasses": Consts.modelClasses2
                          }),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                            color: Consts.appColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: Text(
                          Consts.modelName2,
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  GestureDetector(
                      onTap: () =>
                          Get.toNamed(AppRoutes.qrautozoom, arguments: {
                            "model": Consts.modelPath3,
                            "label": Consts.modelLabels3,
                            "imgz": Consts.modelImgz3,
                            "numberOfClasses": Consts.modelClasses3
                          }),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.7,
                        decoration: BoxDecoration(
                            color: Consts.appColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: Text(
                          Consts.modelName3,
                          style: GoogleFonts.montserrat(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    "Made with 💙 by Keyur",
                    style: GoogleFonts.montserrat(fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                ]))));
  }
}
