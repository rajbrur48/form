import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';
import '../camera_screen.dart';
import '../components/form_components.dart';
import 'dart:io';

class NomineeStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const NomineeStep({Key? key, required this.onNext, required this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);
    final nominee =
        form.nominees.isNotEmpty ? form.nominees[0] : Nominee.empty();

    // I will stick to manual copy since I didn't add copyWith for Nominee
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
                _updateNominee(Nominee(
                    name: nominee.name,
                    relation: nominee.relation,
                    dob: nominee.dob,
                    nidNumber: nominee.nidNumber,
                    photoPath: file.path,
                    signaturePath: nominee.signaturePath));
              },
            ),
          ));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionCard(
            title: "নমিনির বিবরণ",
            child: Column(
              children: [
                TextFormField(
                  initialValue: nominee.name,
                  decoration: InputDecoration(labelText: "নমিনির নাম"),
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => _updateNominee(Nominee(
                      name: v,
                      relation: nominee.relation,
                      dob: nominee.dob,
                      nidNumber: nominee.nidNumber,
                      photoPath: nominee.photoPath,
                      signaturePath: nominee.signaturePath)),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: nominee.relation,
                  decoration: InputDecoration(labelText: "সম্পর্ক"),
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => _updateNominee(Nominee(
                      name: nominee.name,
                      relation: v,
                      dob: nominee.dob,
                      nidNumber: nominee.nidNumber,
                      photoPath: nominee.photoPath,
                      signaturePath: nominee.signaturePath)),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: nominee.dob,
                  decoration: InputDecoration(
                    labelText: "জন্ম তারিখ",
                    hintText: "DD/MM/YYYY",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => _updateNominee(Nominee(
                      name: nominee.name,
                      relation: nominee.relation,
                      dob: v,
                      nidNumber: nominee.nidNumber,
                      photoPath: nominee.photoPath,
                      signaturePath: nominee.signaturePath)),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: nominee.nidNumber,
                  decoration:
                      InputDecoration(labelText: "জাতীয় পরিচয়পত্র নম্বর"),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (v) => _updateNominee(Nominee(
                      name: nominee.name,
                      relation: nominee.relation,
                      dob: nominee.dob,
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
                  color: Colors.grey.shade50,
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
            onNext: onNext,
          ),
        ],
      ),
    );
  }
}
