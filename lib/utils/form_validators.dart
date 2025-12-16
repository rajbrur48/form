
class FormValidators {
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateNID(String? value) {
    if (value == null || value.isEmpty) return 'NID is required';
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'NID must contain only digits';
    if (value.length != 10 && value.length != 13 && value.length != 17) {
      return 'NID must be 10, 13, or 17 digits';
    }
    return null;
  }

  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) return 'Mobile number is required';
    if (!RegExp(r'^01\d{9}$').hasMatch(value)) {
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
}
