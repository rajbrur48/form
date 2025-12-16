import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';

class AddressStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AddressStep({Key? key, required this.onNext, required this.onBack}) : super(key: key);

  Widget _buildAddressForm(BuildContext context, String title, Address address, Function(Address) onUpdate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        TextFormField(
          initialValue: address.flatNo,
          decoration: InputDecoration(labelText: "Flat/House No", border: OutlineInputBorder()),
          onChanged: (v) => onUpdate(Address(
              flatNo: v, roadNo: address.roadNo, village: address.village,
              postOffice: address.postOffice, postCode: address.postCode,
              policeStation: address.policeStation, district: address.district
          )),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: address.roadNo,
          decoration: InputDecoration(labelText: "Road/Block/Sector", border: OutlineInputBorder()),
          onChanged: (v) => onUpdate(Address(
              flatNo: address.flatNo, roadNo: v, village: address.village,
              postOffice: address.postOffice, postCode: address.postCode,
              policeStation: address.policeStation, district: address.district
          )),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: address.village,
          decoration: InputDecoration(labelText: "Village/Area", border: OutlineInputBorder()),
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
              decoration: InputDecoration(labelText: "Post Office", border: OutlineInputBorder()),
              onChanged: (v) => onUpdate(Address(
                  flatNo: address.flatNo, roadNo: address.roadNo, village: address.village,
                  postOffice: v, postCode: address.postCode,
                  policeStation: address.policeStation, district: address.district
              )),
           )),
           SizedBox(width: 8),
           Expanded(child: TextFormField(
              initialValue: address.postCode,
              decoration: InputDecoration(labelText: "Post Code", border: OutlineInputBorder()),
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
          decoration: InputDecoration(labelText: "Thana/Police Station", border: OutlineInputBorder()),
          onChanged: (v) => onUpdate(Address(
              flatNo: address.flatNo, roadNo: address.roadNo, village: address.village,
              postOffice: address.postOffice, postCode: address.postCode,
              policeStation: v, district: address.district
          )),
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: address.district,
          decoration: InputDecoration(labelText: "District", border: OutlineInputBorder()),
          onChanged: (v) => onUpdate(Address(
              flatNo: address.flatNo, roadNo: address.roadNo, village: address.village,
              postOffice: address.postOffice, postCode: address.postCode,
              policeStation: address.policeStation, district: v
          )),
        ),
      ],
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
          Text("Address Details", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 20),

          _buildAddressForm(context, "Present Address", form.presentAddress, (addr) {
              notifier.updateField(form.copyWith(presentAddress: addr));
          }),

          SizedBox(height: 30),

          _buildAddressForm(context, "Permanent Address", form.permanentAddress, (addr) {
              notifier.updateField(form.copyWith(permanentAddress: addr));
          }),

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
