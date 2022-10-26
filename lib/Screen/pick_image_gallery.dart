import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageGallery extends StatefulWidget {
  const PickImageGallery({Key? key}) : super(key: key);

  @override
  State<PickImageGallery> createState() => _PickImageGalleryState();
}

class _PickImageGalleryState extends State<PickImageGallery> {
  ImagePicker picker = ImagePicker();
  XFile? file;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  file = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {});
                },
                child: Text('Image')),
            Expanded(child : file == null?Container():Image.file(File(file!.path)))
          ],
        ),
      ),
    );
  }
}
