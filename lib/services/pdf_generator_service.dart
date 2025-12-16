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
    final bgPages = <int, pw.MemoryImage>{};
    for(int i=1; i<=11; i++) {
        try {
            bgPages[i] = await loadImage('$i.png');
        } catch (e) {
            print("Error loading image $i.png: $e");
        }
    }

    // Text Overlay Helper
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
            overflow: pw.TextOverflow.clip,
            textAlign: centered ? pw.TextAlign.center : pw.TextAlign.left,
            style: pw.TextStyle(
              font: isBold ? boldTtf : ttf,
              fontSize: size,
            ),
          ),
        ),
      );
    }

    // Checkbox Helper (Draws a tick mark)
    pw.Widget positionedCheckbox(bool value, double x, double y) {
        if (!value) return pw.Container();
        return pw.Positioned(
            left: x, top: y,
            child: pw.Text("✓", style: pw.TextStyle(font: boldTtf, fontSize: 16))
        );
    }

    // --- PAGE 1 ---
    if (bgPages.containsKey(1)) {
        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.zero,
            build: (c) => pw.Stack(children: [
                pw.FullPage(ignoreMargins: true, child: pw.Image(bgPages[1]!, fit: pw.BoxFit.fill)),
                if (form.applicantPhotoPath != null)
                    pw.Positioned(
                        left: 440, top: 110,
                        child: pw.Container(width: 90, height: 100, child: pw.Image(pw.MemoryImage(File(form.applicantPhotoPath!).readAsBytesSync()), fit: pw.BoxFit.cover))
                    ),
                positionedText(form.applicantNameBangla, 140, 248, width: 250, size: 12),
                positionedText(form.applicantNameEnglish, 140, 268, width: 250, size: 12),
                positionedText(form.nidNumber, 140, 312, width: 150, size: 12),
                positionedText(form.dob, 410, 312, width: 100, size: 12),
                positionedText(form.fatherName, 140, 335, width: 250, size: 12),
                positionedText(form.motherName, 140, 355, width: 250, size: 12),

                 if (form.initialDeposit.isNotEmpty) ...[
                     positionedText(form.initialDeposit, 180, 600, width: 100, size: 12),
                     positionedText(BanglaAmountConverter.convert(double.tryParse(form.initialDeposit) ?? 0), 300, 600, width: 250, size: 12),
                  ],

                 // Service Requests (Checkboxes) - Assumed Coordinates on Page 1 Bottom or Page 2 Top
                 // Placing hypothetically at bottom right of Page 1
                 if(form.requestChequeBook) positionedText("Cheque Book Requested", 400, 650, width: 100, size: 8),
                 if(form.requestSmsBanking) positionedText("SMS Banking Requested", 400, 665, width: 100, size: 8),
            ])
        ));
    }

    // --- PAGE 2 ---
     if (bgPages.containsKey(2)) {
        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.zero,
            build: (c) => pw.Stack(children: [
                pw.FullPage(ignoreMargins: true, child: pw.Image(bgPages[2]!, fit: pw.BoxFit.fill)),
                positionedText(form.presentAddress.roadNo + ", " + form.presentAddress.village, 160, 105, width: 350, size: 10, maxLines: 2),
                positionedText(form.presentAddress.postOffice, 160, 128, width: 150, size: 10),
                positionedText(form.presentAddress.postCode, 420, 128, width: 80, size: 10),
                positionedText(form.presentAddress.policeStation, 160, 148, width: 150, size: 10),
                positionedText(form.presentAddress.district, 420, 148, width: 100, size: 10),
                positionedText(form.permanentAddress.roadNo + ", " + form.permanentAddress.village, 160, 245, width: 350, size: 10, maxLines: 2),
                positionedText(form.permanentAddress.postOffice, 160, 268, width: 150, size: 10),
                positionedText(form.permanentAddress.postCode, 420, 268, width: 80, size: 10),
                positionedText(form.permanentAddress.policeStation, 160, 288, width: 150, size: 10),
                positionedText(form.permanentAddress.district, 420, 288, width: 100, size: 10),
                positionedText(form.mobileNumber, 160, 400, width: 150, size: 12),
            ])
        ));
     }

    // --- PAGE 3 ---
    if (bgPages.containsKey(3)) {
        pdf.addPage(pw.Page(
             pageFormat: PdfPageFormat.a4, margin: pw.EdgeInsets.zero,
             build: (c) => pw.Stack(children: [
                 pw.FullPage(ignoreMargins: true, child: pw.Image(bgPages[3]!, fit: pw.BoxFit.fill)),
                 positionedText(form.occupation, 160, 105, width: 300, size: 12),
                 positionedText(form.monthlyIncome, 160, 128, width: 200, size: 12),

                 // FATCA Section (Usually Page 3 or 4) - Hypothetical Coordinates
                 if (form.isUSCitizen) ...[
                    positionedCheckbox(true, 150, 500), // Check "Yes" box
                    positionedText(form.tinForeign, 200, 520, width: 150, size: 10),
                    positionedText(form.residencyAddress, 200, 540, width: 300, size: 10),
                 ] else ...[
                    positionedCheckbox(true, 250, 500), // Check "No" box
                 ],

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
                    // Percentage
                    positionedText("${nominee.percentage}%", 450, 204, width: 50, size: 12),

                    if (nominee.photoPath.isNotEmpty)
                        pw.Positioned(
                            left: 440, top: 90,
                            child: pw.Container(width: 90, height: 100, child: pw.Image(pw.MemoryImage(File(nominee.photoPath).readAsBytesSync()), fit: pw.BoxFit.cover))
                        ),
                ]);
             }
        ));
    }

    // --- PAGE 5 ---
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

    // Remaining Pages
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
                        stackChildren.add(positionedText("${form.riskScore}", 310, 595, width: 50, size: 14, isBold: true));
                        stackChildren.add(positionedText(form.riskRating, 310, 625, width: 100, size: 14, isBold: true));
                    }
                    if (i == 8) {
                        stackChildren.add(positionedText(form.beneficialOwnerName, 160, 160, width: 250, size: 12));
                        stackChildren.add(positionedText(form.beneficialOwnerRelation, 160, 180, width: 150, size: 12));
                        stackChildren.add(positionedText(form.beneficialOwnerDob, 410, 180, width: 100, size: 12));
                        stackChildren.add(positionedText(form.beneficialOwnerNid, 160, 200, width: 200, size: 12));
                    }

                    // Signature on Terms Pages (usually Page 11)
                    if (i == 11 && form.applicantSignaturePath != null && form.applicantSignaturePath!.isNotEmpty) {
                         // Bottom Right Signature Block
                         stackChildren.add(
                             pw.Positioned(
                                 left: 400, top: 700,
                                 child: pw.Container(
                                     width: 120, height: 60,
                                     child: pw.Image(pw.MemoryImage(File(form.applicantSignaturePath!).readAsBytesSync()), fit: pw.BoxFit.contain)
                                 )
                             )
                         );
                    }

                    return pw.Stack(children: stackChildren);
                }
            ));
        }
    }

    return pdf.save();
  }
}
