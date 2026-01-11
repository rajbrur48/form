import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/application_form.dart';
import '../utils/bangla_amount_converter.dart';

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
    final bgPage2 = await loadImage('2.png');
    final bgPage3 = await loadImage('3.png');
    final bgPage4 = await loadImage('4.png');
    final bgPage5 = await loadImage('5.png');
    final bgPage7 = await loadImage('7.png'); // Page 7 for Risk Score
    final bgPage8 = await loadImage('8.png');

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

              // Initial Deposit (Assuming Item 5 or similar on Page 1)
              // Using arbitrary coordinates based on typical "Initial Deposit" location if visible,
              // or bottom of page if not specified. User confirmed it is on Page 1 (3.png in their context, but 1.png here).
              // Let's place it near bottom or check user provided 3.png context.
              // In 3.png, Item 5 is Initial Deposit.
              // Coordinate Estimation: Below Personal Info.
              if (form.initialDeposit.isNotEmpty) ...[
                 positionedText(form.initialDeposit, 180, 600, size: 12), // Figure
                 positionedText(BanglaAmountConverter.convert(double.tryParse(form.initialDeposit) ?? 0), 300, 600, size: 12), // Words
              ]
            ],
          );
        },
      ),
    );

    // --- PAGE 2: Address Information ---
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.FullPage(ignoreMargins: true, child: pw.Image(bgPage2, fit: pw.BoxFit.fill)),

              // Granular Address Fields for Present Address
              // Road / Village
              positionedText(form.presentAddress.roadNo + ", " + form.presentAddress.village, 180, 100, size: 10),
              // Post Office
              positionedText(form.presentAddress.postOffice, 180, 120, size: 10),
              // Post Code (often next to Post Office)
              positionedText(form.presentAddress.postCode, 350, 120, size: 10),
              // Thana / Police Station
              positionedText(form.presentAddress.policeStation, 180, 140, size: 10),
              // District
              positionedText(form.presentAddress.district, 350, 140, size: 10),

              // Granular Address Fields for Permanent Address
              // Road / Village
              positionedText(form.permanentAddress.roadNo + ", " + form.permanentAddress.village, 180, 250, size: 10),
              // Post Office
              positionedText(form.permanentAddress.postOffice, 180, 270, size: 10),
              // Post Code
              positionedText(form.permanentAddress.postCode, 350, 270, size: 10),
              // Thana
              positionedText(form.permanentAddress.policeStation, 180, 290, size: 10),
              // District
              positionedText(form.permanentAddress.district, 350, 290, size: 10),
            ],
          );
        },
      ),
    );

    // --- PAGE 3: Professional & Introducer ---
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.FullPage(ignoreMargins: true, child: pw.Image(bgPage3, fit: pw.BoxFit.fill)),

              // Occupation
              positionedText(form.occupation, 180, 100, size: 12),
              // Monthly Income
              positionedText(form.monthlyIncome, 180, 120, size: 12),

              // Introducer Info
              positionedText(form.introducerName, 180, 400, size: 12),
              positionedText(form.introducerAccountNo, 180, 420, size: 12),
            ],
          );
        },
      ),
    );

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

    // --- Page 6 (Office Use) ---
    // Just background for now, or copy previous loop logic if no content needed.
    final bgPage6 = await loadImage('6.png');
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.zero,
        build: (c) => pw.FullPage(ignoreMargins: true, child: pw.Image(bgPage6, fit: pw.BoxFit.fill)),
    ));

    // --- PAGE 7: Risk Analysis ---
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.FullPage(ignoreMargins: true, child: pw.Image(bgPage7, fit: pw.BoxFit.fill)),

              // Risk Score Total (Item 14)
              // Coordinates estimated from 7.png (bottom section)
              positionedText("${form.riskScore}", 300, 600, size: 14, isBold: true),

              // Risk Rating (High/Low)
              positionedText(form.riskRating, 300, 630, size: 14, isBold: true),

              // Comments
              positionedText(form.riskGradingComments, 100, 660, size: 10),
            ],
          );
        },
      ),
    );

    // --- PAGE 8: Beneficial Owner ---
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.FullPage(ignoreMargins: true, child: pw.Image(bgPage8, fit: pw.BoxFit.fill)),

              positionedText(form.beneficialOwnerName, 180, 150, size: 12),
              positionedText(form.beneficialOwnerRelation, 180, 170, size: 12),
              positionedText(form.beneficialOwnerDob, 400, 170, size: 12),
              positionedText(form.beneficialOwnerNid, 180, 190, size: 12),
            ],
          );
        },
      ),
    );

    // --- Pages 9-11: Terms ---
    for (int i = 9; i <= 11; i++) {
        final bg = await loadImage('$i.png');
        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.zero,
            build: (c) => pw.FullPage(ignoreMargins: true, child: pw.Image(bg, fit: pw.BoxFit.fill)),
        ));
    }

    return pdf.save();
  }
}
