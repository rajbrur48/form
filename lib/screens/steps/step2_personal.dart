import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../components/form_components.dart';

class PersonalInfoStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const PersonalInfoStep(
      {Key? key, required this.onNext, required this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionCard(
            title: "মৌলিক তথ্য",
            child: Column(
              children: [
                TextFormField(
                  initialValue: form.applicantNameBangla,
                  decoration: InputDecoration(labelText: "নাম (বাংলায়)"),
                  textInputAction: TextInputAction.next,
                  onChanged: (v) =>
                      notifier.updatePersonalDetails(nameBangla: v),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: form.applicantNameEnglish,
                  decoration: InputDecoration(labelText: "নাম (ইংরেজিতে)"),
                  textInputAction: TextInputAction.next,
                  onChanged: (v) =>
                      notifier.updatePersonalDetails(nameEnglish: v),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: form.dob,
                  decoration: InputDecoration(
                    labelText: "জন্ম তারিখ",
                    hintText: "DD/MM/YYYY",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => notifier.updatePersonalDetails(dob: v),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: form.nidNumber,
                  decoration:
                      InputDecoration(labelText: "জাতীয় পরিচয়পত্র নম্বর"),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => notifier.updatePersonalDetails(nid: v),
                ),
              ],
            ),
          ),
          SectionCard(
            title: "পিতা/মাতার তথ্য",
            child: Column(
              children: [
                TextFormField(
                  initialValue: form.fatherName,
                  decoration: InputDecoration(labelText: "পিতার নাম"),
                  textInputAction: TextInputAction.next,
                  onChanged: (v) =>
                      notifier.updatePersonalDetails(fatherName: v),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: form.motherName,
                  decoration: InputDecoration(labelText: "মাতার নাম"),
                  textInputAction: TextInputAction.done,
                  onChanged: (v) =>
                      notifier.updatePersonalDetails(motherName: v),
                ),
              ],
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
