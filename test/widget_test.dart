// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finora/app.dart';
import 'package:finora/providers/settings_providers.dart';

void main() {
  testWidgets('Finora app loads', (WidgetTester tester) async {
    // Initialize SharedPreferences for testing BEFORE building the widget
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider
              .overrideWithValue(await SharedPreferences.getInstance()),
        ],
        child: const FinoraApp(),
      ),
    );

    // Verify that the app loads
    expect(find.byType(FinoraApp), findsOneWidget);
  });
}
