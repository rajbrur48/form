import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/form_provider.dart';
import '../theme/app_theme.dart';
import 'main_form_screen.dart';

class LandingScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),

              // Logo Placeholder
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_outlined,
                    size: 64,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 32),

              // Welcome Text
              Text(
                "স্বাগতম",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "ব্যাংক হিসাব খোলার ডিজিটাল প্ল্যাটফর্মে আপনাকে স্বাগতম। সহজে এবং দ্রুত আপনার ব্যাংক অ্যাকাউন্ট খুলুন।",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),

              Spacer(),

              // Action Buttons
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainFormScreen()),
                  );
                },
                child: Text("আবেদন শুরু করুন"),
              ),
              SizedBox(height: 16),

              OutlinedButton.icon(
                onPressed: () {
                   _showResetDialog(context, ref);
                },
                icon: Icon(Icons.restore),
                label: Text("নতুন করে শুরু করুন"), // Reset
              ),

              SizedBox(height: 24),

              // Footer
              Text(
                "© 2024 Your Bank Limited. All rights reserved.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text("সতর্কতা"),
        content: Text("আপনি কি নিশ্চিত যে আপনি সংরক্ষিত তথ্য মুছে নতুন করে শুরু করতে চান?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text("না"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.secondaryColor),
            onPressed: () {
              ref.read(formProvider.notifier).clearForm();
              Navigator.pop(c);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainFormScreen()),
              );
            },
            child: Text("হ্যাঁ, মুছে ফেলুন"),
          ),
        ],
      ),
    );
  }
}
