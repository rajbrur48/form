import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/form_provider.dart';
import '../../models/application_form.dart';
import '../camera_screen.dart';
import 'dart:io';

class NomineeStep extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const NomineeStep({Key? key, required this.onNext, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);
    final nominee = form.nominees.isNotEmpty ? form.nominees[0] : Nominee.empty();

    void _updateNominee(Nominee n) {
        notifier.updateNominee(0, n);
    }

    void _takePhoto() {
      Navigator.push(context, MaterialPageRoute(
        builder: (c) => CameraScreen(
          label: "Nominee Photo",
          onImageCaptured: (file) {
             _updateNominee(Nominee(
                 name: nominee.name, relation: nominee.relation, dob: nominee.dob,
                 nidNumber: nominee.nidNumber, photoPath: file.path, signaturePath: nominee.signaturePath
             ));
          },
        ),
      ));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Nominee Information", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 10),

          TextFormField(
            initialValue: nominee.name,
            decoration: InputDecoration(labelText: "Nominee Name", border: OutlineInputBorder()),
            onChanged: (v) => _updateNominee(Nominee(
                name: v, relation: nominee.relation, dob: nominee.dob, nidNumber: nominee.nidNumber,
                photoPath: nominee.photoPath, signaturePath: nominee.signaturePath
            )),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: nominee.relation,
            decoration: InputDecoration(labelText: "Relation", border: OutlineInputBorder()),
            onChanged: (v) => _updateNominee(Nominee(
                name: nominee.name, relation: v, dob: nominee.dob, nidNumber: nominee.nidNumber,
                photoPath: nominee.photoPath, signaturePath: nominee.signaturePath
            )),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: nominee.dob,
            decoration: InputDecoration(labelText: "Date of Birth", border: OutlineInputBorder()),
            onChanged: (v) => _updateNominee(Nominee(
                name: nominee.name, relation: nominee.relation, dob: v, nidNumber: nominee.nidNumber,
                photoPath: nominee.photoPath, signaturePath: nominee.signaturePath
            )),
          ),
           SizedBox(height: 10),
          TextFormField(
            initialValue: nominee.nidNumber,
            decoration: InputDecoration(labelText: "Nominee NID", border: OutlineInputBorder()),
            onChanged: (v) => _updateNominee(Nominee(
                name: nominee.name, relation: nominee.relation, dob: nominee.dob, nidNumber: v,
                photoPath: nominee.photoPath, signaturePath: nominee.signaturePath
            )),
          ),

          SizedBox(height: 20),
          GestureDetector(
              onTap: _takePhoto,
              child: Container(
                  height: 150,
                  decoration: BoxDecoration(border: Border.all(), color: Colors.grey[200]),
                  child: nominee.photoPath.isNotEmpty
                    ? Image.file(File(nominee.photoPath), fit: BoxFit.cover)
                    : Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt), Text("Tap to take Nominee Photo")]),
              ),
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
