import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../components/form_components.dart';

class ProfessionalStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ProfessionalStep({Key? key, required this.onNext, required this.onBack})
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
            title: "পেশা ও আয়",
            child: Column(
              children: [
                TextFormField(
                  initialValue: form.occupation,
                  decoration: InputDecoration(labelText: "পেশা"),
                  textInputAction: TextInputAction.next,
                  onChanged: (v) =>
                      notifier.updateField(form.copyWith(occupation: v)),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: form.monthlyIncome,
                  decoration: InputDecoration(labelText: "মাসিক আয়"),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  onChanged: (v) =>
                      notifier.updateField(form.copyWith(monthlyIncome: v)),
                ),
              ],
            ),
          ),
          SectionCard(
            title: "পরিচয়দানকারীর তথ্য",
            child: Column(
              children: [
                TextFormField(
                  initialValue: form.introducerName,
                  decoration: InputDecoration(labelText: "পরিচয়দানকারীর নাম"),
                  textInputAction: TextInputAction.next,
                  onChanged: (v) =>
                      notifier.updateField(form.copyWith(introducerName: v)),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: form.introducerAccountNo,
                  decoration: InputDecoration(labelText: "হিসাব নম্বর"),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (v) =>
                      notifier.updateField(form.copyWith(introducerAccountNo: v)),
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
