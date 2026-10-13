import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/strings.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../models/ride.dart';
import '../../widgets/common.dart';
import '../passenger/passenger_controller.dart';

/// Passenger rates the driver after the trip.
class RateScreen extends ConsumerStatefulWidget {
  const RateScreen({super.key, required this.rideId});
  final String rideId;

  @override
  ConsumerState<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends ConsumerState<RateScreen> {
  int _stars = 5;
  final _review = TextEditingController();
  final _tags = <String>{};
  Ride? _ride;

  static const _goodTags = ['Clean car', 'Good driving', 'Polite', 'On time', 'Knows the city'];
  static const _badTags = ['Late', 'Dirty car', 'Rude', 'Unsafe driving', 'Asked for more money'];

  @override
  void initState() {
    super.initState();
    _ride = ref.read(passengerProvider).ride;
    Future.microtask(() async {
      try {
        final r = await ref.read(rideRepositoryProvider).get(widget.rideId);
        if (mounted) setState(() => _ride = r);
      } catch (_) {}
    });
  }

  void _finish() {
    ref.read(passengerProvider.notifier).closeRide();
    context.go('/home');
  }

  Future<void> _submit() async {
    final text = [..._tags, if (_review.text.trim().isNotEmpty) _review.text.trim()].join('. ');
    await ref.read(rideRepositoryProvider).rate(widget.rideId, _stars, text);
    if (mounted) {
      showMessage(context, 'Thank you for your feedback!');
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = _ride;
    final tags = _stars >= 4 ? _goodTags : _badTags;
    return Scaffold(
      appBar: AppBar(actions: [TextButton(onPressed: _finish, child: const Text('Skip'))]),
      body: SafeArea(
        child: ListView(padding: const EdgeInsets.all(20), children: [
          const Icon(Icons.check_circle, color: AppColors.green, size: 56),
          const SizedBox(height: 8),
          const Text('You have arrived!', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          if (r != null) ...[
            const SizedBox(height: 4),
            Text('Please pay ${pkr(r.price)} in cash to the driver', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.grey)),
            const SizedBox(height: 20),
            Center(child: UserAvatar(url: r.driver?.photoUrl, name: r.driver?.name, radius: 36)),
            const SizedBox(height: 8),
            Text(r.driver?.name ?? '', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          ],
          const SizedBox(height: 16),
          Text(tr('Rate your trip'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          StarInput(value: _stars, onChanged: (v) => setState(() {
                _stars = v;
                _tags.clear();
              })),
          const SizedBox(height: 8),
          Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: [
            for (final t in tags)
              FilterChip(
                label: Text(t),
                selected: _tags.contains(t),
                onSelected: (v) => setState(() => v ? _tags.add(t) : _tags.remove(t)),
              ),
          ]),
          const SizedBox(height: 12),
          TextField(controller: _review, maxLines: 3, decoration: const InputDecoration(hintText: 'Write a comment (optional)')),
          const SizedBox(height: 20),
          LoadingButton(label: tr('Submit'), onPressed: _submit),
        ]),
      ),
    );
  }
}
