import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../screens/camera_screen.dart';

AppBar buildAppBar(BuildContext context, CameraDescription? camera) {
  return AppBar(
    backgroundColor: Colors.green,
    title: const Text('GroceryTrak'),
    centerTitle: true,
    automaticallyImplyLeading: false,
    actions: [
      if (camera != null)
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CameraScreen(camera: camera)),
            );
          },
        ),
    ],
  );
}
