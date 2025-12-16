import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/application_form.dart';

class LocalStorageService {
  static const String _keyForm = 'saved_application_form';

  Future<void> saveForm(ApplicationForm form) async {
    final prefs = await SharedPreferences.getInstance();
    // ApplicationForm needs toJson() to be implemented
    String jsonString = jsonEncode(form.toJson());
    await prefs.setString(_keyForm, jsonString);
  }

  Future<ApplicationForm?> loadForm() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_keyForm);
    if (jsonString != null) {
        try {
            return ApplicationForm.fromJson(jsonDecode(jsonString));
        } catch (e) {
            print("Error loading form: $e");
            return null;
        }
    }
    return null;
  }

  Future<void> clearForm() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyForm);
  }
}
