import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/application_form.dart';

class FormNotifier extends StateNotifier<ApplicationForm> {
  FormNotifier() : super(ApplicationForm.empty());

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
  }

  void updateAddress({
    required bool isPermanent,
    String? village,
    String? postOffice,
    String? policeStation,
    String? district,
    String? postCode,
  }) {
    final newAddress = Address(
      village: village ?? (isPermanent ? state.permanentAddress.village : state.presentAddress.village),
      postOffice: postOffice ?? (isPermanent ? state.permanentAddress.postOffice : state.presentAddress.postOffice),
      policeStation: policeStation ?? (isPermanent ? state.permanentAddress.policeStation : state.presentAddress.policeStation),
      district: district ?? (isPermanent ? state.permanentAddress.district : state.presentAddress.district),
      postCode: postCode ?? (isPermanent ? state.permanentAddress.postCode : state.presentAddress.postCode),
    );

    state = state.copyWith(
      permanentAddress: isPermanent ? newAddress : null,
      presentAddress: !isPermanent ? newAddress : null,
    );
  }

  void updateField(ApplicationForm updatedForm) {
      state = updatedForm;
  }

  void updateNominee(int index, Nominee nominee) {
      List<Nominee> newNominees = [...state.nominees];
      if (index < newNominees.length) {
          newNominees[index] = nominee;
          state = state.copyWith(nominees: newNominees);
      }
  }

  void setImages({String? nidFront, String? nidBack, String? applicantPhoto}) {
    state = state.copyWith(
      nidFrontPath: nidFront,
      nidBackPath: nidBack,
      applicantPhotoPath: applicantPhoto,
    );
  }
}

final formProvider = StateNotifierProvider<FormNotifier, ApplicationForm>((ref) {
  return FormNotifier();
});
