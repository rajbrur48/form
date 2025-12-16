import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';

class BeneficialOwnerStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const BeneficialOwnerStep({Key? key, required this.onNext, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("বেনিফিশিয়াল ওনার তথ্য", style: Theme.of(context).textTheme.headlineSmall),
          Text("(যদি থাকে)", style: Theme.of(context).textTheme.bodySmall),
          SizedBox(height: 10),

          TextFormField(
            initialValue: form.beneficialOwnerName,
            decoration: InputDecoration(labelText: "বেনিফিশিয়াল ওনারের নাম"),
            onChanged: (v) => notifier.updateField(form.copyWith(beneficialOwnerName: v)),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: form.beneficialOwnerRelation,
            decoration: InputDecoration(labelText: "সম্পর্ক"),
            onChanged: (v) => notifier.updateField(form.copyWith(beneficialOwnerRelation: v)),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: form.beneficialOwnerDob,
            decoration: InputDecoration(labelText: "জন্ম তারিখ", hintText: "DD/MM/YYYY"),
            onChanged: (v) => notifier.updateField(form.copyWith(beneficialOwnerDob: v)),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: form.beneficialOwnerNid,
            decoration: InputDecoration(labelText: "জাতীয় পরিচয়পত্র নম্বর"),
            onChanged: (v) => notifier.updateField(form.copyWith(beneficialOwnerNid: v)),
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
