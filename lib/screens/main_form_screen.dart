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
      backgroundColor: Color(0xFFF5F7FA), // Explicit background for contrast
      appBar: AppBar(
        title: Text("হিসাব খোলার আবেদন ফরম"),
        centerTitle: true,
        elevation: 0,
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
      body: Column(
        children: [
          // Modern Stepper
          _buildModernStepper(context),

          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                IdentityVerificationStep(
                    onNext: () => setState(() => _currentStep++)),
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

  Widget _buildModernStepper(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(_steps.length, (index) {
                bool isActive = index == _currentStep;
                bool isCompleted = index < _currentStep;
                bool isLast = index == _steps.length - 1;

                return Row(
                  children: [
                    _buildStepCircle(index, isActive, isCompleted),
                    if (!isLast)
                      Container(
                        width: 20,
                        height: 2,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        color: isCompleted
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                      ),
                  ],
                );
              }),
            ),
          ),
          SizedBox(height: 8),
          Text(
            _steps[_currentStep],
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int index, bool isActive, bool isCompleted) {
    Color color = isCompleted
        ? Theme.of(context).primaryColor
        : (isActive ? Theme.of(context).primaryColor : Colors.grey.shade300);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isActive ? 32 : 24,
      height: isActive ? 32 : 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? color : Colors.transparent,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: isCompleted
            ? Icon(Icons.check, size: 14, color: color) // Checkmark only if not active background
            : (isActive
                ? Text(
                    "${index + 1}",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                : Text(
                    "${index + 1}",
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  )),
      ),
    );
  }
}
