import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscanner/controller/pattern_controller.dart';
import 'package:qrscanner/navigation/app_routes.dart';
import 'package:qrscanner/pages/pattern_painter.dart';
import 'package:qrscanner/utils/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final patternController = Get.put(PatternController());
    return Scaffold(
        backgroundColor: Consts.appColor,
        body: Stack(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    Text(
                      'Camera Intelligent Autozoom',
                      style: GoogleFonts.montserrat(
                          color: Colors.white, fontSize: 24),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Text(
                      "Autozoom is an app that automatically adjusts the zoom level to capture an object that is within the camera's view. In case there are multiple objects in the camera's view, you can select the object of your choice by tapping on the label of the box.",
                      style: GoogleFonts.montserrat(
                          fontSize: 17, color: Colors.white),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.objectdetection),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 10.0,
                                ),
                              ]),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_arrow),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Start Detecting",
                                style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    color: Consts.appColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                        )),
                  ])),
          AnimatedBuilder(
              animation: patternController.controller!,
              builder: (context, child) {
                return Positioned(
                  bottom: 0,
                  right: patternController.animation!.value,
                  child: ClipPath(
                    clipper: PatternPainter(),
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        color: Colors.white,
                        width: 900,
                        height: 200,
                      ),
                    ),
                  ),
                );
              }),
          AnimatedBuilder(
              animation: patternController.controller!,
              builder: (context, child) {
                return Positioned(
                  bottom: 0,
                  left: patternController.animation!.value,
                  child: ClipPath(
                    clipper: PatternPainter(),
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        color: Colors.white,
                        width: 900,
                        height: 200,
                      ),
                    ),
                  ),
                );
              }),
        ]));
  }
}
