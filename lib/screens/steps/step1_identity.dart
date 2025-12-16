import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';
import '../../services/nid_ocr_service.dart';
import '../../utils/mock_data.dart';
import '../camera_screen.dart';
import '../components/form_components.dart';
import 'dart:io';

class IdentityVerificationStep extends ConsumerWidget {
  final VoidCallback onNext;

  const IdentityVerificationStep({Key? key, required this.onNext})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final ocrService = NidOcrService();

    void _scanNidFront() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => CameraScreen(
              label: "Scan NID Front",
              onImageCaptured: (file) async {
                ref.read(formProvider.notifier).setImages(nidFront: file.path);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Processing OCR...")));
                try {
                  final data = await ocrService.processNidFront(file);
                  ref.read(formProvider.notifier).updatePersonalDetails(
                        nameBangla: data.nameBangla,
                        nameEnglish: data.nameEnglish,
                        dob: data.dob,
                        nid: data.nidNumber,
                      );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Data Extracted!")));
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("OCR Failed: $e")));
                }
              },
            ),
          ));
    }

    void _scanNidBack() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => CameraScreen(
              label: "Scan NID Back",
              onImageCaptured: (file) async {
                ref.read(formProvider.notifier).setImages(nidBack: file.path);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Processing Back Side...")));
                try {
                  final addressData = await ocrService.processNidBack(file);
                  ref.read(formProvider.notifier).updateAddress(
                        isPermanent: true,
                        flatNo: addressData.flatNo,
                        village: addressData.village,
                        postOffice: addressData.postOffice,
                        postCode: addressData.postCode,
                        policeStation: addressData.policeStation,
                        district: addressData.district,
                      );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Address Extracted!")));
                } catch (e) {
                   ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Address OCR Failed: $e")));
                }
              },
            ),
          ));
    }

    void _takePhoto() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => CameraScreen(
              label: "Applicant Photo",
              onImageCaptured: (file) {
                ref
                    .read(formProvider.notifier)
                    .setImages(applicantPhoto: file.path);
              },
            ),
          ));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionCard(
            title: "পরিচয় যাচাইকরণ",
            child: Column(
              children: [
                _buildModernImageCard(
                  context,
                  "জাতীয় পরিচয়পত্র (সামনের অংশ)",
                  form.nidFrontPath,
                  _scanNidFront,
                ),
                SizedBox(height: 16),
                _buildModernImageCard(
                  context,
                  "জাতীয় পরিচয়পত্র (পেছনের অংশ)",
                  form.nidBackPath,
                  _scanNidBack,
                ),
                SizedBox(height: 16),
                _buildModernImageCard(
                  context,
                  "আবেদনকারীর ছবি",
                  form.applicantPhotoPath,
                  _takePhoto,
                ),
              ],
            ),
          ),

          Center(
            child: TextButton.icon(
              icon: Icon(Icons.flash_on, size: 16),
              label: Text("স্বয়ংক্রিয় পূরণ (ডেমো)"),
              style: TextButton.styleFrom(foregroundColor: Colors.orange),
              onPressed: () {
                ref
                    .read(formProvider.notifier)
                    .updateField(MockData.getCompleteMockForm());
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("তথ্য পূরণ করা হয়েছে!")));
              },
            ),
          ),

          StepNavigationButtons(
            onNext: onNext,
          ),
        ],
      ),
    );
  }

  Widget _buildModernImageCard(
      BuildContext context, String label, String? path, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: path != null
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: path != null ? 2 : 1,
            style: BorderStyle.solid,
          ),
          boxShadow: [
             if(path == null)
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 1
              )
          ]
        ),
        child: path != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(File(path), fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.05),
                      shape: BoxShape.circle
                    ),
                    child: Icon(Icons.camera_alt_outlined,
                        size: 32, color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 12),
                  Text(
                    label,
                    style: TextStyle(
                        color: Colors.grey.shade800, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "স্ক্যান করতে ট্যাপ করুন",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
      ),
    );
  }
}
