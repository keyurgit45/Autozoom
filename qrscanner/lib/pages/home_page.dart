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
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(Consts.imagePath),
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
