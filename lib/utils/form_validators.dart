
class FormValidators {
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateNID(String? value) {
    if (value == null || value.isEmpty) return 'NID is required';
    // Remove any dashes or spaces
    final cleanValue = value.replaceAll(RegExp(r'[\s-]'), '');
    if (!RegExp(r'^\d+$').hasMatch(cleanValue)) return 'NID must contain only digits';

    if (cleanValue.length != 10 && cleanValue.length != 13 && cleanValue.length != 17) {
      return 'NID must be 10, 13, or 17 digits';
    }
    return null;
  }

  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) return 'Mobile number is required';
    final cleanValue = value.replaceAll(RegExp(r'[\s-]'), '');
    if (!RegExp(r'^01\d{9}$').hasMatch(cleanValue)) {
      return 'Invalid mobile number (must start with 01 and be 11 digits)';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return null; // Email often optional
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? validateBangla(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) return null; // Let required check handle empty
    // Unicode range for Bengali: \u0980-\u09FF
    // We also allow spaces, dots, dashes for names.
    final banglaRegex = RegExp(r'^[\u0980-\u09FF\s\.\-]+$');
    if (!banglaRegex.hasMatch(value)) {
      return '$fieldName must contain only Bangla characters';
    }
    return null;
  }

  static String? validateEnglish(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.isEmpty) return null;
    final englishRegex = RegExp(r'^[a-zA-Z\s\.\-]+$');
    if (!englishRegex.hasMatch(value)) {
      return '$fieldName must contain only English characters';
    }
    return null;
  }
}
