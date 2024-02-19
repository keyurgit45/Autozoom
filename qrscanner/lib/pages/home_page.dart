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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                          "The Flutter app integrates YOLOv8 with three models: COCO and OpenImagesV7 pretrained models for versatile object recognition and a custom-trained QR code model. The app dynamically autozooms to detected objects in the camera feed. \n\nSelect one of the following models to proceed:",
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
                      ]),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "Made with 💙 by Keyur",
                      style: GoogleFonts.montserrat(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ])));
  }
}
