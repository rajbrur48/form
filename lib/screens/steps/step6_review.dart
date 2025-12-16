import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:printing/printing.dart';
import '../../providers/form_provider.dart';
import '../../services/pdf_generator_service.dart';

class ReviewStep extends ConsumerStatefulWidget {
  @override
  _ReviewStepState createState() => _ReviewStepState();
}

class _ReviewStepState extends ConsumerState<ReviewStep> {
  final ImagePicker _picker = ImagePicker();
  bool _showPdf = false;
  bool _isGenerating = false;

  Future<void> _takeSignature() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final form = ref.read(formProvider);
      ref.read(formProvider.notifier).updateField(form.copyWith(applicantSignaturePath: photo.path));
    }
  }

  void _generatePdf() async {
    final form = ref.read(formProvider);
    if (form.applicantSignaturePath == null || form.applicantSignaturePath!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("অনুগ্রহ করে স্বাক্ষর প্রদান করুন (Please provide signature)")));
        return;
    }
    setState(() {
      _showPdf = true;
    });
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text("$label:", style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold))),
          Expanded(child: Text(value, style: TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(formProvider);

    if (_showPdf) {
      return Column(
        children: [
          Row(
            children: [
               IconButton(icon: Icon(Icons.arrow_back), onPressed: () => setState(() => _showPdf = false)),
               Text("পিডিএফ প্রিভিউ", style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          Expanded(
            child: PdfPreview(
              build: (format) => PdfGeneratorService().generatePdf(form),
              allowPrinting: true,
              allowSharing: true,
              canChangeOrientation: false,
              canChangePageFormat: false,
            ),
          ),
        ],
      );
    }

    // Default Review UI
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("আবেদন পর্যালোচনা", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 20),

          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
            child: Column(
                children: [
                    _buildReviewRow("নাম (ইংরেজি)", form.applicantNameEnglish),
                    _buildReviewRow("নাম (বাংলা)", form.applicantNameBangla),
                    _buildReviewRow("মোবাইল", form.mobileNumber),
                    _buildReviewRow("এনআইডি", form.nidNumber),
                    _buildReviewRow("হিসাবের ধরন", form.accountType),
                    _buildReviewRow("পেশা", form.occupation),
                ]
            ),
          ),

          SizedBox(height: 20),
          Text("স্বাক্ষর", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 10),
          GestureDetector(
            onTap: _takeSignature,
            child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100]
                ),
                child: (form.applicantSignaturePath != null && form.applicantSignaturePath!.isNotEmpty)
                  ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(form.applicantSignaturePath!), fit: BoxFit.contain))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          Icon(Icons.edit, size: 40, color: Colors.grey),
                          Text("স্বাক্ষর দিতে এখানে ট্যাপ করুন"),
                      ]
                  ),
            ),
          ),

          SizedBox(height: 30),
          ElevatedButton(
            onPressed: _generatePdf,
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
            child: Text("পিডিএফ তৈরি ও ডাউনলোড করুন", style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
