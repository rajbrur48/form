import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'steps/step1_identity.dart';
import 'steps/step2_personal.dart';
import 'steps/step6_review.dart';

// We will build the wrapper here
class MainFormScreen extends StatefulWidget {
  @override
  _MainFormScreenState createState() => _MainFormScreenState();
}

class _MainFormScreenState extends State<MainFormScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account Opening Form")),
      body: Column(
        children: [
          // Custom Stepper Header
          Container(
            height: 60,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (c, i) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Text(
                        "Step ${i+1}",
                        style: TextStyle(
                            fontWeight: i == _currentStep ? FontWeight.bold : FontWeight.normal,
                            color: i == _currentStep ? Colors.blue : Colors.grey
                        )
                    ),
                ),
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
                Center(child: Text("Step 3: Professional (Pending Implementation)")),
                Center(child: Text("Step 4: Nominee (Pending Implementation)")),
                Center(child: Text("Step 5: TP (Pending Implementation)")),
                ReviewStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
