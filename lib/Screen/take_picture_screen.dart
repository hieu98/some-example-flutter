import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key}) : super(key: key);

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max);
      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print('No camera!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 450,
                  width: double.maxFinite,
                  child: controller == null
                      ? Center(
                          child: Text('Loading Camera ...'),
                        )
                      : !controller!.value.isInitialized
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : CameraPreview(controller!)),
              ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      if (controller != null) {
                        if (controller!.value.isInitialized) {
                          image = await controller!.takePicture();
                          setState(() {});
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Capture')),
              Container(
                  child: image == null
                      ? Text('No image')
                      : Image.file(
                          File(image!.path),
                          height: 300,
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.file(File(imagePath)),
    );
  }
}
