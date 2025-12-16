import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../components/form_components.dart';
import '../../utils/form_validators.dart';

class PersonalInfoStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PersonalInfoStep(
      {Key? key, required this.onNext, required this.onBack})
      : super(key: key);

  Future<void> _selectDate(BuildContext context, WidgetRef ref, String initialDate, Function(String) onDateSelected) async {
      DateTime initial = DateTime.now();
      if (initialDate.isNotEmpty) {
          try {
              final parts = initialDate.split('/');
              if (parts.length == 3) {
                  initial = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
              }
          } catch (_) {}
      }

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).primaryColor,
              ),
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
          final formatted = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
          onDateSelected(formatted);
      }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionCard(
              title: "মৌলিক তথ্য",
              child: Column(
                children: [
                  CustomTextField(
                    label: "নাম (বাংলায়)",
                    initialValue: form.applicantNameBangla,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                       final req = FormValidators.validateRequired(v, fieldName: 'Bangla Name');
                       if (req != null) return req;
                       return FormValidators.validateBangla(v);
                    },
                    onChanged: (v) => notifier.updatePersonalDetails(nameBangla: v),
                  ),

                  CustomTextField(
                    label: "নাম (ইংরেজিতে)",
                    initialValue: form.applicantNameEnglish,
                    textInputAction: TextInputAction.next,
                    validator: (v) {
                       final req = FormValidators.validateRequired(v, fieldName: 'English Name');
                       if (req != null) return req;
                       return FormValidators.validateEnglish(v);
                    },
                    onChanged: (v) => notifier.updatePersonalDetails(nameEnglish: v),
                  ),

                  // Date Picker Field (Custom Implementation matching CustomTextField style)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () => _selectDate(context, ref, form.dob, (date) {
                           notifier.updatePersonalDetails(dob: date);
                      }),
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: TextEditingController(text: form.dob),
                          decoration: InputDecoration(
                            labelText: "জন্ম তারিখ",
                            hintText: "DD/MM/YYYY",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            suffixIcon: Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                          ),
                          validator: (v) => FormValidators.validateRequired(v, fieldName: 'Date of Birth'),
                        ),
                      ),
                    ),
                  ),

                  CustomTextField(
                    label: "জাতীয় পরিচয়পত্র নম্বর",
                    initialValue: form.nidNumber,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: FormValidators.validateNID,
                    onChanged: (v) => notifier.updatePersonalDetails(nid: v),
                  ),
                ],
              ),
            ),
            SectionCard(
              title: "পিতা/মাতার তথ্য",
              child: Column(
                children: [
                  CustomTextField(
                    label: "পিতার নাম",
                    initialValue: form.fatherName,
                    textInputAction: TextInputAction.next,
                    validator: (v) => FormValidators.validateRequired(v, fieldName: "Father's Name"),
                    onChanged: (v) => notifier.updatePersonalDetails(fatherName: v),
                  ),
                  CustomTextField(
                    label: "মাতার নাম",
                    initialValue: form.motherName,
                    textInputAction: TextInputAction.done,
                    validator: (v) => FormValidators.validateRequired(v, fieldName: "Mother's Name"),
                    onChanged: (v) => notifier.updatePersonalDetails(motherName: v),
                  ),
                ],
              ),
            ),
            StepNavigationButtons(
              onBack: onBack,
              onNext: () {
                if (_formKey.currentState!.validate()) {
                  onNext();
                } else {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                       content: Text("অনুগ্রহ করে উপরের ভুলগুলো সংশোধন করুন"),
                       backgroundColor: Theme.of(context).colorScheme.error,
                     )
                   );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
