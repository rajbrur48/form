import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
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
    _requestPermissionAndInit();
  }

  Future<void> _requestPermissionAndInit() async {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
          status = await Permission.camera.request();
      }

      if (status.isGranted) {
          _initCamera();
      } else {
          // Handle permission denied
          if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ক্যামেরা ব্যবহারের অনুমতি প্রয়োজন")));
              Navigator.pop(context);
          }
      }
  }

  Future<void> _initCamera() async {
    try {
        cameras = await availableCameras();
        if (cameras != null && cameras!.isNotEmpty) {
        _controller = CameraController(
            cameras![0],
            ResolutionPreset.high,
            enableAudio: false, // Performance optimization
        );
        await _controller!.initialize();
        if (mounted) {
            setState(() {
            _isCameraInitialized = true;
            });
        }
        } else {
             _showError("কোনো ক্যামেরা পাওয়া যায়নি");
        }
    } catch (e) {
        _showError("ক্যামেরা চালু করা যাচ্ছে না: $e");
    }
  }

  void _showError(String message) {
      if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
          Navigator.pop(context);
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
      return Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor)));
    }

    // Camera Preview requires a specific aspect ratio, often creating layout issues.
    // We use a Scaled preview or just a simple Container for now.
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text(widget.label),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),

          // Guide Box
          Center(
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor, width: 3),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2)
                ]
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Icon(Icons.crop_free, color: Colors.white.withOpacity(0.5), size: 48),
                      Text("এখানে স্থাপন করুন", style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  ],
              ),
            ),
          ),

          // Controls
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                color: Colors.black45,
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    IconButton(
                        icon: Icon(Icons.photo_library, color: Colors.white, size: 30),
                        tooltip: "গ্যালারি",
                        onPressed: _pickFromGallery,
                    ),

                    Container(
                        height: 70, width: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: FloatingActionButton(
                            onPressed: _captureImage,
                            backgroundColor: Colors.white,
                            elevation: 0,
                            child: Icon(Icons.camera, color: Colors.black, size: 32),
                        ),
                    ),

                    SizedBox(width: 30), // Placeholder for balance
                ],
                ),
            ),
          ),
        ],
      ),
    );
  }
}
