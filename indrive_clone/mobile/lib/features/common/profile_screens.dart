import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/app_config.dart';
import '../../core/l10n/strings.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../core/utils/vehicles.dart';
import '../../models/misc.dart';
import '../../widgets/common.dart';
import '../auth/session_controller.dart';
import 'ride_sheets.dart';

/* ------------------------------ Profile ------------------------------ */

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final _name = TextEditingController(text: ref.read(sessionProvider).user?.name ?? '');
  late final _email = TextEditingController(text: ref.read(sessionProvider).user?.email ?? '');

  Future<void> _photo() async {
    final x = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxWidth: 800);
    if (x == null) return;
    try {
      final me = await ref.read(userRepositoryProvider).uploadPhoto(x.path);
      ref.read(sessionProvider.notifier).updateMe(me);
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(sessionProvider);
    final u = s.user;
    final d = s.driver;
    return Scaffold(
      appBar: AppBar(title: Text(tr('Profile'))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Center(
          child: Stack(children: [
            UserAvatar(url: u?.photoUrl, name: u?.name, radius: 48),
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: AppColors.lime, foregroundColor: AppColors.black),
                onPressed: _photo,
                icon: const Icon(Icons.camera_alt, size: 18),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 8),
        Center(child: RatingBadge(rating: u?.rating ?? 5, count: u?.ratingCount, size: 16)),
        const SizedBox(height: 20),
        TextField(controller: _name, decoration: InputDecoration(labelText: tr('Your name'))),
        const SizedBox(height: 12),
        TextField(controller: _email, decoration: InputDecoration(labelText: tr('Email (optional)'))),
        const SizedBox(height: 12),
        InfoTile(icon: Icons.phone, text: localPhone(u?.phone), subtitle: 'Phone number'),
        const SizedBox(height: 16),
        LoadingButton(
          label: tr('Save'),
          onPressed: () async {
            final me = await ref.read(userRepositoryProvider).update(name: _name.text.trim(), email: _email.text.trim());
            ref.read(sessionProvider.notifier).updateMe(me);
            if (context.mounted) showMessage(context, 'Saved');
          },
        ),
        if (d != null) ...[
          const SizedBox(height: 24),
          const Text('Driver profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          InfoTile(icon: vehicleInfo(d.vehicle.type).icon, text: d.vehicle.title, subtitle: '${d.vehicle.plateNumber} · ${vehicleInfo(d.vehicle.type).label}'),
          const SizedBox(height: 6),
          InfoTile(icon: Icons.badge_outlined, text: d.cnicNumber, subtitle: 'CNIC · status: ${d.status}'),
          const SizedBox(height: 6),
          InfoTile(icon: Icons.star_outline, text: '${d.rating.toStringAsFixed(2)} (${d.ratingCount} ratings)', subtitle: 'Driver rating'),
        ],
      ]),
    );
  }
}

/* ------------------------------ Settings ------------------------------ */

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(sessionProvider);
    final n = ref.read(sessionProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(tr('Settings'))),
      body: ListView(children: [
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(tr('Language')),
          trailing: SegmentedButton<String>(
            segments: const [ButtonSegment(value: 'en', label: Text('EN')), ButtonSegment(value: 'ur', label: Text('اردو'))],
            selected: {s.language},
            onSelectionChanged: (v) => n.setLanguage(v.first),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.dark_mode_outlined),
          title: const Text('Theme'),
          trailing: DropdownButton<ThemeMode>(
            value: s.themeMode,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
              DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
              DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
            ],
            onChanged: (m) => n.setThemeMode(m ?? ThemeMode.system),
          ),
        ),
        const Divider(),
        const _SavedPlaces(),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: Text(tr('Logout')),
          onTap: () async {
            await n.logout();
          },
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever, color: AppColors.red),
          title: const Text('Delete account', style: TextStyle(color: AppColors.red)),
          onTap: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Delete account?'),
                content: const Text('Your personal data will be removed. This cannot be undone.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr('Cancel'))),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete', style: TextStyle(color: AppColors.red))),
                ],
              ),
            );
            if (ok == true) {
              try {
                await n.deleteAccount();
              } catch (e) {
                if (context.mounted) showError(context, e);
              }
            }
          },
        ),
        const SizedBox(height: 24),
        Center(child: Text('Server: ${AppConfig.apiUrl}', style: const TextStyle(color: AppColors.grey, fontSize: 12))),
      ]),
    );
  }
}

class _SavedPlaces extends ConsumerStatefulWidget {
  const _SavedPlaces();

  @override
  ConsumerState<_SavedPlaces> createState() => _SavedPlacesState();
}

class _SavedPlacesState extends ConsumerState<_SavedPlaces> {
  List<Place> _places = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final p = await ref.read(userRepositoryProvider).savedPlaces();
      if (mounted) setState(() => _places = p);
    } catch (_) {}
  }

  Future<void> _set(String label) async {
    final picked = await context.push<Place>('/search-place?field=save');
    if (picked == null) return;
    try {
      await ref.read(userRepositoryProvider).savePlace(label: label, place: picked);
      await _load();
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Place? of(String l) => _places.where((p) => p.label == l).firstOrNull;
    return Column(children: [
      for (final (label, icon, title) in [('home', Icons.home_outlined, tr('Home')), ('work', Icons.work_outline, tr('Work'))])
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(of(label)?.name ?? 'Not set'),
          trailing: of(label) == null
              ? const Icon(Icons.add)
              : IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    await ref.read(userRepositoryProvider).deletePlace(of(label)!.id!);
                    _load();
                  },
                ),
          onTap: () => _set(label),
        ),
    ]);
  }
}

/* ------------------------------ Safety ------------------------------ */

class SafetyScreen extends ConsumerWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('Safety'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('In an emergency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        InfoTile(icon: Icons.local_police_outlined, iconColor: AppColors.red, text: 'Police', subtitle: AppConfig.police, onTap: () => callPhone(AppConfig.police)),
        const SizedBox(height: 6),
        InfoTile(icon: Icons.health_and_safety_outlined, iconColor: AppColors.red, text: 'Rescue', subtitle: AppConfig.rescue, onTap: () => callPhone(AppConfig.rescue)),
        const SizedBox(height: 6),
        InfoTile(icon: Icons.emergency_outlined, iconColor: AppColors.red, text: 'Ambulance (Edhi)', subtitle: AppConfig.ambulance, onTap: () => callPhone(AppConfig.ambulance)),
        const SizedBox(height: 20),
        const Text('Safety tips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        for (final t in const [
          'Check the number plate, car model and driver photo before you get in.',
          'Share your trip with family from the ride screen.',
          'Sit in the back seat when you ride alone.',
          'Use the in-app chat and call. Do not share personal details.',
          'Press the Safety button during a ride to call for help. Our team also gets an SOS alert.',
        ])
          ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.check_circle_outline, color: AppColors.green), title: Text(t)),
      ]),
    );
  }
}

/* ------------------------------ Help ------------------------------ */

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faq = [
    ('How does the price work?',
        'You offer your own price. We show a recommended fare based on distance and time. Drivers can accept your price or offer a higher one. You choose the offer you like.'),
    ('Why did I get no offers?', 'Your price may be too low or no drivers are near. Tap "Raise fare" to get more offers. The search area also grows by itself.'),
    ('How do I pay?', 'Pay in cash to the driver at the end of the trip.'),
    ('How do I become a driver?', 'Open the menu and tap "Become a driver". Add your CNIC, license and vehicle details.'),
    ('What is the commission?', 'The service takes a small commission from each completed ride. It is taken from the driver balance. Drivers top up with JazzCash or Easypaisa.'),
    ('I left something in the car', 'Open My rides, choose the ride and call or chat with the driver while the ride is active, or contact support.'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(tr('Help'))),
        body: ListView(children: [
          for (final (q, a) in _faq)
            ExpansionTile(title: Text(q, style: const TextStyle(fontWeight: FontWeight.w600)), children: [
              Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Text(a)),
            ]),
          ListTile(
            leading: const Icon(Icons.support_agent),
            title: const Text('Contact support'),
            subtitle: const Text('support@example.com'),
            onTap: () => launchUrl(Uri.parse('mailto:support@example.com?subject=InDrive%20clone%20support')),
          ),
        ]),
      );
}

/* ------------------------------ Driver services ------------------------------ */

class DriverServicesScreen extends ConsumerStatefulWidget {
  const DriverServicesScreen({super.key});

  @override
  ConsumerState<DriverServicesScreen> createState() => _DriverServicesScreenState();
}

class _DriverServicesScreenState extends ConsumerState<DriverServicesScreen> {
  late final Set<String> _selected = {...?ref.read(sessionProvider).driver?.services};

  @override
  Widget build(BuildContext context) {
    final d = ref.watch(sessionProvider).driver;
    final allowed = services.where((s) => s.vehicleTypes.contains(d?.vehicle.type)).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('My services')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Choose which orders you want to receive.', style: TextStyle(color: AppColors.grey)),
        for (final s in allowed)
          SwitchListTile(
            secondary: Icon(s.icon),
            title: Text(s.label),
            value: _selected.contains(s.type),
            onChanged: (v) => setState(() => v ? _selected.add(s.type) : _selected.remove(s.type)),
          ),
        const SizedBox(height: 16),
        LoadingButton(
          label: tr('Save'),
          onPressed: _selected.isEmpty
              ? null
              : () async {
                  final p = await ref.read(driverRepositoryProvider).updateServices(_selected.toList());
                  ref.read(sessionProvider.notifier).updateDriver(p);
                  if (context.mounted) context.pop();
                },
        ),
      ]),
    );
  }
}
