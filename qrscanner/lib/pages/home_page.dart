import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('QR Code Autozoom'),
          elevation: 4,
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    style: GoogleFonts.nunito(
                        fontSize: 28, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
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
                    onTap: () => Get.toNamed('/qrautozoom', arguments: {
                      "model": "bestv2",
                      "label": "labels",
                      "imgz": 224,
                      "numberOfClasses": 1
                    }),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("QR code Dataset"),
                        SizedBox(
                          width: 18,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          radius: 40,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 52,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed('/qrautozoom', arguments: {
                      "model": "bestv4",
                      "label": "labelsv4",
                      "imgz": 224,
                      "numberOfClasses": 80
                    }),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("COCO Dataset   "),
                          SizedBox(
                            width: 18,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            radius: 40,
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 52,
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed('/qrautozoom', arguments: {
                      "model": "bestv5",
                      "label": "labelsv5",
                      "imgz": 224,
                      "numberOfClasses": 601
                    }),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("OpenImagesV7 Dataset"),
                        SizedBox(
                          width: 18,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          radius: 40,
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 52,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Text(
                    "Made with 💙 by Keyur",
                    style: GoogleFonts.montserrat(fontSize: 14),
                    textAlign: TextAlign.justify,
                  ),
                ]))));
  }
}
