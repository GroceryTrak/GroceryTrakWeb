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
  bool _isProcessing = false;

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
      setState(() {
        _isProcessing = true;
      });
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
      
      // Show a custom dialog with the prediction details.
      final result = await showDialog<UserItemModel>(
        context: context,
        builder: (context) => DetectedItemDialog(predictedItem: predictedItem),
      );
      await saveCapture(predictedItem.item.id);
      Navigator.pop(context, result);
    } catch (e) {
      print("Error capturing image: $e");
      // Optionally, show an error dialog here.
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Capture Fridge Image')),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          if (_isProcessing)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: _isProcessing ? null : _captureAndPredict,
      ),
    );
  }
}

class DetectedItemDialog extends StatelessWidget {
  final UserItemModel predictedItem;

  const DetectedItemDialog({Key? key, required this.predictedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Item Detected"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 60),
          const SizedBox(height: 16),
          Text(
            predictedItem.item.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            predictedItem.item.description,
            style: const TextStyle(fontSize: 16),
          ),
          // Optionally, add more item details here.
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, predictedItem),
          child: const Text("OK"),
        ),
      ],
    );
  }
}
