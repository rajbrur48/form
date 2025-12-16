import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NidOcrService {
  // Bengali might not be explicitly supported in the enum for this version, falling back to default (Latin) which captures NID No, English Name, DOB.
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<ExtractedNidData> processNidFront(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    String text = recognizedText.text;
    print("OCR Raw Text: $text");

    // Simple Regex extraction logic (to be refined)
    String nameBangla = _findLineAfter(text, ['Name', 'নাম']);
    String nameEnglish = _findEnglishName(text);
    String dob = _findDob(text);
    String nidNo = _findNidNumber(text);

    // Fallback if regex fails (very common in OCR)
    if (nidNo.isEmpty) {
        // Try to find the longest sequence of digits
        final digitMatch = RegExp(r'\d{10,17}').firstMatch(text);
        if (digitMatch != null) nidNo = digitMatch.group(0)!;
    }

    return ExtractedNidData(
      nameBangla: nameBangla,
      nameEnglish: nameEnglish,
      dob: dob,
      nidNumber: nidNo,
    );
  }

  Future<String> processNidBack(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    // Usually the address is the biggest block of Bangla text on the back
    return recognizedText.text;
  }

  String _findLineAfter(String text, List<String> keywords) {
    List<String> lines = text.split('\n');
    for (int i = 0; i < lines.length; i++) {
      for (var keyword in keywords) {
        if (lines[i].contains(keyword)) {
          // Sometimes the value is on the same line, sometimes next
          String cleanLine = lines[i].replaceAll(keyword, '').trim();
          if (cleanLine.length > 2) return cleanLine;
          if (i + 1 < lines.length) return lines[i+1].trim();
        }
      }
    }
    return '';
  }

  String _findEnglishName(String text) {
    // English names in NID are usually all CAPS
    RegExp exp = RegExp(r'[A-Z .]{5,}');
    final matches = exp.allMatches(text);
    for (var m in matches) {
        String val = m.group(0)!.trim();
        if (val != "BANGLADESH" && val != "GOVERNMENT") return val;
    }
    return '';
  }

  String _findDob(String text) {
     RegExp exp = RegExp(r'\d{2} [A-Za-z]{3} \d{4}'); // 12 Oct 1990
     var match = exp.firstMatch(text);
     if (match != null) return match.group(0)!;
     return '';
  }

  String _findNidNumber(String text) {
     RegExp exp = RegExp(r'ID NO:? ?(\d+)');
     var match = exp.firstMatch(text);
     if (match != null) return match.group(1)!;
     return '';
  }

  void close() {
    _textRecognizer.close();
  }
}

class ExtractedNidData {
  final String nameBangla;
  final String nameEnglish;
  final String dob;
  final String nidNumber;

  ExtractedNidData({
    required this.nameBangla,
    required this.nameEnglish,
    required this.dob,
    required this.nidNumber,
  });
}
