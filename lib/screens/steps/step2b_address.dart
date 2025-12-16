import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';

class AddressStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AddressStep({Key? key, required this.onNext, required this.onBack}) : super(key: key);

  Widget _buildAddressForm(BuildContext context, String title, Address address, Function(Address) onUpdate) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Divider(),
            SizedBox(height: 8),
            TextFormField(
              initialValue: address.flatNo,
              decoration: InputDecoration(labelText: "ফ্ল্যাট / বাড়ি নং"),
              onChanged: (v) => onUpdate(Address(
                  flatNo: v, roadNo: address.roadNo, village: address.village,
                  postOffice: address.postOffice, postCode: address.postCode,
                  policeStation: address.policeStation, district: address.district
              )),
            ),
            SizedBox(height: 8),
            TextFormField(
              initialValue: address.roadNo,
              decoration: InputDecoration(labelText: "রাস্তা / ব্লক / সেক্টর"),
              onChanged: (v) => onUpdate(Address(
                  flatNo: address.flatNo, roadNo: v, village: address.village,
                  postOffice: address.postOffice, postCode: address.postCode,
                  policeStation: address.policeStation, district: address.district
              )),
            ),
            SizedBox(height: 8),
            TextFormField(
              initialValue: address.village,
              decoration: InputDecoration(labelText: "গ্রাম / এলাকা"),
              onChanged: (v) => onUpdate(Address(
                  flatNo: address.flatNo, roadNo: address.roadNo, village: v,
                  postOffice: address.postOffice, postCode: address.postCode,
                  policeStation: address.policeStation, district: address.district
              )),
            ),
            SizedBox(height: 8),
            Row(children: [
               Expanded(child: TextFormField(
                  initialValue: address.postOffice,
                  decoration: InputDecoration(labelText: "ডাকঘর"),
                  onChanged: (v) => onUpdate(Address(
                      flatNo: address.flatNo, roadNo: address.roadNo, village: address.village,
                      postOffice: v, postCode: address.postCode,
                      policeStation: address.policeStation, district: address.district
                  )),
               )),
               SizedBox(width: 8),
               Expanded(child: TextFormField(
                  initialValue: address.postCode,
                  decoration: InputDecoration(labelText: "পোস্ট কোড"),
                  onChanged: (v) => onUpdate(Address(
                      flatNo: address.flatNo, roadNo: address.roadNo, village: address.village,
                      postOffice: address.postOffice, postCode: v,
                      policeStation: address.policeStation, district: address.district
                  )),
               )),
            ]),
            SizedBox(height: 8),
            TextFormField(
              initialValue: address.policeStation,
              decoration: InputDecoration(labelText: "থানা"),
              onChanged: (v) => onUpdate(Address(
                  flatNo: address.flatNo, roadNo: address.roadNo, village: address.village,
                  postOffice: address.postOffice, postCode: address.postCode,
                  policeStation: v, district: address.district
              )),
            ),
            SizedBox(height: 8),
            TextFormField(
              initialValue: address.district,
              decoration: InputDecoration(labelText: "জেলা"),
              onChanged: (v) => onUpdate(Address(
                  flatNo: address.flatNo, roadNo: address.roadNo, village: address.village,
                  postOffice: address.postOffice, postCode: address.postCode,
                  policeStation: address.policeStation, district: v
              )),
            ),
          ],
        ),
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
          Text("ঠিকানা সংক্রান্ত তথ্য", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 20),

          _buildAddressForm(context, "বর্তমান ঠিকানা", form.presentAddress, (addr) {
              notifier.updateField(form.copyWith(presentAddress: addr));
          }),

          SizedBox(height: 20),

          _buildAddressForm(context, "স্থায়ী ঠিকানা", form.permanentAddress, (addr) {
              notifier.updateField(form.copyWith(permanentAddress: addr));
          }),

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
