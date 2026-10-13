import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/strings.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _ctrl = TextEditingController();

  /// Pakistani mobile: 3XX XXXXXXX (10 digits after +92)
  bool get _valid => RegExp(r'^3\d{9}$').hasMatch(_ctrl.text.replaceAll(' ', ''));

  Future<void> _send() async {
    final phone = '+92${_ctrl.text.replaceAll(' ', '')}';
    final r = await ref.read(authRepositoryProvider).requestOtp(phone);
    if (!mounted) return;
    context.push('/otp', extra: r);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tr('Enter your phone number'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(tr('We will send you a code by SMS'), style: const TextStyle(color: AppColors.grey)),
            const SizedBox(height: 28),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
                decoration: BoxDecoration(color: Theme.of(context).inputDecorationTheme.fillColor, borderRadius: BorderRadius.circular(14)),
                child: const Text('🇵🇰 +92', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // People often type the leading 0 (0300...). Remove it.
                    TextInputFormatter.withFunction((o, n) => n.text.startsWith('0') ? n.copyWith(text: n.text.substring(1), selection: TextSelection.collapsed(offset: n.text.length - 1)) : n),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(hintText: '300 1234567'),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ]),
            const Spacer(),
            Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
              const Text('By continuing you agree to the ', style: TextStyle(color: AppColors.grey, fontSize: 12)),
              InkWell(
                onTap: () => context.push('/legal/terms'),
                child: Text(tr('Terms of Service'), style: const TextStyle(fontSize: 12, decoration: TextDecoration.underline)),
              ),
              const Text(' and ', style: TextStyle(color: AppColors.grey, fontSize: 12)),
              InkWell(
                onTap: () => context.push('/legal/privacy'),
                child: Text(tr('Privacy Policy'), style: const TextStyle(fontSize: 12, decoration: TextDecoration.underline)),
              ),
            ]),
            const SizedBox(height: 12),
            LoadingButton(label: tr('Continue'), onPressed: _valid ? _send : null),
          ]),
        ),
      ),
    );
  }
}
