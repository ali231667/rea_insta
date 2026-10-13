import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/providers.dart';
import 'core/push/push_service.dart';
import 'core/storage/prefs.dart';
import 'core/storage/token_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved settings and login tokens before the first screen.
  final prefs = await Prefs.create();
  final tokens = TokenStorage();
  await tokens.load();

  // Push notifications (skipped if Firebase is not configured).
  await PushService.instance.init();

  runApp(ProviderScope(
    overrides: [
      prefsProvider.overrideWithValue(prefs),
      tokenStorageProvider.overrideWithValue(tokens),
    ],
    child: const InDriveCloneApp(),
  ));
}
