
# Camera with intelligent autozoom in Flutter

## Description

QR Code Autozoom is a Flutter application that addresses the challenge of intelligent autozoom in the camera. Inspired by the problem statement, the app enables users to take pictures of objects, specifically focusing on scenarios like capturing images of dogs or cats. In this app, I have used a QR code detection model inspired by Google Pay's autozoom feature. The app utilizes the Ultralytics YOLO v8 model to intelligently autozoom to the right size, ensuring that the object in view is captured with optimal clarity.

## Motivation

The motivation behind QR Code Autozoom is to provide a solution to the challenge of intelligent autozoom in Flutter. By creating an application that can dynamically adjust the zoom level based on the object in focus, we aim to enhance the user experience when capturing images, particularly in scenarios where speed and precision are essential. QR Code Autozoom is inspired by the desire to make the process of taking pictures more efficient and user-friendly.

## Features

- **Intelligent Autozoom:** The app automatically adjusts the zoom level to capture the QR Code in focus.
  
- **Object Recognition:** Leveraging pre-trained machine learning models, the app can recognize and adjust the zoom for specific objects, in this case, QR Code.

## Demo

https://github.com/keyurgit45/QRCodeAutozoom/assets/75253653/ec9a8c61-bca5-466e-a6e7-35b6718643ef

https://github.com/keyurgit45/QRCodeAutozoom/assets/75253653/0661b5be-bc31-4b05-8e82-ae6619c96189

## Getting Started

To get started with QR Code Autozoom, follow these steps:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/keyurgit45/QRCodeAutozoom.git
   ```

2. **Navigate to the Project Directory:**
   ```bash
   cd qrscanner
   ```

3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the App:**
   ```bash
   flutter run
   ```
