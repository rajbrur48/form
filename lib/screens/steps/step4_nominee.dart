import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';
import '../camera_screen.dart';
import '../components/form_components.dart';
import '../../utils/form_validators.dart';
import 'dart:io';

class NomineeStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NomineeStep({Key? key, required this.onNext, required this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);

    // We handle a list of nominees, but for this simplified flow we default to one.
    // However, if we want to allow adding multiple, we would map over form.nominees
    // For now, let's keep it strictly single nominee but robust with Percentage.

    final nominee = form.nominees.isNotEmpty ? form.nominees[0] : Nominee.empty();

    void _updateNominee(Nominee n) {
      notifier.updateNominee(0, n);
    }

    void _takePhoto() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => CameraScreen(
              label: "Nominee Photo",
              onImageCaptured: (file) {
                // Manual copy logic as before
                _updateNominee(Nominee(
                    name: nominee.name,
                    relation: nominee.relation,
                    dob: nominee.dob,
                    percentage: nominee.percentage,
                    nidNumber: nominee.nidNumber,
                    photoPath: file.path,
                    signaturePath: nominee.signaturePath));
              },
            ),
          ));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Share Calculation Header
            Card(
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              elevation: 0,
              margin: EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("মোট অংশ (Total Share)", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("100%", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 18)),
                  ],
                ),
              ),
            ),

            SectionCard(
              title: "নমিনির বিবরণ",
              child: Column(
                children: [
                  CustomTextField(
                    label: "নমিনির নাম",
                    initialValue: nominee.name,
                    validator: (v) => FormValidators.validateRequired(v, fieldName: 'Nominee Name'),
                    onChanged: (v) => _updateNominee(Nominee(
                        name: v,
                        relation: nominee.relation,
                        dob: nominee.dob,
                        percentage: nominee.percentage,
                        nidNumber: nominee.nidNumber,
                        photoPath: nominee.photoPath,
                        signaturePath: nominee.signaturePath)),
                  ),
                  CustomTextField(
                    label: "সম্পর্ক",
                    initialValue: nominee.relation,
                    validator: (v) => FormValidators.validateRequired(v, fieldName: 'Relation'),
                    onChanged: (v) => _updateNominee(Nominee(
                        name: nominee.name,
                        relation: v,
                        dob: nominee.dob,
                        percentage: nominee.percentage,
                        nidNumber: nominee.nidNumber,
                        photoPath: nominee.photoPath,
                        signaturePath: nominee.signaturePath)),
                  ),

                  // Share Percentage Field
                  CustomTextField(
                    label: "অংশ (%)",
                    initialValue: nominee.percentage,
                    keyboardType: TextInputType.number,
                    validator: (v) {
                       if (v == null || v.isEmpty) return "Required";
                       final n = double.tryParse(v);
                       if (n == null || n <= 0 || n > 100) return "Must be 1-100";
                       return null;
                    },
                    onChanged: (v) => _updateNominee(Nominee(
                        name: nominee.name,
                        relation: nominee.relation,
                        dob: nominee.dob,
                        percentage: v,
                        nidNumber: nominee.nidNumber,
                        photoPath: nominee.photoPath,
                        signaturePath: nominee.signaturePath)),
                  ),

                  CustomTextField(
                    label: "জন্ম তারিখ (DD/MM/YYYY)",
                    initialValue: nominee.dob,
                    keyboardType: TextInputType.datetime,
                    validator: (v) => FormValidators.validateRequired(v, fieldName: 'DOB'),
                    onChanged: (v) => _updateNominee(Nominee(
                        name: nominee.name,
                        relation: nominee.relation,
                        dob: v,
                        percentage: nominee.percentage,
                        nidNumber: nominee.nidNumber,
                        photoPath: nominee.photoPath,
                        signaturePath: nominee.signaturePath)),
                  ),
                  CustomTextField(
                    label: "জাতীয় পরিচয়পত্র নম্বর",
                    initialValue: nominee.nidNumber,
                    keyboardType: TextInputType.number,
                    validator: FormValidators.validateNID,
                    onChanged: (v) => _updateNominee(Nominee(
                        name: nominee.name,
                        relation: nominee.relation,
                        dob: nominee.dob,
                        percentage: nominee.percentage,
                        nidNumber: v,
                        photoPath: nominee.photoPath,
                        signaturePath: nominee.signaturePath)),
                  ),
                ],
              ),
            ),

            SectionCard(
              title: "নমিনির ছবি",
              child: InkWell(
                onTap: _takePhoto,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: nominee.photoPath.isNotEmpty
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                      width: nominee.photoPath.isNotEmpty ? 2 : 1,
                    ),
                  ),
                  child: nominee.photoPath.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(File(nominee.photoPath),
                              fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined,
                                size: 40, color: Theme.of(context).primaryColor),
                            SizedBox(height: 12),
                            Text(
                              "ছবি সংযুক্ত করুন",
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            StepNavigationButtons(
              onBack: onBack,
              onNext: () {
                 if (_formKey.currentState!.validate()) {
                     onNext();
                 } else {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fix validaton errors.")));
                 }
              },
            ),
          ],
        ),
      ),
    );
  }
}
