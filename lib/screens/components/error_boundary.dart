import 'package:flutter/material.dart';

class ErrorBoundary extends StatefulWidget {
  final Widget child;

  const ErrorBoundary({Key? key, required this.child}) : super(key: key);

  @override
  _ErrorBoundaryState createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  bool hasError = false;
  String errorDetails = '';

  @override
  void initState() {
    super.initState();
    // In production, we might want to log this to a service
    FlutterError.onError = (FlutterErrorDetails details) {
      // Prevent infinite loops if the error widget itself throws
      if (!hasError) {
         setState(() {
           hasError = true;
           errorDetails = details.exception.toString();
         });
      }
      FlutterError.presentError(details);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                  SizedBox(height: 24),
                  Text(
                    "দুঃখিত, একটি ত্রুটি হয়েছে",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "অ্যাপটি পুনরায় চালু করুন অথবা কিছুক্ষণ পরে আবার চেষ্টা করুন।",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Simple restart logic: just reset state
                      setState(() {
                        hasError = false;
                      });
                      // In a real app, might need RestartWidget logic
                    },
                    child: Text("পুনরায় চেষ্টা করুন"),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return widget.child;
  }
}
