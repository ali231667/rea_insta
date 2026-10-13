import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/app_config.dart';
import '../../core/l10n/strings.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../models/ride.dart';
import '../../models/user.dart';
import '../../widgets/common.dart';

const passengerCancelReasons = [
  'Driver asked me to cancel',
  'Driver is too far / taking too long',
  'Driver is not moving',
  'I found another ride',
  'I changed my plans',
  'Wrong pickup address',
];

const driverCancelReasons = [
  'Passenger is not at the pickup point',
  'Passenger asked me to cancel',
  'Passenger is not answering calls',
  'Too far away',
  'Problem with my vehicle',
];

/// Ask why the user cancels. Returns the reason or null.
Future<String?> askCancelReason(BuildContext context, {required bool driver}) {
  final reasons = driver ? driverCancelReasons : passengerCancelReasons;
  return showModalBottomSheet<String>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text('Why do you want to cancel?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        ),
        for (final r in reasons) ListTile(title: Text(r), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.pop(context, r)),
        Padding(
          padding: const EdgeInsets.all(16),
          child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Keep the ride')),
        ),
      ]),
    ),
  );
}

Future<void> callPhone(String? phone) async {
  if (phone == null) return;
  await launchUrl(Uri(scheme: 'tel', path: phone));
}

/// Share the trip: a live web link (family can follow the car) + trip details.
Future<void> shareTrip(WidgetRef ref, Ride r, {LatLng? carAt}) async {
  String? link;
  try {
    link = await ref.read(supportRepositoryProvider).shareLink(r.id);
  } catch (_) {}
  final text = tripShareText(r, carAt: carAt) + (link != null ? '\nFollow my trip live: $link' : '');
  await SharePlus.instance.share(ShareParams(text: text));
}

/// Sends the trip by SMS to the trusted contacts saved in Safety settings.
Future<bool> smsTrustedContacts(WidgetRef ref, Ride r, {LatLng? carAt}) async {
  final contacts = ref.read(prefsProvider).emergencyContacts.map((c) => c.split('|').last).where((p) => p.isNotEmpty).toList();
  if (contacts.isEmpty) return false;
  String? link;
  try {
    link = await ref.read(supportRepositoryProvider).shareLink(r.id);
  } catch (_) {}
  final body = 'I need help. ${tripShareText(r, carAt: carAt)}${link != null ? '\nLive: $link' : ''}';
  await launchUrl(Uri(scheme: 'sms', path: contacts.join(','), queryParameters: {'body': body}));
  return true;
}

/// Text to share the trip with family (InDrive "Share trip").
String tripShareText(Ride r, {LatLng? carAt}) {
  final d = r.driver;
  final where = carAt != null ? '\nCar now: https://maps.google.com/?q=${carAt.latitude},${carAt.longitude}' : '';
  return 'I am on an inDrive clone trip.\n'
      'From: ${r.pickup.address}\nTo: ${r.dropoff.address}\n'
      '${d != null ? 'Driver: ${d.name}, ${d.vehicle.title}, ${d.vehicle.plateNumber}\n' : ''}'
      'Destination map: https://maps.google.com/?q=${r.dropoff.lat},${r.dropoff.lng}$where';
}

/// Safety tools: emergency calls, SOS alert to the company, share trip.
Future<void> showSafetySheet(BuildContext context, WidgetRef ref, Ride ride, {LatLng? myPosition}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(tr('Safety'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: AppColors.red, foregroundColor: Colors.white),
            icon: const Icon(Icons.sos),
            label: const Text('SOS – call police (15)'),
            onPressed: () async {
              // Tell our server (admin panel shows SOS alerts) and call police.
              ref.read(rideRepositoryProvider).sos(ride.id, myPosition).catchError((_) {});
              // Also tell trusted contacts (opens the SMS app)
              smsTrustedContacts(ref, ride, carAt: myPosition).catchError((_) => false);
              await callPhone(AppConfig.police);
            },
          ),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.local_hospital_outlined),
                label: const Text('Rescue 1122'),
                onPressed: () => callPhone(AppConfig.rescue),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.emergency_outlined),
                label: const Text('Ambulance 115'),
                onPressed: () => callPhone(AppConfig.ambulance),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.share_outlined),
            label: const Text('Share my trip (live link)'),
            onPressed: () => shareTrip(ref, ride, carAt: myPosition),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.sms_outlined),
            label: const Text('Send SMS to my trusted contacts'),
            onPressed: () async {
              final ok = await smsTrustedContacts(ref, ride, carAt: myPosition);
              if (!ok && context.mounted) {
                Navigator.pop(context);
                showMessage(context, 'Add trusted contacts in Safety settings first');
              }
            },
          ),
          const SizedBox(height: 12),
          const Text('Always check the car number plate before you get in.', style: TextStyle(color: AppColors.grey), textAlign: TextAlign.center),
        ]),
      ),
    ),
  );
}

/// Round button with label (Call / Chat / Share / Safety).
class ActionCircle extends StatelessWidget {
  const ActionCircle({super.key, required this.icon, required this.label, required this.onTap, this.color});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color ?? (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2A2A2A) : AppColors.greyLight),
              child: Icon(icon, color: color != null ? Colors.white : null),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
        ),
      );
}

/// Driver photo, name, rating, car and plate.
class DriverCard extends StatelessWidget {
  const DriverCard({super.key, required this.driver, this.trailing});
  final PublicDriver driver;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(children: [
        UserAvatar(url: driver.photoUrl, name: driver.name, radius: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(driver.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            Row(children: [
              RatingBadge(rating: driver.rating),
              Text('  ·  ${driver.tripsCount} trips', style: const TextStyle(color: AppColors.grey, fontSize: 13)),
            ]),
            Text(driver.vehicle.title, style: const TextStyle(color: AppColors.grey)),
          ]),
        ),
        trailing ?? PlateBadge(driver.vehicle.plateNumber),
      ]);
}

/// Number plate in Pakistani style (white plate, black text).
class PlateBadge extends StatelessWidget {
  const PlateBadge(this.plate, {super.key});
  final String plate;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.black, width: 1.5),
        ),
        child: Text(plate, style: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w900, letterSpacing: 1)),
      );
}
