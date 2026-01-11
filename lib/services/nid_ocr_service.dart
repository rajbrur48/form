import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/application_form.dart'; // For Address model

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

  Future<Address> processNidBack(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    print("OCR Back Text: $text");

    // Parse using the granular logic
    return _parseAddress(text);
  }

  Address _parseAddress(String text) {
    // Expected structure based on NID.jpg:
    // ঠিকানা: বাসা/হোল্ডিং: <val>, গ্রাম/রাস্তা: <val>, ডাকঘর: <val> - <code >, <thana>, <dist/muni>, <dist>

    // Normalize text (remove newlines, extra spaces)
    String cleanText = text.replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ');

    String house = '';
    String village = '';
    String postOffice = '';
    String postCode = '';
    String thana = '';
    String district = '';

    // Extract House/Holding
    // "বাসা/হোল্ডিং:"
    RegExp houseExp = RegExp(r'বাসা/হোল্ডিং:\s*(.*?),?\s*গ্রাম/রাস্তা:');
    var houseMatch = houseExp.firstMatch(cleanText);
    if (houseMatch != null) {
      house = houseMatch.group(1)!.trim();
    }

    // Extract Village/Road
    // "গ্রাম/রাস্তা:" until "ডাকঘর:"
    RegExp villageExp = RegExp(r'গ্রাম/রাস্তা:\s*(.*?),?\s*ডাকঘর:');
    var villageMatch = villageExp.firstMatch(cleanText);
    if (villageMatch != null) {
      village = villageMatch.group(1)!.trim();
    }

    // Extract Post Office and Code
    // "ডাকঘর:" until "-" or digit
    // Usually: "ডাকঘর: লালমনিরহাট সদর - ৫৫০০"
    RegExp poExp = RegExp(r'ডাকঘর:\s*(.*?)\s*-\s*(\d+|[০-৯]+)');
    var poMatch = poExp.firstMatch(cleanText);
    if (poMatch != null) {
      postOffice = poMatch.group(1)!.trim();
      postCode = poMatch.group(2)!.trim();

      // Try to find Thana and District which usually follow the postcode
      // The text after postcode is often comma separated: "..., Lalmonirhat Sadar, Lalmonirhat Pourashava, Lalmonirhat"
      // We need to look at the text *after* the postcode match.
      int endOfMatch = poMatch.end;
      if (endOfMatch < cleanText.length) {
        String remaining = cleanText.substring(endOfMatch).trim();
        // Remove leading comma if any
        if (remaining.startsWith(',')) remaining = remaining.substring(1).trim();

        List<String> parts = remaining.split(',');
        if (parts.isNotEmpty) {
            thana = parts[0].trim();
            if (parts.length > 1) {
                // If there are more parts, the last one is usually District, others might be Municipality
                district = parts.last.trim();
            } else {
                // If only one part, it might be district if thana was already covered,
                // but usually the sequence is Thana, District.
                // Let's assume the first part after PO is Thana.
            }
        }
      }
    } else {
        // Fallback: simple split if regex fails
    }

    return Address(
        flatNo: house,
        roadNo: '', // NID doesn't always distinguish road number from village/road field
        village: village,
        postOffice: postOffice,
        postCode: postCode,
        policeStation: thana,
        district: district,
    );
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
