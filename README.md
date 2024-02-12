                
# Camera with intelligent autozoom in Flutter

## Description

QR Code Autozoom is a special camera app made with Flutter. Inspired by how Google Pay does it, this app is perfect for taking pictures of QR codes. QR code model can be replaced by anything like dogs or cats. It uses an Ultralytics YOLO v8 to find QR codes and zoom in just right. So, your pictures will always look clear and awesome! It's all about making your pictures look great by automatically zooming in on what you want to capture.

### *Update*: 
The App has been updated to support not only the QR code dataset but also the COCO dataset and OpenImageV7 dataset, providing a wider range of object detection options. However, only one type of object should be present in the camera frame at a time. The accuracy of object detection relies on the pre-trained YOLO v8 model used. The COCO dataset contains 80 classes, whereas the OpenImageV7 dataset has 601 classes. It has undergone a UI redesign. 

## Motivation

This application addresses the challenge outlined in the [home qualification task](https://ccextractor.org/public/gsoc/takehome/#camera-with-intelligent-autozoom-in-flutter). The implemented solution utilizes the Ultralytics YOLO v8 model, trained on a custom QR dataset. The code for model training is provided within the repository, allowing for easy model replacement for different object detection purposes. To execute the model on the device, the pytorch_lite package is employed. On my MOTO G82 5G device, the average time for QR code detection ranges from 500 to 700 milliseconds. While the official flutter package from Ultralytics could enhance detection speed to approximately 50-70 milliseconds, its use was precluded due to licensing restrictions.

## Features

- **Intelligent Autozoom:** The app automatically adjusts the zoom level to capture the QR Code in focus.
  
- **Object Recognition:** Leveraging custom-trained machine learning models, the app can recognize and adjust the zoom for specific objects, such as QR codes.

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

### Acknowledgments

I want to express my gratitude to the following individuals and communities for their contributions to this project:

- **Ultralytics YOLO v8 Model Developers:** For providing the powerful YOLO v8 model that forms the core of our object detection capabilities.
  
- **Roboflow:** For providing QR code dataset.
  
- **PyTorch and Flutter Communities:** For creating and maintaining the essential tools and frameworks that enable the seamless integration of PyTorch models with Flutter.

### Contributing Guidelines

Contributions from the community are highly valued! If you have ideas for improvements, new features, or bug fixes, please feel free to contribute. Fork the repository, make your changes, and submit a pull request. Your involvement is greatly appreciated in enhancing QR Code Autozoom. Thank you for considering contributing!
