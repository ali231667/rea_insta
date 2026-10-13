import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/strings.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/auth_repository.dart';
import '../../widgets/common.dart';
import 'session_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.request});
  final OtpRequestResult request;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _ctrl = TextEditingController();
  late OtpRequestResult _req = widget.request;
  Timer? _timer;
  int _left = 0;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Development only: the server returns the code, we fill it in for you.
    if (_req.devCode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showMessage(context, 'Dev mode: your code is ${_req.devCode}');
      });
    }
  }

  void _startTimer() {
    _left = _req.resendInSec;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_left <= 1) t.cancel();
      if (mounted) setState(() => _left--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_busy || _ctrl.text.length != 4) return;
    setState(() => _busy = true);
    try {
      await ref.read(authRepositoryProvider).verifyOtp(_req.phone, _ctrl.text);
      await ref.read(sessionProvider.notifier).loggedIn();
      // The router moves to the next screen by itself.
    } catch (e) {
      _ctrl.clear();
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    try {
      final r = await ref.read(authRepositoryProvider).requestOtp(_req.phone);
      setState(() => _req = r);
      _startTimer();
      if (mounted && r.devCode != null) showMessage(context, 'Dev mode: your code is ${r.devCode}');
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tr('Enter the code'), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Sent to ${localPhone(_req.phone)}', style: const TextStyle(color: AppColors.grey)),
            const SizedBox(height: 28),
            TextField(
              controller: _ctrl,
              autofocus: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              autofillHints: const [AutofillHints.oneTimeCode],
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 24),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
              decoration: const InputDecoration(hintText: '••••', counterText: ''),
              onChanged: (v) {
                setState(() {});
                if (v.length == 4) _verify();
              },
            ),
            const SizedBox(height: 16),
            if (_req.devCode != null)
              TextButton.icon(
                onPressed: () {
                  _ctrl.text = _req.devCode!;
                  _verify();
                },
                icon: const Icon(Icons.bug_report_outlined),
                label: Text('Use dev code ${_req.devCode}'),
              ),
            Center(
              child: _left > 0
                  ? Text('${tr('Resend code')} 0:${_left.toString().padLeft(2, '0')}', style: const TextStyle(color: AppColors.grey))
                  : TextButton(onPressed: _resend, child: Text(tr('Resend code'))),
            ),
            const Spacer(),
            FilledButton(
              onPressed: _ctrl.text.length == 4 && !_busy ? _verify : null,
              child: _busy ? const CircularProgressIndicator() : Text(tr('Continue')),
            ),
          ]),
        ),
      ),
    );
  }
}
