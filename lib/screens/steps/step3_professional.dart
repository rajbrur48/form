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
          Text("পেশা ও পরিচয়দানকারী", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 10),

          TextFormField(
            initialValue: form.occupation,
            decoration: InputDecoration(labelText: "পেশা"),
            onChanged: (v) => notifier.updateField(form.copyWith(occupation: v)),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: form.monthlyIncome,
            decoration: InputDecoration(labelText: "মাসিক আয়"),
            onChanged: (v) => notifier.updateField(form.copyWith(monthlyIncome: v)),
          ),

          SizedBox(height: 20),
          Text("পরিচয়দানকারীর তথ্য", style: Theme.of(context).textTheme.titleMedium),
          SizedBox(height: 10),

          TextFormField(
            initialValue: form.introducerName,
            decoration: InputDecoration(labelText: "পরিচয়দানকারীর নাম"),
            onChanged: (v) => notifier.updateField(form.copyWith(introducerName: v)),
          ),
           SizedBox(height: 10),
          TextFormField(
            initialValue: form.introducerAccountNo,
            decoration: InputDecoration(labelText: "হিসাব নম্বর"),
            onChanged: (v) => notifier.updateField(form.copyWith(introducerAccountNo: v)),
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
