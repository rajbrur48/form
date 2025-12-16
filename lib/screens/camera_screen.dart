import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraScreen extends StatefulWidget {
  final Function(File) onImageCaptured;
  final String label;

  const CameraScreen({Key? key, required this.onImageCaptured, required this.label}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      _controller = CameraController(cameras![0], ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    if (!_isCameraInitialized) return;
    try {
      final image = await _controller!.takePicture();
      widget.onImageCaptured(File(image.path));
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _pickFromGallery() async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
          widget.onImageCaptured(File(pickedFile.path));
          Navigator.pop(context);
      }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.label)),
      body: Stack(
        children: [
          CameraPreview(_controller!),

          // Guide Box
          Center(
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: Icon(Icons.photo_library, color: Colors.white, size: 30),
                    onPressed: _pickFromGallery,
                ),
                FloatingActionButton(
                  onPressed: _captureImage,
                  child: Icon(Icons.camera),
                ),
                SizedBox(width: 30), // Placeholder for balance
              ],
            ),
          ),
        ],
      ),
    );
  }
}
