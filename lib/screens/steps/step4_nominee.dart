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
          Text("নমিনির তথ্য", style: Theme.of(context).textTheme.headlineSmall),
          SizedBox(height: 10),

          TextFormField(
            initialValue: nominee.name,
            decoration: InputDecoration(labelText: "নমিনির নাম"),
            onChanged: (v) => _updateNominee(Nominee(
                name: v, relation: nominee.relation, dob: nominee.dob, nidNumber: nominee.nidNumber,
                photoPath: nominee.photoPath, signaturePath: nominee.signaturePath
            )),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: nominee.relation,
            decoration: InputDecoration(labelText: "সম্পর্ক"),
            onChanged: (v) => _updateNominee(Nominee(
                name: nominee.name, relation: v, dob: nominee.dob, nidNumber: nominee.nidNumber,
                photoPath: nominee.photoPath, signaturePath: nominee.signaturePath
            )),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: nominee.dob,
            decoration: InputDecoration(labelText: "জন্ম তারিখ", hintText: "DD/MM/YYYY"),
            onChanged: (v) => _updateNominee(Nominee(
                name: nominee.name, relation: nominee.relation, dob: v, nidNumber: nominee.nidNumber,
                photoPath: nominee.photoPath, signaturePath: nominee.signaturePath
            )),
          ),
           SizedBox(height: 10),
          TextFormField(
            initialValue: nominee.nidNumber,
            decoration: InputDecoration(labelText: "জাতীয় পরিচয়পত্র নম্বর"),
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
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[100]
                  ),
                  child: nominee.photoPath.isNotEmpty
                    ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(nominee.photoPath), fit: BoxFit.cover))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.camera_alt, size: 40, color: Colors.grey), Text("নমিনির ছবি তুলুন")]
                      ),
              ),
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
