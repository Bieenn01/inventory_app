import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras = [];

class CameraWidget1 extends StatefulWidget {
  const CameraWidget1({Key? key}) : super(key: key);

  @override
  State<CameraWidget1> createState() => _CameraWidget1State();
}

class _CameraWidget1State extends State<CameraWidget1>
    with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  File? _capturedImageFile;
  bool _isCameraActive = false;

  @override
  void initState() {
    super.initState();
    // Initialize camera only if needed
  }

  @override
  void dispose() {
    if (_cameraController.value.isInitialized) {
      _cameraController.dispose();
    }
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
          child: _isCameraActive
              ? AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Card(
                    elevation: 10,
                    margin: EdgeInsets.all(10),
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
                )
              : Center(
                  child: Text(
                    'Camera is off',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isCameraActive
              ? ElevatedButton(
                  onPressed: () async {
                    try {
                      if (_cameraController.value.isInitialized) {
                        final XFile? image =
                            await _cameraController.takePicture();
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
                )
              : ElevatedButton(
                  onPressed: _initializeCamera,
                  child: const Text('Enable Camera'),
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
              height: 300,
              width: 300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _capturedImageFile = null;
                  _isCameraActive = false; // Turn off the camera
                });
                // Optionally, reinitialize the camera
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
      setState(() {
        _isCameraActive = true; // Camera is now active
      });
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
