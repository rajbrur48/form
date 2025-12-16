import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';
import '../../services/nid_ocr_service.dart';
import '../camera_screen.dart';
import 'dart:io';

class IdentityVerificationStep extends ConsumerWidget {
  final VoidCallback onNext;

  const IdentityVerificationStep({Key? key, required this.onNext}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final ocrService = NidOcrService();

    void _scanNidFront() {
      Navigator.push(context, MaterialPageRoute(
        builder: (c) => CameraScreen(
          label: "Scan NID Front",
          onImageCaptured: (file) async {
            // Update image path immediately
            ref.read(formProvider.notifier).setImages(nidFront: file.path);

            // Process OCR
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Processing OCR...")));
            try {
                final data = await ocrService.processNidFront(file);
                ref.read(formProvider.notifier).updatePersonalDetails(
                    nameBangla: data.nameBangla,
                    nameEnglish: data.nameEnglish,
                    dob: data.dob,
                    nid: data.nidNumber,
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Extracted!")));
            } catch(e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OCR Failed: $e")));
            }
          },
        ),
      ));
    }

    void _scanNidBack() {
      Navigator.push(context, MaterialPageRoute(
        builder: (c) => CameraScreen(
          label: "Scan NID Back",
          onImageCaptured: (file) async {
            ref.read(formProvider.notifier).setImages(nidBack: file.path);
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Processing Back Side...")));
             try {
                 String addr = await ocrService.processNidBack(file);
                 // Heuristic: Last line is often District/Upazila
                 // This requires smarter parsing in production
                 ref.read(formProvider.notifier).updateAddress(
                     isPermanent: true,
                     village: addr.length > 20 ? addr.substring(0, 20) : addr, // Placeholder logic
                 );
             } catch(e) {}
          },
        ),
      ));
    }

    void _takePhoto() {
      Navigator.push(context, MaterialPageRoute(
        builder: (c) => CameraScreen(
          label: "Applicant Photo",
          onImageCaptured: (file) {
            ref.read(formProvider.notifier).setImages(applicantPhoto: file.path);
          },
        ),
      ));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Identity Verification", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 20),

          _buildImageCard(
              "NID Front",
              form.nidFrontPath,
              _scanNidFront
          ),
          SizedBox(height: 10),
          _buildImageCard(
              "NID Back",
              form.nidBackPath,
              _scanNidBack
          ),
          SizedBox(height: 10),
          _buildImageCard(
              "Applicant Photo",
              form.applicantPhotoPath,
              _takePhoto
          ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: (form.nidFrontPath != null && form.applicantPhotoPath != null) ? onNext : null,
            child: Text("Next"),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String label, String? path, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 150,
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: path != null
                    ? Image.file(File(path), fit: BoxFit.cover)
                    : Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
