import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';
import '../components/form_components.dart';
import '../../utils/form_validators.dart';

class AdditionalServicesStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AdditionalServicesStep({
    Key? key,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);

    // Helpers to update specific booleans safely
    void updateForm(ApplicationForm newForm) {
      notifier.updateField(newForm);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Additional Services ---
          SectionCard(
            title: "অতিরিক্ত সেবাসমূহ (Additional Services)",
            child: Column(
              children: [
                CheckboxListTile(
                  title: Text("চেক বই (Cheque Book)"),
                  subtitle: Text("আমি একটি চেক বইয়ের আবেদন করছি"),
                  value: form.requestChequeBook,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (v) => updateForm(form.copyWith(requestChequeBook: v)),
                ),
                Divider(),
                CheckboxListTile(
                  title: Text("SMS ব্যাংকিং"),
                  subtitle: Text("লেনদেনের সতর্কতা মোবাইলে পেতে চাই"),
                  value: form.requestSmsBanking,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (v) => updateForm(form.copyWith(requestSmsBanking: v)),
                ),
                Divider(),
                CheckboxListTile(
                  title: Text("ইন্টারনেট ব্যাংকিং"),
                  subtitle: Text("অ্যাপ এবং ওয়েবে লেনদেন করতে চাই"),
                  value: form.requestInternetBanking,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (v) => updateForm(form.copyWith(requestInternetBanking: v)),
                ),
              ],
            ),
          ),

          // --- FATCA Declaration ---
          SectionCard(
            title: "FATCA ঘোষণা (Tax Residency)",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "আপনি কি মার্কিন যুক্তরাষ্ট্রের নাগরিক বা করদাতার (Tax Resident) আওতাভুক্ত?",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text("না (No)"),
                        value: false,
                        groupValue: form.isUSCitizen,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (v) => updateForm(form.copyWith(isUSCitizen: v)),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text("হ্যাঁ (Yes)"),
                        value: true,
                        groupValue: form.isUSCitizen,
                        activeColor: Theme.of(context).primaryColor,
                        onChanged: (v) => updateForm(form.copyWith(isUSCitizen: v)),
                      ),
                    ),
                  ],
                ),
                if (form.isUSCitizen) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      border: Border.all(color: Colors.orange.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "মার্কিন নাগরিকদের জন্য অতিরিক্ত তথ্য প্রয়োজন:",
                          style: TextStyle(
                              color: Colors.orange.shade900, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        CustomTextField(
                          label: "SSN / TIN (Foreign)",
                          initialValue: form.tinForeign,
                          validator: (v) => form.isUSCitizen
                              ? FormValidators.validateRequired(v, fieldName: 'TIN/SSN')
                              : null,
                          onChanged: (v) => updateForm(form.copyWith(tinForeign: v)),
                        ),
                        CustomTextField(
                          label: "বিদেশে বসবাসের ঠিকানা (Foreign Address)",
                          initialValue: form.residencyAddress,
                          maxLines: 2,
                          validator: (v) => form.isUSCitizen
                              ? FormValidators.validateRequired(v, fieldName: 'Foreign Address')
                              : null,
                          onChanged: (v) => updateForm(form.copyWith(residencyAddress: v)),
                        ),
                      ],
                    ),
                  )
                ]
              ],
            ),
          ),

          StepNavigationButtons(
            onBack: onBack,
            onNext: () {
               // Add simple validation if needed, mostly handled by state
               onNext();
            },
          ),
        ],
      ),
    );
  }
}
