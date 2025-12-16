import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../components/form_components.dart';

class BeneficialOwnerStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const BeneficialOwnerStep(
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
            title: "বেনিফিশিয়াল ওনার",
            child: Column(
              children: [
                Text(
                  "(যদি থাকে)",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: form.beneficialOwnerName,
                  decoration:
                      InputDecoration(labelText: "বেনিফিশিয়াল ওনারের নাম"),
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => notifier
                      .updateField(form.copyWith(beneficialOwnerName: v)),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: form.beneficialOwnerRelation,
                  decoration: InputDecoration(labelText: "সম্পর্ক"),
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => notifier
                      .updateField(form.copyWith(beneficialOwnerRelation: v)),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: form.beneficialOwnerDob,
                  decoration: InputDecoration(
                    labelText: "জন্ম তারিখ",
                    hintText: "DD/MM/YYYY",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  onChanged: (v) => notifier
                      .updateField(form.copyWith(beneficialOwnerDob: v)),
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: form.beneficialOwnerNid,
                  decoration:
                      InputDecoration(labelText: "জাতীয় পরিচয়পত্র নম্বর"),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onChanged: (v) => notifier
                      .updateField(form.copyWith(beneficialOwnerNid: v)),
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
