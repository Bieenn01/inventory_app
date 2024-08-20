import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras = [];

class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key}) : super(key: key);

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget>
    with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  File? _capturedImageFile;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          
          body: _capturedImageFile == null
              ? _buildCameraCaptureView()
              : _buildImagePreviewView(),
        ),
      ),
    );
  }

  Widget _buildCameraCaptureView() {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 4 / 3, // Aspect ratio of 4:3
            child: Card(
              elevation: 10,
              margin: EdgeInsets.all(10), // Adjust as needed
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return CameraPreview(_cameraController);
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () async {
              try {
                if (_cameraController.value.isInitialized) {
                  // Capture the image
                  final XFile? image = await _cameraController.takePicture();
                  if (image != null) {
                    setState(() {
                      _capturedImageFile = File(image.path);
                    });
                  }
                }
              } catch (e) {
                print("Error capturing image: $e");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error capturing image: $e')),
                );
              }
            },
            child: const Icon(Icons.camera),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blueGrey,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              textStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              elevation: 5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreviewView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _showFullImage(context, _capturedImageFile!);
            },
            child: Image.file(
              _capturedImageFile!,
              fit: BoxFit.cover,
              height: 300, // Adjust as needed
              width: 300, // Adjust as needed
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _capturedImageFile = null; // Reset to capture a new image
                });
                _initializeCamera(); // Reinitialize camera if needed
              },
              child: const Text('Capture New Image'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blueGrey,
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 24.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                textStyle: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.max);
    try {
      await _cameraController.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  void _showFullImage(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Image.file(
              imageFile,
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
        );
      },
    );
  }
}
