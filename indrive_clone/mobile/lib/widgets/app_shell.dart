import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app/app_config_provider.dart';
import '../core/providers.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/session_controller.dart';
import '../features/auth/splash_screen.dart';

/// Wraps every screen:
/// - blocks the app when an update is required or the service is in maintenance
/// - shows a small banner when the connection to the server is lost
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cfg = ref.watch(remoteConfigProvider).value;
    if (cfg?.maintenanceMessage != null) {
      return _BlockingPage(
        icon: Icons.construction,
        title: 'We will be back soon',
        text: cfg!.maintenanceMessage!,
        button: 'Try again',
        onTap: () => ref.invalidate(remoteConfigProvider),
      );
    }
    if (cfg?.mustUpdate == true) {
      return _BlockingPage(
        icon: Icons.system_update,
        title: 'Please update the app',
        text: 'This version (${cfg!.appVersion}) is too old. Update to ${cfg.latestAppVersion} to keep using the service.',
        button: 'Update',
        onTap: () => launchUrl(Uri.parse(cfg.storeUrl), mode: LaunchMode.externalApplication),
      );
    }
    final loggedIn = ref.watch(sessionProvider.select((s) => s.status == AuthStatus.loggedIn));
    return Stack(children: [
      child,
      if (loggedIn) const _ConnectionBanner(),
    ]);
  }
}

class _BlockingPage extends StatelessWidget {
  const _BlockingPage({required this.icon, required this.title, required this.text, required this.button, required this.onTap});
  final IconData icon;
  final String title;
  final String text;
  final String button;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const SizedBox(height: 24),
              const BrandLogo(size: 32),
              const Spacer(),
              Icon(icon, size: 72),
              const SizedBox(height: 16),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.grey)),
              const Spacer(),
              FilledButton(onPressed: onTap, child: Text(button)),
            ]),
          ),
        ),
      );
}

/// "No connection. Reconnecting..." – shown when the realtime connection is down for more than 3 seconds.
class _ConnectionBanner extends ConsumerStatefulWidget {
  const _ConnectionBanner();

  @override
  ConsumerState<_ConnectionBanner> createState() => _ConnectionBannerState();
}

class _ConnectionBannerState extends ConsumerState<_ConnectionBanner> {
  Timer? _timer;
  bool _show = false;
  late final ValueNotifier<bool> _connected = ref.read(socketProvider).connected;

  @override
  void initState() {
    super.initState();
    _connected.addListener(_changed);
    _changed();
  }

  void _changed() {
    _timer?.cancel();
    if (_connected.value) {
      if (_show) setState(() => _show = false);
    } else {
      _timer = Timer(const Duration(seconds: 3), () {
        if (mounted) setState(() => _show = true);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _connected.removeListener(_changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: IgnorePointer(
        child: AnimatedSlide(
          duration: const Duration(milliseconds: 250),
          offset: _show ? Offset.zero : const Offset(0, -1.5),
          child: SafeArea(
            bottom: false,
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(20)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.lime)),
                  SizedBox(width: 8),
                  Text('No connection. Reconnecting…',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600, decoration: TextDecoration.none)),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
