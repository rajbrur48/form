import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/application_form.dart';
import '../utils/mock_data.dart';
import '../utils/risk_calculator.dart';
import '../utils/local_storage_service.dart';

class FormNotifier extends StateNotifier<ApplicationForm> {
  final LocalStorageService _storageService = LocalStorageService();

  FormNotifier() : super(ApplicationForm.empty()) {
    _loadSavedForm();
  }

  Future<void> _loadSavedForm() async {
    final savedForm = await _storageService.loadForm();
    if (savedForm != null) {
      state = savedForm;
    }
  }

  Future<void> _saveState() async {
    await _storageService.saveForm(state);
  }

  void updatePersonalDetails({
    String? nameBangla,
    String? nameEnglish,
    String? fatherName,
    String? motherName,
    String? dob,
    String? nid,
  }) {
    state = state.copyWith(
      applicantNameBangla: nameBangla,
      applicantNameEnglish: nameEnglish,
      fatherName: fatherName,
      motherName: motherName,
      dob: dob,
      nidNumber: nid,
    );
    _calculateRisk();
    _saveState();
  }

  void updateAddress({
    required bool isPermanent,
    String? flatNo,
    String? roadNo,
    String? village,
    String? postOffice,
    String? policeStation,
    String? district,
    String? postCode,
  }) {
    final currentAddress = isPermanent ? state.permanentAddress : state.presentAddress;

    final newAddress = currentAddress.copyWith(
      flatNo: flatNo,
      roadNo: roadNo,
      village: village,
      postOffice: postOffice,
      policeStation: policeStation,
      district: district,
      postCode: postCode,
    );

    state = state.copyWith(
      permanentAddress: isPermanent ? newAddress : state.permanentAddress,
      presentAddress: !isPermanent ? newAddress : state.presentAddress,
    );
    _saveState();
  }

  void updateField(ApplicationForm updatedForm) {
      state = updatedForm;
      _calculateRisk();
      _saveState();
  }

  void updateNominee(int index, Nominee nominee) {
      List<Nominee> newNominees = [...state.nominees];
      if (index < newNominees.length) {
          newNominees[index] = nominee;
          state = state.copyWith(nominees: newNominees);
          _saveState();
      }
  }

  void setImages({String? nidFront, String? nidBack, String? applicantPhoto}) {
    state = state.copyWith(
      nidFrontPath: nidFront,
      nidBackPath: nidBack,
      applicantPhotoPath: applicantPhoto,
    );
    _saveState();
  }

  void _calculateRisk() {
    final score = RiskCalculator.calculateRiskScore(state);
    final rating = RiskCalculator.getRiskRating(score);
    state = state.copyWith(
      riskScore: score,
      riskRating: rating,
    );
  }

  Future<void> clearForm() async {
    await _storageService.clearForm();
    state = ApplicationForm.empty();
  }
}

final formProvider = StateNotifierProvider<FormNotifier, ApplicationForm>((ref) {
  return FormNotifier();
});
