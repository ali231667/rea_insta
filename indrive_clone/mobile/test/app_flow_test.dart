// Starts the real app (router + session) and checks the first screens.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:indrive_clone/app.dart';
import 'package:indrive_clone/core/providers.dart';
import 'package:indrive_clone/core/storage/prefs.dart';
import 'package:indrive_clone/core/storage/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> pumpApp(WidgetTester tester, Map<String, Object> prefs) async {
  SharedPreferences.setMockInitialValues(prefs);
  final p = await Prefs.create();
  await tester.pumpWidget(ProviderScope(
    overrides: [
      prefsProvider.overrideWithValue(p),
      tokenStorageProvider.overrideWithValue(TokenStorage()), // empty = logged out
    ],
    child: const InDriveCloneApp(),
  ));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('first start shows language choice, then phone login', (tester) async {
    await pumpApp(tester, {});
    expect(find.text('Set your own fair price'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Enter your phone number'), findsOneWidget);
    expect(find.text('🇵🇰 +92'), findsOneWidget);

    // Button is disabled until a valid number is typed. A leading 0 is removed.
    await tester.enterText(find.byType(TextField), '03001234567');
    await tester.pump();
    expect(find.text('3001234567'), findsOneWidget);
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Urdu language translates the login screen', (tester) async {
    await pumpApp(tester, {'seen_onboarding': true, 'language': 'ur'});
    expect(find.text('اپنا فون نمبر درج کریں'), findsOneWidget);
  });
}
