import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:grocery_trak_web/services/item_api_service.dart';
import 'dart:io'; // Only used on mobile
import 'package:grocery_trak_web/models/item_model.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the camera.
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _captureAndPredict() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      // print("Image: $image");
      ItemModel predictedItem;


      if (kIsWeb) {
        // For web: read image bytes and use a custom API method.
        // print("IN if");
        Uint8List imageBytes = await image.readAsBytes();

        // final imageBytes = await image.readAsBytes();
        // print("after finaal");
        predictedItem = await ItemApiService.predictItemFromBytes(imageBytes, image.name);
      } else {
        // For mobile: use the file from image.path.
        final imageFile = File(image.path);
        predictedItem = await ItemApiService.predictItem(imageFile);
      }

      // Show the predicted item result.
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Predicted Item"),
          content: Text("Item Name: ${predictedItem.name}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Error capturing image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing or predicting image')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Capture Fridge Image')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: _captureAndPredict,
      ),
    );
  }
}
