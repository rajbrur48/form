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
          Text("Beneficial Owner Information", style: Theme.of(context).textTheme.headlineSmall),
          Text("(If Applicable)", style: Theme.of(context).textTheme.bodySmall),
          SizedBox(height: 10),

          TextFormField(
            initialValue: form.beneficialOwnerName,
            decoration: InputDecoration(labelText: "Beneficial Owner Name", border: OutlineInputBorder()),
            onChanged: (v) => notifier.updateField(form.copyWith(beneficialOwnerName: v)),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: form.beneficialOwnerRelation,
            decoration: InputDecoration(labelText: "Relation with Applicant", border: OutlineInputBorder()),
            onChanged: (v) => notifier.updateField(form.copyWith(beneficialOwnerRelation: v)),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: form.beneficialOwnerDob,
            decoration: InputDecoration(labelText: "Date of Birth", border: OutlineInputBorder()),
            onChanged: (v) => notifier.updateField(form.copyWith(beneficialOwnerDob: v)),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: form.beneficialOwnerNid,
            decoration: InputDecoration(labelText: "NID Number", border: OutlineInputBorder()),
            onChanged: (v) => notifier.updateField(form.copyWith(beneficialOwnerNid: v)),
          ),

          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                ElevatedButton(onPressed: onBack, child: Text("Back")),
                ElevatedButton(onPressed: onNext, child: Text("Next")),
            ],
          )
        ],
      ),
    );
  }
}
