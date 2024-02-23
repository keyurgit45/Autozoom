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
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Image.asset(Consts.imagePath),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 35),
                      child: Text(
                        "Autozoom is an app that automatically adjusts the zoom level to capture an object that is within the camera's view. In case there are multiple objects in the camera's view, you can select the object of your choice by tapping on the label of the box.",
                        style: GoogleFonts.montserrat(fontSize: 17),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.objectdetection),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: Consts.appColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                              child: Text(
                            "Start Detecting",
                            style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        )),
                  ]),
            )));
  }
}
