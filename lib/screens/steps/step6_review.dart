import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:printing/printing.dart';
import '../../providers/form_provider.dart';
import '../../services/pdf_generator_service.dart';
import '../components/form_components.dart';
import '../../utils/bangla_amount_converter.dart';

class ReviewStep extends ConsumerStatefulWidget {
  @override
  _ReviewStepState createState() => _ReviewStepState();
}

class _ReviewStepState extends ConsumerState<ReviewStep> {
  final ImagePicker _picker = ImagePicker();
  bool _showPdf = false;

  Future<void> _takeSignature() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final form = ref.read(formProvider);
      ref
          .read(formProvider.notifier)
          .updateField(form.copyWith(applicantSignaturePath: photo.path));
    }
  }

  void _generatePdf() async {
    final form = ref.read(formProvider);
    if (form.applicantSignaturePath == null ||
        form.applicantSignaturePath!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "অনুগ্রহ করে স্বাক্ষর প্রদান করুন (Please provide signature)")));
      return;
    }
    setState(() {
      _showPdf = true;
    });
  }

  Widget _buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 130,
              child: Text("$label",
                  style: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.w500))),
          Expanded(
              child: Text(value,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black87))),
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
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => setState(() => _showPdf = false)),
                Text("পিডিএফ প্রিভিউ",
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
          Expanded(
            child: PdfPreview(
              build: (format) => PdfGeneratorService().generatePdf(form),
              allowPrinting: true,
              allowSharing: true,
              canChangeOrientation: false,
              canChangePageFormat: false,
              loadingWidget: Center(child: CircularProgressIndicator()),
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
          SectionCard(
            title: "তথ্য পর্যালোচনা",
            child: Column(
              children: [
                _buildReviewRow("নাম (ইংরেজি)", form.applicantNameEnglish),
                Divider(),
                _buildReviewRow("নাম (বাংলা)", form.applicantNameBangla),
                Divider(),
                _buildReviewRow("মোবাইল", form.mobileNumber),
                Divider(),
                _buildReviewRow("এনআইডি", form.nidNumber),
                Divider(),
                _buildReviewRow("হিসাবের ধরন", form.accountType),
                Divider(),
                _buildReviewRow("পেশা", form.occupation),
                Divider(),
                _buildReviewRow("প্রাথমিক জমা", "${form.initialDeposit} টাকা"),
              ],
            ),
          ),

          SectionCard(
            title: "ঝুঁকি বিশ্লেষণ (Risk Assessment)",
            child: Column(
              children: [
                 _buildReviewRow("ঝুঁকি স্কোর (Score)", form.riskScore.toString()),
                 Divider(),
                 Row(
                   children: [
                     Text("ঝুঁকি রেটিং (Rating): ", style: TextStyle(fontWeight: FontWeight.w500)),
                     SizedBox(width: 10),
                     Container(
                       padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                       decoration: BoxDecoration(
                         color: form.riskRating == 'High' ? Colors.red.shade100 : Colors.green.shade100,
                         borderRadius: BorderRadius.circular(20),
                         border: Border.all(color: form.riskRating == 'High' ? Colors.red : Colors.green),
                       ),
                       child: Text(
                         form.riskRating,
                         style: TextStyle(
                           color: form.riskRating == 'High' ? Colors.red.shade900 : Colors.green.shade900,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ),
                   ],
                 )
              ],
            ),
          ),

          SectionCard(
            title: "ঠিকানা যাচাই (Address Verification)",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("বর্তমান ঠিকানা:", style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                Text(form.presentAddress.fullAddress, style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 10),
                Divider(),
                Text("স্থায়ী ঠিকানা (NID অনুযায়ী):", style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                Text(form.permanentAddress.fullAddress, style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),

          SectionCard(
            title: "আবেদনকারীর স্বাক্ষর",
            child: InkWell(
              onTap: _takeSignature,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (form.applicantSignaturePath != null &&
                            form.applicantSignaturePath!.isNotEmpty)
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: (form.applicantSignaturePath != null &&
                        form.applicantSignaturePath!.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(File(form.applicantSignaturePath!),
                            fit: BoxFit.contain))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_note,
                              size: 40, color: Theme.of(context).primaryColor),
                          SizedBox(height: 8),
                          Text("স্বাক্ষর দিতে এখানে ট্যাপ করুন",
                              style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      ),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _generatePdf,
            icon: Icon(Icons.picture_as_pdf),
            label: Text("পিডিএফ তৈরি ও ডাউনলোড করুন"),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
