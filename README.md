                
# Camera with intelligent autozoom in Flutter

## Description

Autozoom is an app that automatically adjusts the zoom level to capture an object within the camera's view. If there are multiple objects in the camera's view, you can select the object of your choice by tapping the box label. 

## Motivation

This application addresses the challenge outlined in the [home qualification task](https://ccextractor.org/public/gsoc/takehome/#camera-with-intelligent-autozoom-in-flutter). The implemented solution utilizes Google's ML Kit Object Detection and Tracking for Flutter. On my MOTO G82 5G device, the average time for object detection ranges from 5 to 25 milliseconds. 

## Features

- **Intelligent Autozoom:** The app automatically adjusts the zoom level to capture the Object in focus.
  
- **Object Recognition:** Leveraging custom-trained machine learning models, the app can recognize and adjust the zoom for objects.

## Demo

## Getting Started

To get started with QR Code Autozoom, follow these steps:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/keyurgit45/Autozoom.git
   ```

2. **Navigate to the Project Directory:**
   ```bash
   cd autozoom
   ```

3. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the App:**
   ```bash
   flutter run
   ```

### Acknowledgments

This project utilizes Google's ML Kit Object Detection and Tracking for Flutter, a powerful tool that enhances object recognition and tracking capabilities. We extend our gratitude to the incredible team at Google for developing and maintaining this cutting-edge technology.

- Google ML Kit for Flutter: [Link to ML Kit Documentation](https://developers.google.com/ml-kit)
- ML Kit Object Detection and Tracking: [Link to Object Detection and Tracking Documentation](https://developers.google.com/ml-kit/vision/object-detection)

### Contributing Guidelines

Contributions from the community are highly valued! If you have ideas for improvements, new features, or bug fixes, please feel free to contribute. Fork the repository, make your changes, and submit a pull request. Your involvement is greatly appreciated in enhancing Autozoom. Thank you for considering contributing!
