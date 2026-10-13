import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers.dart';
import 'core/push/push_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/session_controller.dart';
import 'features/driver/driver_controller.dart';
import 'features/passenger/passenger_controller.dart';
import 'widgets/app_shell.dart';

class InDriveCloneApp extends ConsumerStatefulWidget {
  const InDriveCloneApp({super.key});

  @override
  ConsumerState<InDriveCloneApp> createState() => _InDriveCloneAppState();
}

class _InDriveCloneAppState extends ConsumerState<InDriveCloneApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Phone apps are paused in the background. When the user comes back, load fresh data.
    _lifecycle = AppLifecycleListener(onResume: () {
      final s = ref.read(sessionProvider);
      if (s.status != AuthStatus.loggedIn) return;
      ref.read(socketProvider).connect();
      if (s.mode == AppMode.driver) {
        ref.read(driverProvider.notifier).resync();
      } else {
        ref.read(passengerProvider.notifier).resync();
      }
    });
    // Tapping a push notification opens its screen.
    final push = PushService.instance;
    push.onOpenRoute = (route) {
      final router = ref.read(routerProvider);
      if (route.startsWith('/chat') || route.startsWith('/rate')) {
        router.push(route);
      } else {
        router.go(route);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final s = ref.watch(sessionProvider);

    ref.listen(sessionProvider.select((x) => x.status), (_, status) {
      if (status == AuthStatus.loggedIn) PushService.instance.flushPending();
    });

    return MaterialApp.router(
      title: 'inDrive clone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: s.themeMode,
      routerConfig: router,
      builder: (context, child) => AppShell(child: child ?? const SizedBox()),
      // Urdu is right-to-left; Flutter turns the layout around by itself.
      locale: Locale(s.language),
      supportedLocales: const [Locale('en'), Locale('ur')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
