import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/strings.dart';
import '../../widgets/common.dart';
import 'session_controller.dart';

/// New users enter their name (drivers see it).
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [TextButton(onPressed: () => ref.read(sessionProvider.notifier).logout(), child: Text(tr('Logout')))],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tr('What is your name?'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 24),
            TextField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(hintText: tr('Your name'), prefixIcon: const Icon(Icons.person_outline)),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: tr('Email (optional)'), prefixIcon: const Icon(Icons.mail_outline)),
            ),
            const Spacer(),
            LoadingButton(
              label: tr('Continue'),
              onPressed: _name.text.trim().length < 2
                  ? null
                  : () => ref.read(sessionProvider.notifier).completeProfile(
                        name: _name.text.trim(),
                        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
                      ),
            ),
          ]),
        ),
      ),
    );
  }
}
