import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:grocery_trak_web/models/item_model.dart';
import 'package:grocery_trak_web/models/userItem_model.dart';
import 'dart:io';
import 'package:grocery_trak_web/services/userItem_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

Future<void> saveCapture(int chosen) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('chosen', chosen);
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
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
      UserItemModel predictedItem = UserItemModel(
        userId: 0,
        itemId: 0,
        item: ItemModel(id: 0, name: "NA", description: "NA"),
        quantity: 0,
        unit: "N/A",
      );

      if (kIsWeb) {
        // For web: add your web-specific prediction logic if needed.
      } else {
        final imageFile = File(image.path);
        predictedItem = await UserItemApiService.predictItem(imageFile);
      }

      // Show a dialog with the predicted item.
      final result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Predicted Item"),
          content: Text("Item Name: ${predictedItem.item.name}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, predictedItem),
              child: Text("OK"),
            ),
          ],
        ),
      );
      await saveCapture(predictedItem.itemId);
      Navigator.pop(context, result);
    } catch (e) {
      print("Error capturing image: $e");
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
