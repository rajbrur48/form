import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bank_account_form/main.dart';
import 'package:bank_account_form/screens/main_form_screen.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // Verify that the title is present (indicating app loaded)
    expect(find.text('Account Opening Form'), findsOneWidget);

    // Verify steps exist
    expect(find.text('Step 1'), findsOneWidget);
    expect(find.text('Identity Verification'), findsOneWidget);
  });
}
