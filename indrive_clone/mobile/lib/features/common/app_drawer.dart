import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../widgets/common.dart';
import '../auth/session_controller.dart';
import '../driver/driver_controller.dart';

/// Side menu. The big button at the bottom switches between passenger and driver mode (like InDrive).
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(sessionProvider);
    final u = s.user;
    final isDriver = s.mode == AppMode.driver;

    void go(String path) {
      Navigator.pop(context);
      context.push(path);
    }

    Future<void> switchMode() async {
      Navigator.pop(context);
      final n = ref.read(sessionProvider.notifier);
      if (isDriver) {
        if (ref.read(driverProvider).ride != null) {
          showMessage(context, 'Finish your current trip first', error: true);
          return;
        }
        if (ref.read(driverProvider).online) await ref.read(driverProvider.notifier).goOffline().catchError((_) {});
        await n.setMode(AppMode.passenger);
        if (context.mounted) context.go('/home');
        return;
      }
      final d = s.driver;
      if (d == null) {
        context.push('/driver/register');
      } else if (d.status == 'approved') {
        await n.setMode(AppMode.driver);
        if (context.mounted) context.go('/driver');
      } else {
        context.push('/driver/status');
      }
    }

    return Drawer(
      child: SafeArea(
        child: Column(children: [
          ListTile(
            contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            leading: UserAvatar(url: u?.photoUrl, name: u?.name, radius: 28),
            title: Text(u?.name ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
            subtitle: Row(children: [
              RatingBadge(rating: isDriver ? (s.driver?.rating ?? 5) : (u?.rating ?? 5)),
              const SizedBox(width: 8),
              Flexible(child: Text(localPhone(u?.phone), overflow: TextOverflow.ellipsis)),
            ]),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => go('/profile'),
          ),
          const Divider(),
          if (isDriver) ...[
            ListTile(leading: const Icon(Icons.local_taxi), title: Text(tr('Ride requests')), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.account_balance_wallet_outlined), title: Text(tr('Earnings')), onTap: () => go('/driver/earnings')),
            ListTile(leading: const Icon(Icons.tune), title: Text(tr('My services')), onTap: () => go('/driver/services')),
          ] else
            ListTile(leading: const Icon(Icons.directions_car), title: Text(tr('City')), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.history), title: Text(tr('My rides')), onTap: () => go('/history')),
          ListTile(leading: const Icon(Icons.shield_outlined), title: Text(tr('Safety')), onTap: () => go('/safety')),
          ListTile(leading: const Icon(Icons.settings_outlined), title: Text(tr('Settings')), onTap: () => go('/settings')),
          ListTile(leading: const Icon(Icons.help_outline), title: Text(tr('Help')), onTap: () => go('/help')),
          ListTile(
            leading: const Icon(Icons.card_giftcard),
            title: Text(tr('Invite friends')),
            onTap: () {
              Navigator.pop(context);
              SharePlus.instance.share(ShareParams(
                text: 'I use inDrive clone: offer your own price for rides in Pakistan. Download it: https://play.google.com/store',
              ));
            },
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: isDriver ? AppColors.lime : AppColors.black,
                foregroundColor: isDriver ? AppColors.black : AppColors.lime,
              ),
              onPressed: switchMode,
              child: Text(isDriver ? tr('Passenger mode') : (s.driver == null ? tr('Become a driver') : tr('Driver mode'))),
            ),
          ),
        ]),
      ),
    );
  }
}
