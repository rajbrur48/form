import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';
import '../components/form_components.dart';
import '../../utils/form_validators.dart';
import '../../utils/location_data.dart';

class AddressStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddressStep({Key? key, required this.onNext, required this.onBack})
      : super(key: key);

  Widget _buildAddressForm(BuildContext context, String title, Address address,
      Function(Address) onUpdate) {

    // Helper to get dropdown items
    List<DropdownMenuItem<String>> getItems(List<String> items) {
      return items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();
    }

    return SectionCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            label: "ফ্ল্যাট / বাড়ি নং",
            initialValue: address.flatNo,
            onChanged: (v) => onUpdate(address.copyWith(flatNo: v)),
          ),
          CustomTextField(
            label: "রাস্তা / ব্লক / সেক্টর",
            initialValue: address.roadNo,
            onChanged: (v) => onUpdate(address.copyWith(roadNo: v)),
          ),
          CustomTextField(
            label: "গ্রাম / এলাকা",
            initialValue: address.village,
            validator: (v) => FormValidators.validateRequired(v, fieldName: 'Village/Area'),
            onChanged: (v) => onUpdate(address.copyWith(village: v)),
          ),

          Row(children: [
            Expanded(
                child: CustomTextField(
                  label: "ডাকঘর",
                  initialValue: address.postOffice,
                  validator: (v) => FormValidators.validateRequired(v, fieldName: 'Post Office'),
                  onChanged: (v) => onUpdate(address.copyWith(postOffice: v)),
                ),
            ),
            SizedBox(width: 16),
            Expanded(
                child: CustomTextField(
                  label: "পোস্ট কোড",
                  initialValue: address.postCode,
                  keyboardType: TextInputType.number,
                  validator: (v) => FormValidators.validateRequired(v, fieldName: 'Post Code'),
                  onChanged: (v) => onUpdate(address.copyWith(postCode: v)),
                ),
            ),
          ]),

          // --- SMART LOCATION PICKER ---
          // Division
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "বিভাগ (Division)"),
            value: LocationData.getDivisions().contains(address.division) ? address.division : null,
            items: getItems(LocationData.getDivisions()),
            onChanged: (val) {
              if (val != null) {
                // Reset District and Thana when Division changes
                onUpdate(address.copyWith(division: val, district: '', policeStation: ''));
              }
            },
            validator: (v) => FormValidators.validateRequired(v, fieldName: 'Division'),
          ),
          SizedBox(height: 16),

          // District
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "জেলা (District)"),
            value: LocationData.getDistricts(address.division).contains(address.district) ? address.district : null,
            items: getItems(LocationData.getDistricts(address.division)),
            onChanged: address.division.isNotEmpty ? (val) {
              if (val != null) {
                // Reset Thana when District changes
                onUpdate(address.copyWith(district: val, policeStation: ''));
              }
            } : null, // Disable if division not selected
            validator: (v) => FormValidators.validateRequired(v, fieldName: 'District'),
          ),
          SizedBox(height: 16),

          // Thana
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "থানা (Thana)"),
            value: LocationData.getThanas(address.division, address.district).contains(address.policeStation) ? address.policeStation : null,
            items: getItems(LocationData.getThanas(address.division, address.district)),
            onChanged: address.district.isNotEmpty ? (val) {
              if (val != null) {
                onUpdate(address.copyWith(policeStation: val));
              }
            } : null,
            validator: (v) => FormValidators.validateRequired(v, fieldName: 'Thana'),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
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
            _buildAddressForm(context, "বর্তমান ঠিকানা", form.presentAddress,
                (addr) {
              notifier.updateField(form.copyWith(presentAddress: addr));
            }),
            _buildAddressForm(context, "স্থায়ী ঠিকানা", form.permanentAddress,
                (addr) {
              notifier.updateField(form.copyWith(permanentAddress: addr));
            }),

            SectionCard(
                title: "যোগাযোগ",
                child: Column(
                    children: [
                        CustomTextField(
                            label: "মোবাইল নম্বর",
                            initialValue: form.mobileNumber,
                            keyboardType: TextInputType.phone,
                            validator: FormValidators.validateMobile,
                            onChanged: (v) => notifier.updateField(form.copyWith(mobileNumber: v)),
                        ),
                        CustomTextField(
                            label: "ইমেইল (যদি থাকে)",
                            initialValue: form.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: FormValidators.validateEmail,
                            onChanged: (v) => notifier.updateField(form.copyWith(email: v)),
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
                             content: Text("অনুগ্রহ করে ঠিকানার তথ্য সঠিকভাবে পূরণ করুন"),
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
