import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';
import '../components/form_components.dart';

class AddressStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AddressStep({Key? key, required this.onNext, required this.onBack})
      : super(key: key);

  Widget _buildAddressForm(BuildContext context, String title, Address address,
      Function(Address) onUpdate) {
    return SectionCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            initialValue: address.flatNo,
            decoration: InputDecoration(labelText: "ফ্ল্যাট / বাড়ি নং"),
            textInputAction: TextInputAction.next,
            onChanged: (v) => onUpdate(address.copyWith(flatNo: v)),
          ),
          SizedBox(height: 16),
          TextFormField(
            initialValue: address.roadNo,
            decoration: InputDecoration(labelText: "রাস্তা / ব্লক / সেক্টর"),
            textInputAction: TextInputAction.next,
            onChanged: (v) => onUpdate(address.copyWith(roadNo: v)),
          ),
          SizedBox(height: 16),
          TextFormField(
            initialValue: address.village,
            decoration: InputDecoration(labelText: "গ্রাম / এলাকা"),
            textInputAction: TextInputAction.next,
            onChanged: (v) => onUpdate(address.copyWith(village: v)),
          ),
          SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: TextFormField(
              initialValue: address.postOffice,
              decoration: InputDecoration(labelText: "ডাকঘর"),
              textInputAction: TextInputAction.next,
              onChanged: (v) => onUpdate(address.copyWith(postOffice: v)),
            )),
            SizedBox(width: 16),
            Expanded(
                child: TextFormField(
              initialValue: address.postCode,
              decoration: InputDecoration(labelText: "পোস্ট কোড"),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: (v) => onUpdate(address.copyWith(postCode: v)),
            )),
          ]),
          SizedBox(height: 16),
          TextFormField(
            initialValue: address.policeStation,
            decoration: InputDecoration(labelText: "থানা"),
            textInputAction: TextInputAction.next,
            onChanged: (v) => onUpdate(address.copyWith(policeStation: v)),
          ),
          SizedBox(height: 16),
          TextFormField(
            initialValue: address.district,
            decoration: InputDecoration(labelText: "জেলা"),
            textInputAction: TextInputAction.next, // Or done for the last field
            onChanged: (v) => onUpdate(address.copyWith(district: v)),
          ),
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
          StepNavigationButtons(
            onBack: onBack,
            onNext: onNext,
          ),
        ],
      ),
    );
  }
}

// Extension to make copyWith easier if not already present in model,
// but based on previous code it seemed manual. I'll rely on the model having it
// or the manual logic I used before.
// Wait, the previous code manually reconstructed the object.
// I should verify if `copyWith` exists or if I should stick to manual reconstruction.
// Checking previous file content...
// It was doing: Address(flatNo: v, roadNo: address.roadNo, ...) manually.
// So I should check the Address model to be safe.
