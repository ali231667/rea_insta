import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import 'session_controller.dart';
import 'splash_screen.dart';

/// First start: choose language + short intro (InDrive asks for language first).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  String _lang = 'en';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 24),
            const BrandLogo(size: 40, dark: false),
            const Spacer(),
            const Icon(Icons.handshake_outlined, color: AppColors.lime, size: 64),
            const SizedBox(height: 20),
            Text(tr('Set your own fair price'),
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800, height: 1.1)),
            const SizedBox(height: 12),
            Text(tr('Offer your price, choose your driver. Rides, couriers, city to city and freight.'),
                style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const Spacer(),
            Text(tr('Choose your language'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Row(children: [
              for (final l in const [('en', 'English'), ('ur', 'اردو')])
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(l.$2),
                    selected: _lang == l.$1,
                    onSelected: (_) => setState(() {
                      _lang = l.$1;
                      L10n.language = l.$1;
                    }),
                  ),
                ),
            ]),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => ref.read(sessionProvider.notifier).finishOnboarding(_lang),
              child: Text(tr('Continue')),
            ),
          ]),
        ),
      ),
    );
  }
}
