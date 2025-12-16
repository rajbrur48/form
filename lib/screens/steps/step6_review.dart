import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../../providers/form_provider.dart';
import '../../services/pdf_generator_service.dart';
import '../components/form_components.dart';
import '../components/signature_pad.dart';

class ReviewStep extends ConsumerStatefulWidget {
  @override
  _ReviewStepState createState() => _ReviewStepState();
}

class _ReviewStepState extends ConsumerState<ReviewStep> {
  final ImagePicker _picker = ImagePicker();
  bool _showPdf = false;

  Future<void> _takeSignature() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        List<Offset> currentPoints = [];
        return Container(
          height: 400,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
               Text("আপনার স্বাক্ষর প্রদান করুন", style: Theme.of(context).textTheme.titleMedium),
               SizedBox(height: 16),
               Expanded(
                 child: Container(
                   decoration: BoxDecoration(
                     border: Border.all(color: Colors.grey.shade300),
                     borderRadius: BorderRadius.circular(8),
                   ),
                   child: SignaturePad(
                     onDrawEnd: (points) {
                        currentPoints = points;
                     },
                     strokeColor: Colors.black,
                   ),
                 ),
               ),
               SizedBox(height: 16),
               Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   TextButton(onPressed: () => Navigator.pop(context), child: Text("বাতিল")),
                   ElevatedButton(
                     onPressed: () async {
                        if (currentPoints.isNotEmpty) {
                             final path = await _saveSignature(currentPoints);
                             ref.read(formProvider.notifier).updateField(
                               ref.read(formProvider).copyWith(applicantSignaturePath: path)
                             );
                             Navigator.pop(context);
                        }
                     },
                     child: Text("সংরক্ষণ করুন")
                   ),
                 ],
               )
            ],
          ),
        );
      },
    );
  }

  Future<String> _saveSignature(List<Offset> points) async {
      // 1. Calculate Bounds
      double minX = double.infinity, minY = double.infinity;
      double maxX = double.negativeInfinity, maxY = double.negativeInfinity;

      for(var p in points) {
          if (p != Offset.zero) {
              if (p.dx < minX) minX = p.dx;
              if (p.dy < minY) minY = p.dy;
              if (p.dx > maxX) maxX = p.dx;
              if (p.dy > maxY) maxY = p.dy;
          }
      }

      // Handle empty or invalid drawing
      if (minX == double.infinity) return "";

      final width = maxX - minX + 20; // +Padding
      final height = maxY - minY + 20;

      // 2. Setup Canvas with correct size
      final recorder = ui.PictureRecorder();
      // We create a canvas large enough for the drawing relative to 0,0
      final canvas = Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(width, height)));
      final paint = Paint()..color = Colors.black..strokeCap = StrokeCap.round..strokeWidth = 3.0;

      // 3. Draw with Translation (Subtract minX, minY to move drawing to 0,0)
      for (int i = 0; i < points.length - 1; i++) {
        if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
           canvas.drawLine(
               points[i] - Offset(minX - 10, minY - 10),  // Shift to origin + padding
               points[i+1] - Offset(minX - 10, minY - 10),
               paint
           );
        }
      }

      final picture = recorder.endRecording();
      final img = await picture.toImage(width.toInt(), height.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(buffer);
      return file.path;
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
                _buildReviewRow("প্রাথমিক জমা", "${form.initialDeposit} টাকা"),
              ],
            ),
          ),

          SectionCard(
            title: "সেবা ও সম্মতি (Services & Consent)",
            child: Column(
              children: [
                 _buildReviewRow("চেক বই", form.requestChequeBook ? "হ্যাঁ" : "না"),
                 Divider(),
                 _buildReviewRow("SMS ব্যাংকিং", form.requestSmsBanking ? "হ্যাঁ" : "না"),
                 Divider(),
                 _buildReviewRow("মার্কিন নাগরিক (FATCA)", form.isUSCitizen ? "হ্যাঁ" : "না"),
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
                  color: Colors.white,
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
                          Icon(Icons.draw_outlined, // Changed icon
                              size: 40, color: Theme.of(context).primaryColor),
                          SizedBox(height: 8),
                          Text("ডিজিটাল স্বাক্ষর দিতে এখানে ট্যাপ করুন",
                              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
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
