import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';

class ProfessionalStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ProfessionalStep({Key? key, required this.onNext, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Professional & Introducer Info", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 10),

          TextFormField(
            initialValue: form.occupation,
            decoration: InputDecoration(labelText: "Occupation", border: OutlineInputBorder()),
            onChanged: (v) => notifier.updateField(form.copyWith(occupation: v)),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: form.monthlyIncome,
            decoration: InputDecoration(labelText: "Monthly Income", border: OutlineInputBorder()),
            onChanged: (v) => notifier.updateField(form.copyWith(monthlyIncome: v)),
          ),

          SizedBox(height: 20),
          Text("Introducer Information", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),

          TextFormField(
            initialValue: form.introducerName,
            decoration: InputDecoration(labelText: "Introducer Name", border: OutlineInputBorder()),
            onChanged: (v) => notifier.updateField(form.copyWith(introducerName: v)),
          ),
           SizedBox(height: 10),
          TextFormField(
            initialValue: form.introducerAccountNo,
            decoration: InputDecoration(labelText: "Introducer Account No", border: OutlineInputBorder()),
            onChanged: (v) => notifier.updateField(form.copyWith(introducerAccountNo: v)),
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
