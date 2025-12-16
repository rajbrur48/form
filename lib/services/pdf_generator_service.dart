import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/application_form.dart';

class PdfGeneratorService {
  Future<Uint8List> generatePdf(ApplicationForm form) async {
    final pdf = pw.Document();

    // Load Font
    final fontData = await rootBundle.load("assets/fonts/NotoSansBengali-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);
    final boldFontData = await rootBundle.load("assets/fonts/NotoSansBengali-Bold.ttf");
    final boldTtf = pw.Font.ttf(boldFontData);

    // Helper for Bangla Text
    pw.Widget banglaText(String text, {double size = 10, bool isBold = false}) {
      return pw.Text(
        text,
        style: pw.TextStyle(
          font: isBold ? boldTtf : ttf,
          fontSize: size,
        ),
        textDirection: pw.TextDirection.ltr, // pdf package handles unicode well usually, but check direction
      );
    }

    // Page 1: Personal Information
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, child: banglaText("ব্যাংক হিসাব খোলার আবেদন ফর্ম", size: 18, isBold: true)),

              pw.SizedBox(height: 20),

              // Photos Row
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                    width: 100,
                    height: 120,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                    child: form.applicantPhotoPath != null
                        ? pw.Image(pw.MemoryImage(File(form.applicantPhotoPath!).readAsBytesSync()))
                        : pw.Center(child: banglaText("আবেদনকারীর ছবি")),
                  ),
                   pw.Container(
                    width: 150,
                    height: 40,
                    decoration: pw.BoxDecoration(border: pw.Border.all()),
                     child: pw.Center(child: banglaText("Office Use Only")),
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              // Personal Info Table
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {0: pw.FlexColumnWidth(1), 1: pw.FlexColumnWidth(2)},
                children: [
                  pw.TableRow(children: [
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: banglaText("হিসাবের নাম (বাংলায়)")),
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: banglaText(form.applicantNameBangla)),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: banglaText("Account Name (English)")),
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(form.applicantNameEnglish)), // English doesn't need bangla font strictly but safe
                  ]),
                   pw.TableRow(children: [
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: banglaText("পিতার নাম")),
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: banglaText(form.fatherName)),
                  ]),
                   pw.TableRow(children: [
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: banglaText("মাতার নাম")),
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: banglaText(form.motherName)),
                  ]),
                   pw.TableRow(children: [
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: banglaText("জাতীয় পরিচয়পত্র নম্বর")),
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: banglaText(form.nidNumber)),
                  ]),
                   pw.TableRow(children: [
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: banglaText("জন্ম তারিখ")),
                    pw.Padding(padding: pw.EdgeInsets.all(4), child: banglaText(form.dob)),
                  ]),
                ],
              ),

              pw.SizedBox(height: 10),
              banglaText("Note: This is a generated replica. Full 11 pages would follow this structure."),
            ],
          );
        },
      ),
    );

    // Placeholder for other pages
    for(int i=2; i<=11; i++) {
        pdf.addPage(pw.Page(build: (c) => pw.Center(child: banglaText("Page $i Placeholder"))));
    }

    return pdf.save();
  }
}
