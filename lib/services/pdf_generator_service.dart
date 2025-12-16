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

    // Load Background Images (Pre-load all to prevent async issues inside build)
    final bgPages = <int, pw.MemoryImage>{};
    for(int i=1; i<=11; i++) {
        try {
            bgPages[i] = await loadImage('$i.png');
        } catch (e) {
            print("Error loading image $i.png: $e");
        }
    }

    // Advanced Text Drawing Helper
    pw.Widget positionedText(
      String text,
      double x,
      double y,
      {
        double width = 200,
        double size = 10,
        bool isBold = false,
        bool centered = false,
        int maxLines = 1,
      }) {
      return pw.Positioned(
        left: x,
        top: y,
        child: pw.Container(
          width: width,
          child: pw.Text(
            text,
            maxLines: maxLines,
            overflow: pw.TextOverflow.clip, // Or fit
            textAlign: centered ? pw.TextAlign.center : pw.TextAlign.left,
            style: pw.TextStyle(
              font: isBold ? boldTtf : ttf,
              fontSize: size,
            ),
          ),
        ),
      );
    }

    // --- PAGE 1: Personal Info ---
    if (bgPages.containsKey(1)) {
        pdf.addPage(
        pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.zero,
            build: (pw.Context context) {
            return pw.Stack(
                children: [
                pw.FullPage(ignoreMargins: true, child: pw.Image(bgPages[1]!, fit: pw.BoxFit.fill)),

                // Photo
                if (form.applicantPhotoPath != null)
                    pw.Positioned(
                    left: 440, // Adjusted X
                    top: 110,  // Adjusted Y
                    child: pw.Container(
                        width: 90,
                        height: 100,
                        child: pw.Image(pw.MemoryImage(File(form.applicantPhotoPath!).readAsBytesSync()), fit: pw.BoxFit.cover),
                    ),
                    ),

                // Name Bangla (Adjusted coordinates)
                positionedText(form.applicantNameBangla, 140, 248, width: 250, size: 12),

                // Name English
                positionedText(form.applicantNameEnglish, 140, 268, width: 250, size: 12),

                // NID
                positionedText(form.nidNumber, 140, 312, width: 150, size: 12),

                // DOB
                positionedText(form.dob, 410, 312, width: 100, size: 12),

                // Father
                positionedText(form.fatherName, 140, 335, width: 250, size: 12),

                // Mother
                positionedText(form.motherName, 140, 355, width: 250, size: 12),

                // Initial Deposit (Item 5 logic)
                 if (form.initialDeposit.isNotEmpty) ...[
                     positionedText(form.initialDeposit, 180, 600, width: 100, size: 12),
                     positionedText(BanglaAmountConverter.convert(double.tryParse(form.initialDeposit) ?? 0), 300, 600, width: 250, size: 12),
                  ]
                ],
            );
            },
        ),
        );
    }

    // --- PAGE 2: Address Information ---
     if (bgPages.containsKey(2)) {
        pdf.addPage(
        pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.zero,
            build: (pw.Context context) {
            return pw.Stack(
                children: [
                pw.FullPage(ignoreMargins: true, child: pw.Image(bgPages[2]!, fit: pw.BoxFit.fill)),

                // Present Address
                positionedText(form.presentAddress.roadNo + ", " + form.presentAddress.village, 160, 105, width: 350, size: 10, maxLines: 2),
                positionedText(form.presentAddress.postOffice, 160, 128, width: 150, size: 10),
                positionedText(form.presentAddress.postCode, 420, 128, width: 80, size: 10),
                positionedText(form.presentAddress.policeStation, 160, 148, width: 150, size: 10),
                positionedText(form.presentAddress.district, 420, 148, width: 100, size: 10),

                // Permanent Address
                positionedText(form.permanentAddress.roadNo + ", " + form.permanentAddress.village, 160, 245, width: 350, size: 10, maxLines: 2),
                positionedText(form.permanentAddress.postOffice, 160, 268, width: 150, size: 10),
                positionedText(form.permanentAddress.postCode, 420, 268, width: 80, size: 10),
                positionedText(form.permanentAddress.policeStation, 160, 288, width: 150, size: 10),
                positionedText(form.permanentAddress.district, 420, 288, width: 100, size: 10),

                // Contact Info
                positionedText(form.mobileNumber, 160, 400, width: 150, size: 12),
                ],
            );
            },
        ),
        );
     }

    // --- PAGE 3: Professional ---
    if (bgPages.containsKey(3)) {
        pdf.addPage(pw.Page(
             pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.zero,
             build: (c) => pw.Stack(children: [
                 pw.FullPage(ignoreMargins: true, child: pw.Image(bgPages[3]!, fit: pw.BoxFit.fill)),
                 positionedText(form.occupation, 160, 105, width: 300, size: 12),
                 positionedText(form.monthlyIncome, 160, 128, width: 200, size: 12),
                 // Introducer
                 positionedText(form.introducerName, 160, 380, width: 250, size: 12),
                 positionedText(form.introducerAccountNo, 160, 400, width: 200, size: 12),
             ])
        ));
    }

    // --- PAGE 4: Nominee ---
    if (bgPages.containsKey(4)) {
        pdf.addPage(pw.Page(
             pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.zero,
             build: (c) {
                final nominee = form.nominees.isNotEmpty ? form.nominees[0] : Nominee.empty();
                return pw.Stack(children: [
                    pw.FullPage(ignoreMargins: true, child: pw.Image(bgPages[4]!, fit: pw.BoxFit.fill)),
                    positionedText(nominee.name, 160, 160, width: 250, size: 12),
                    positionedText(nominee.relation, 160, 182, width: 150, size: 12),
                    positionedText(nominee.dob, 410, 182, width: 100, size: 12),
                    positionedText(nominee.nidNumber, 160, 204, width: 200, size: 12),
                    if (nominee.photoPath.isNotEmpty)
                        pw.Positioned(
                            left: 440, top: 90,
                            child: pw.Container(
                                width: 90, height: 100,
                                child: pw.Image(pw.MemoryImage(File(nominee.photoPath).readAsBytesSync()), fit: pw.BoxFit.cover),
                            ),
                        ),
                ]);
             }
        ));
    }

    // --- PAGE 5: Transaction Profile ---
    if (bgPages.containsKey(5)) {
        pdf.addPage(pw.Page(
             pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.zero,
             build: (c) {
                 final tp = form.transactionProfile;
                 return pw.Stack(children: [
                    pw.FullPage(ignoreMargins: true, child: pw.Image(bgPages[5]!, fit: pw.BoxFit.fill)),
                    positionedText(tp.sourceOfFund, 250, 185, width: 200, size: 11),
                    positionedText(tp.monthlyIncome, 250, 208, width: 200, size: 11),
                    positionedText(tp.cashDepositNum, 320, 310, width: 50, size: 11, centered: true),
                    positionedText(tp.cashDepositAmt, 420, 310, width: 100, size: 11, centered: true),
                 ]);
             }
        ));
    }

    // Pages 6, 7 (Risk), 8 (Owner), 9-11
    final remainingPages = [6, 7, 8, 9, 10, 11];
    for (var i in remainingPages) {
        if (bgPages.containsKey(i)) {
            pdf.addPage(pw.Page(
                pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.zero,
                build: (c) {
                    final stackChildren = <pw.Widget>[
                        pw.FullPage(ignoreMargins: true, child: pw.Image(bgPages[i]!, fit: pw.BoxFit.fill)),
                    ];

                    if (i == 7) {
                        // Risk Score Overlay
                        stackChildren.add(positionedText("${form.riskScore}", 310, 595, width: 50, size: 14, isBold: true));
                        stackChildren.add(positionedText(form.riskRating, 310, 625, width: 100, size: 14, isBold: true));
                    }

                    if (i == 8) {
                        // Beneficial Owner Overlay
                        stackChildren.add(positionedText(form.beneficialOwnerName, 160, 160, width: 250, size: 12));
                        stackChildren.add(positionedText(form.beneficialOwnerRelation, 160, 180, width: 150, size: 12));
                        stackChildren.add(positionedText(form.beneficialOwnerDob, 410, 180, width: 100, size: 12));
                        stackChildren.add(positionedText(form.beneficialOwnerNid, 160, 200, width: 200, size: 12));
                    }

                    return pw.Stack(children: stackChildren);
                }
            ));
        }
    }

    return pdf.save();
  }
}
