import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

void showSnackBar(String title, String message) {
  Get.snackbar(
    title, // Title text
    message, // Message text
    backgroundColor: Colors.grey[900], // Dark background color
    colorText: Colors.white, // Light text color
    snackPosition: SnackPosition.BOTTOM, // Position of the snackbar
    borderRadius: 10, // Rounded corners
    margin: EdgeInsets.all(10), // Margin around the snackbar
    duration: Duration(seconds: 2), // Duration of the snackbar
    isDismissible: true, // Allows the snackbar to be dismissed
    forwardAnimationCurve: Curves.easeOutBack, // Animation style
    reverseAnimationCurve: Curves.easeIn,
    barBlur: 10, // Blur effect for the background
    overlayBlur: 1, // Blur effect for the overlay
    overlayColor: Colors.black54, // Overlay color
  );
}
