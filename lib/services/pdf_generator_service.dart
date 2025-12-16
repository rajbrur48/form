import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/application_form.dart';

class PdfGeneratorService {
  Future<Uint8List> generatePdf(ApplicationForm form) async {
    final pdf = pw.Document();

    // Load Fonts
    final fontData = await rootBundle.load("assets/fonts/NotoSansBengali-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);
    final boldFontData = await rootBundle.load("assets/fonts/NotoSansBengali-Bold.ttf");
    final boldTtf = pw.Font.ttf(boldFontData);

    // Helper to load image assets
    Future<pw.MemoryImage> loadImage(String assetName) async {
      final ByteData data = await rootBundle.load('assets/images/$assetName');
      return pw.MemoryImage(data.buffer.asUint8List());
    }

    // Load Background Images
    final bgPage1 = await loadImage('1.png');
    // We would load all 11 images here in a real scenario
    // final bgPage2 = await loadImage('2.png'); ...

    final bgPage4 = await loadImage('4.png');
    final bgPage5 = await loadImage('5.png');

    // Helper for Text Overlay
    pw.Widget positionedText(String text, double x, double y, {double size = 10, bool isBold = false}) {
      return pw.Positioned(
        left: x,
        top: y,
        child: pw.Text(
          text,
          style: pw.TextStyle(
            font: isBold ? boldTtf : ttf,
            fontSize: size,
          ),
        ),
      );
    }

    // --- PAGE 1: Personal Info ---
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero, // FULL BLEED for background
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // 1. Background Image
              pw.FullPage(
                ignoreMargins: true,
                child: pw.Image(bgPage1, fit: pw.BoxFit.fill),
              ),

              // 2. Applicant Photo (Top Right)
              // Coordinates need to be calibrated to the image.
              // Assuming A4 (595 x 842 points).
              // 1.png analysis: Photo box is roughly at x=450, y=100
              if (form.applicantPhotoPath != null)
                pw.Positioned(
                  left: 480,
                  top: 130,
                  child: pw.Container(
                    width: 80,
                    height: 90,
                    child: pw.Image(pw.MemoryImage(File(form.applicantPhotoPath!).readAsBytesSync()), fit: pw.BoxFit.cover),
                  ),
                ),

              // 3. Text Fields Overlays (Approximated Coordinates based on visual inspection of standard forms)
              // Name Bangla
              positionedText(form.applicantNameBangla, 180, 245, size: 12),

              // Name English
              positionedText(form.applicantNameEnglish, 180, 265, size: 12),

              // NID Number
              positionedText(form.nidNumber, 180, 310, size: 12),

              // DOB
              positionedText(form.dob, 400, 310, size: 12),

              // Father Name
              positionedText(form.fatherName, 180, 335, size: 12),

              // Mother Name
              positionedText(form.motherName, 180, 355, size: 12),

              // Example of filling checkboxes (if we had them mapped)
              // positionedText("X", 100, 100, isBold: true),
            ],
          );
        },
      ),
    );

    // --- PAGE 2 & 3: Backgrounds (Professional info usually on Page 1 or 3, simplified here) ---
    for (int i = 2; i <= 3; i++) {
       final bg = await loadImage('$i.png');
       pdf.addPage(pw.Page(
           pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.zero,
           build: (c) => pw.FullPage(ignoreMargins: true, child: pw.Image(bg, fit: pw.BoxFit.fill))
       ));
    }

    // --- PAGE 4: Nominee Info ---
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
           final nominee = form.nominees.isNotEmpty ? form.nominees[0] : Nominee.empty();
           return pw.Stack(
            children: [
              pw.FullPage(ignoreMargins: true, child: pw.Image(bgPage4, fit: pw.BoxFit.fill)),

              // Nominee Name
              positionedText(nominee.name, 180, 150, size: 12),
              // Relation
              positionedText(nominee.relation, 180, 170, size: 12),
              // DOB
              positionedText(nominee.dob, 400, 170, size: 12),
              // NID
              positionedText(nominee.nidNumber, 180, 190, size: 12),

              // Nominee Photo (Top Right Box usually)
              if (nominee.photoPath.isNotEmpty)
                pw.Positioned(
                  left: 480, top: 80,
                  child: pw.Container(
                    width: 80, height: 90,
                    child: pw.Image(pw.MemoryImage(File(nominee.photoPath).readAsBytesSync()), fit: pw.BoxFit.cover),
                  ),
                ),
            ],
          );
        },
      ),
    );

    // --- PAGE 5: Transaction Profile ---
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
           final tp = form.transactionProfile;
           return pw.Stack(
            children: [
              pw.FullPage(ignoreMargins: true, child: pw.Image(bgPage5, fit: pw.BoxFit.fill)),

              // Source of Fund
              positionedText(tp.sourceOfFund, 250, 180, size: 12),
              // Monthly Income
              positionedText(tp.monthlyIncome, 250, 200, size: 12),

              // Cash Deposit
              positionedText(tp.cashDepositNum, 300, 300, size: 12),
              positionedText(tp.cashDepositAmt, 400, 300, size: 12),
            ],
          );
        },
      ),
    );

    // --- Pages 6-11: Office Use / Risk Grading (Backgrounds) ---
    for (int i = 6; i <= 11; i++) {
        final bg = await loadImage('$i.png');
        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.zero,
            build: (c) => pw.FullPage(ignoreMargins: true, child: pw.Image(bg, fit: pw.BoxFit.fill)),
        ));
    }

    return pdf.save();
  }
}
