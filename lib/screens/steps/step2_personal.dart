import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';

class PersonalInfoStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const PersonalInfoStep({Key? key, required this.onNext, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("ব্যক্তিগত তথ্য", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 10),

          TextFormField(
            initialValue: form.applicantNameBangla,
            decoration: InputDecoration(labelText: "নাম (বাংলায়)"),
            onChanged: (v) => notifier.updatePersonalDetails(nameBangla: v),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: form.applicantNameEnglish,
            decoration: InputDecoration(labelText: "নাম (ইংরেজিতে)"),
            onChanged: (v) => notifier.updatePersonalDetails(nameEnglish: v),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: form.dob,
            decoration: InputDecoration(labelText: "জন্ম তারিখ", hintText: "DD/MM/YYYY"),
            onChanged: (v) => notifier.updatePersonalDetails(dob: v),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: form.fatherName,
            decoration: InputDecoration(labelText: "পিতার নাম"),
            onChanged: (v) => notifier.updatePersonalDetails(fatherName: v),
          ),
           SizedBox(height: 10),
          TextFormField(
            initialValue: form.motherName,
            decoration: InputDecoration(labelText: "মাতার নাম"),
            onChanged: (v) => notifier.updatePersonalDetails(motherName: v),
          ),
           SizedBox(height: 10),
          TextFormField(
            initialValue: form.nidNumber,
            decoration: InputDecoration(labelText: "জাতীয় পরিচয়পত্র নম্বর"),
            onChanged: (v) => notifier.updatePersonalDetails(nid: v),
          ),

          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                OutlinedButton(onPressed: onBack, child: Text("পেছনে")),
                ElevatedButton(onPressed: onNext, child: Text("পরবর্তী")),
            ],
          )
        ],
      ),
    );
  }
}
