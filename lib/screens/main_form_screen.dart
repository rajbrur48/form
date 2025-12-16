import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'steps/step1_identity.dart';
import 'steps/step2_personal.dart';
import 'steps/step2b_address.dart';
import 'steps/step3_professional.dart';
import 'steps/step4_nominee.dart';
import 'steps/step5_tp.dart';
import 'steps/step7_beneficial_owner.dart';
import 'steps/step6_review.dart';
import '../utils/mock_data.dart';
import '../providers/form_provider.dart';

// We will build the wrapper here
class MainFormScreen extends ConsumerStatefulWidget {
  @override
  _MainFormScreenState createState() => _MainFormScreenState();
}

class _MainFormScreenState extends ConsumerState<MainFormScreen> {
  int _currentStep = 0;

  // Step Titles in Bangla
  final List<String> _steps = [
    "পরিচয়", // Identity
    "ব্যক্তিগত", // Personal
    "ঠিকানা", // Address
    "পেশা", // Professional
    "নমিনি", // Nominee
    "লেনদেন", // TP
    "মালিকানা", // Beneficial
    "রিভিউ", // Review
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("হিসাব খোলার আবেদন ফরম"),
        actions: [
          IconButton(
            icon: Icon(Icons.bolt),
            tooltip: "ডেমো তথ্য (Demo Fill)",
            onPressed: () {
              final mock = MockData.getCompleteMockForm();
              ref.read(formProvider.notifier).updateField(mock);
              // Also mocked paths if needed, but file paths need real files or will fail
              // We can't easily mock file paths in web/linux easily without copy
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Custom Stepper Header (Modern)
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))]
            ),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: _steps.length,
                itemBuilder: (c, i) {
                   bool isActive = i == _currentStep;
                   bool isCompleted = i < _currentStep;
                   return Container(
                       margin: EdgeInsets.symmetric(horizontal: 8),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Container(
                             width: 30, height: 30,
                             decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               color: isActive ? Theme.of(context).primaryColor : (isCompleted ? Colors.green : Colors.grey[300]),
                             ),
                             child: Center(
                               child: isCompleted
                                 ? Icon(Icons.check, color: Colors.white, size: 18)
                                 : Text("${i+1}", style: TextStyle(color: isActive ? Colors.white : Colors.grey[600])),
                             ),
                           ),
                           SizedBox(height: 4),
                           Text(
                               _steps[i],
                               style: TextStyle(
                                   fontSize: 12,
                                   fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                   color: isActive ? Theme.of(context).primaryColor : Colors.grey
                               )
                           ),
                         ],
                       ),
                   );
                },
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                IdentityVerificationStep(onNext: () => setState(() => _currentStep++)),
                PersonalInfoStep(
                    onNext: () => setState(() => _currentStep++),
                    onBack: () => setState(() => _currentStep--),
                ),
                AddressStep(
                    onNext: () => setState(() => _currentStep++),
                    onBack: () => setState(() => _currentStep--),
                ),
                ProfessionalStep(
                    onNext: () => setState(() => _currentStep++),
                    onBack: () => setState(() => _currentStep--),
                ),
                NomineeStep(
                    onNext: () => setState(() => _currentStep++),
                    onBack: () => setState(() => _currentStep--),
                ),
                TransactionProfileStep(
                    onNext: () => setState(() => _currentStep++),
                    onBack: () => setState(() => _currentStep--),
                ),
                BeneficialOwnerStep(
                    onNext: () => setState(() => _currentStep++),
                    onBack: () => setState(() => _currentStep--),
                ),
                ReviewStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
