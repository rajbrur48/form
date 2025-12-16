import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'steps/step1_identity.dart';
import 'steps/step2_personal.dart';
import 'steps/step2b_address.dart';
import 'steps/step3_professional.dart';
import 'steps/step4_nominee.dart';
import 'steps/step5_tp.dart';
import 'steps/step5b_services.dart';
import 'steps/step7_beneficial_owner.dart';
import 'steps/step6_review.dart';
import '../utils/mock_data.dart';
import '../providers/form_provider.dart';

class MainFormScreen extends ConsumerStatefulWidget {
  @override
  _MainFormScreenState createState() => _MainFormScreenState();
}

class _MainFormScreenState extends ConsumerState<MainFormScreen> {
  int _currentStep = 0;

  final List<String> _steps = [
    "পরিচয়", // Identity
    "ব্যক্তিগত", // Personal
    "ঠিকানা", // Address
    "পেশা", // Professional
    "নমিনি", // Nominee
    "লেনদেন", // TP
    "সেবা ও FATCA", // Services (New)
    "মালিকানা", // Beneficial
    "রিভিউ", // Review
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("হিসাব খোলার আবেদন ফরম"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.bolt),
            tooltip: "ডেমো তথ্য (Demo Fill)",
            onPressed: () {
              final mock = MockData.getCompleteMockForm();
              ref.read(formProvider.notifier).updateField(mock);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("ডেমো তথ্য পূরণ করা হয়েছে")),
              );
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          if (isMobile) {
            return Column(
              children: [
                _buildCompactStepper(context),
                Expanded(child: _buildStepContent()),
              ],
            );
          } else {
             // Tablet/Desktop Layout
             return Row(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Container(
                   width: 250,
                   decoration: BoxDecoration(
                     color: Colors.white,
                     border: Border(right: BorderSide(color: Colors.grey.shade200))
                   ),
                   child: _buildVerticalStepper(context),
                 ),
                 Expanded(child: _buildStepContent()),
               ],
             );
          }
        },
      ),
    );
  }

  Widget _buildStepContent() {
    return IndexedStack(
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
        AdditionalServicesStep(
          onNext: () => setState(() => _currentStep++),
          onBack: () => setState(() => _currentStep--),
        ),
        BeneficialOwnerStep(
          onNext: () => setState(() => _currentStep++),
          onBack: () => setState(() => _currentStep--),
        ),
        ReviewStep(),
      ],
    );
  }

  Widget _buildCompactStepper(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 "ধাপ ${_currentStep + 1} / ${_steps.length}",
                 style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
               ),
               Text(
                 _steps[_currentStep],
                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
                   color: Theme.of(context).primaryColor,
                   fontWeight: FontWeight.bold
                 ),
               ),
             ],
           ),
           SizedBox(
             height: 40,
             width: 40,
             child: CircularProgressIndicator(
               value: (_currentStep + 1) / _steps.length,
               backgroundColor: Colors.grey.shade100,
               color: Theme.of(context).primaryColor,
               strokeWidth: 4,
             ),
           )
        ],
      ),
    );
  }

  Widget _buildVerticalStepper(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      itemCount: _steps.length,
      separatorBuilder: (c, i) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        bool isActive = index == _currentStep;
        bool isCompleted = index < _currentStep;
        Color color = isCompleted || isActive ? Theme.of(context).primaryColor : Colors.grey;

        return InkWell(
          onTap: () {
            // Optional: Allow jumping to completed steps
            if (isCompleted) setState(() => _currentStep = index);
          },
          child: Row(
            children: [
               Container(
                 width: 32, height: 32,
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   color: isActive ? color : Colors.transparent,
                   border: Border.all(color: color, width: 2),
                 ),
                 child: Center(
                   child: isCompleted
                     ? Icon(Icons.check, size: 16, color: color)
                     : Text("${index + 1}", style: TextStyle(
                         color: isActive ? Colors.white : color,
                         fontWeight: FontWeight.bold
                       )),
                 ),
               ),
               SizedBox(width: 12),
               Expanded(
                 child: Text(
                   _steps[index],
                   style: TextStyle(
                     color: isActive ? color : Colors.black87,
                     fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                   ),
                 ),
               )
            ],
          ),
        );
      },
    );
  }
}
