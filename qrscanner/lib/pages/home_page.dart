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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Camera with intelligent autozoom in Flutter",
              style:
                  GoogleFonts.nunito(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Text(
              "QR Code Autozoom is a Flutter application that addresses the challenge of intelligent autozoom in the camera. Inspired by the problem statement, the app enables users to take pictures of objects, specifically focusing on scenarios like capturing images of dogs or cats. In this app, I have used a QR code detection model inspired by Google Pay's autozoom feature. The app utilizes Ultralytics YOLO v8 model to intelligently autozoom to the right size, ensuring that the object in view is captured with optimal clarity.",
              style: GoogleFonts.montserrat(fontSize: 18),
              textAlign: TextAlign.justify,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            GestureDetector(
              onTap: () => Get.toNamed('/qrautozoom'),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                radius: 40,
                child: const Icon(
                  Icons.arrow_forward_ios,
                  size: 52,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
