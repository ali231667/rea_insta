import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/l10n/strings.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/vehicles.dart';
import '../../data/driver_repository.dart';
import '../../widgets/common.dart';
import '../auth/session_controller.dart';

/// Driver sign-up in 3 steps: documents -> vehicle -> services. (InDrive asks for CNIC, license, car photos.)
class DriverRegisterScreen extends ConsumerStatefulWidget {
  const DriverRegisterScreen({super.key});

  @override
  ConsumerState<DriverRegisterScreen> createState() => _DriverRegisterScreenState();
}

class _DriverRegisterScreenState extends ConsumerState<DriverRegisterScreen> {
  final _form = DriverRegistration();
  final _keys = [GlobalKey<FormState>(), GlobalKey<FormState>()];
  int _step = 0;

  Future<void> _pick(String doc, {bool camera = false}) async {
    final x = await ImagePicker().pickImage(source: camera ? ImageSource.camera : ImageSource.gallery, imageQuality: 70, maxWidth: 1600);
    if (x != null) setState(() => _form.docs[doc] = x.path);
  }

  Future<void> _submit() async {
    final profile = await ref.read(driverRepositoryProvider).register(_form);
    final session = ref.read(sessionProvider.notifier);
    session.updateDriver(profile);
    if (!mounted) return;
    if (profile.status == 'approved') {
      await session.setMode(AppMode.driver);
      if (mounted) context.go('/driver');
    } else {
      context.go('/driver/status');
    }
  }

  void _next() {
    if (_step < 2 && !(_keys[_step].currentState?.validate() ?? false)) return;
    if (_step == 0 && (!_form.docs.containsKey('selfie') || !_form.docs.containsKey('cnicFront'))) {
      showMessage(context, 'Please add your photo and CNIC front photo', error: true);
      return;
    }
    setState(() => _step++);
  }

  @override
  Widget build(BuildContext context) {
    final allowedServices = services.where((s) => s.vehicleTypes.contains(_form.vehicleType)).toList();
    return Scaffold(
      appBar: AppBar(title: Text(tr('Become a driver'))),
      body: Stepper(
        currentStep: _step,
        onStepTapped: (i) => i < _step ? setState(() => _step = i) : null,
        onStepCancel: _step == 0 ? null : () => setState(() => _step--),
        onStepContinue: _step < 2 ? _next : null,
        controlsBuilder: (context, details) => Padding(
          padding: const EdgeInsets.only(top: 16),
          child: _step == 2
              ? LoadingButton(label: 'Submit', onPressed: _form.services.isEmpty ? null : _submit)
              : Row(children: [
                  Expanded(child: FilledButton(onPressed: details.onStepContinue, child: Text(tr('Continue')))),
                  if (_step > 0) ...[
                    const SizedBox(width: 8),
                    TextButton(onPressed: details.onStepCancel, child: const Text('Back')),
                  ],
                ]),
        ),
        steps: [
          Step(
            title: const Text('Personal documents'),
            isActive: _step >= 0,
            state: _step > 0 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _keys[0],
              child: Column(children: [
                _PhotoRow(label: 'Your photo (selfie)', path: _form.docs['selfie'], onTap: () => _pick('selfie', camera: true)),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'CNIC number', hintText: '35202-1234567-1'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')), LengthLimitingTextInputFormatter(15)],
                  initialValue: _form.cnicNumber,
                  validator: (v) => RegExp(r'^\d{5}-?\d{7}-?\d$').hasMatch(v ?? '') ? null : 'Format: 35202-1234567-1',
                  onChanged: (v) => _form.cnicNumber = v,
                ),
                const SizedBox(height: 12),
                _PhotoRow(label: 'CNIC front', path: _form.docs['cnicFront'], onTap: () => _pick('cnicFront')),
                const SizedBox(height: 8),
                _PhotoRow(label: 'CNIC back', path: _form.docs['cnicBack'], onTap: () => _pick('cnicBack')),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Driving license number'),
                  initialValue: _form.licenseNumber,
                  validator: (v) => (v ?? '').trim().length >= 4 ? null : 'Enter your license number',
                  onChanged: (v) => _form.licenseNumber = v.trim(),
                ),
                const SizedBox(height: 12),
                _PhotoRow(label: 'Driving license photo', path: _form.docs['license'], onTap: () => _pick('license')),
              ]),
            ),
          ),
          Step(
            title: const Text('Vehicle'),
            isActive: _step >= 1,
            state: _step > 1 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _keys[1],
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Vehicle type', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final v in vehicles.values)
                    ChoiceChip(
                      avatar: Icon(v.icon, size: 18),
                      label: Text(v.label),
                      selected: _form.vehicleType == v.type,
                      onSelected: (_) => setState(() {
                        _form.vehicleType = v.type;
                        final ok = services.where((s) => s.vehicleTypes.contains(v.type)).map((s) => s.type).toSet();
                        _form.services = _form.services.intersection(ok);
                        if (_form.services.isEmpty) _form.services = {ok.first};
                      }),
                    ),
                ]),
                const SizedBox(height: 12),
                _text('Make (e.g. Suzuki, Toyota, Honda)', (v) => _form.vehicleMake = v, _form.vehicleMake),
                _text('Model (e.g. Alto, Corolla, CD 70)', (v) => _form.vehicleModel = v, _form.vehicleModel),
                _text('Color', (v) => _form.vehicleColor = v, _form.vehicleColor),
                _text('Year (optional)', (v) => _form.vehicleYear = v, _form.vehicleYear, required: false, number: true),
                _text('Number plate (e.g. LEA-1234)', (v) => _form.plateNumber = v, _form.plateNumber),
                _PhotoRow(label: 'Vehicle photo (number plate visible)', path: _form.docs['vehicle'], onTap: () => _pick('vehicle')),
              ]),
            ),
          ),
          Step(
            title: const Text('Services'),
            isActive: _step >= 2,
            content: Column(children: [
              for (final s in allowedServices)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  secondary: Icon(s.icon),
                  title: Text(s.label),
                  value: _form.services.contains(s.type),
                  onChanged: (v) => setState(() => v == true ? _form.services.add(s.type) : _form.services.remove(s.type)),
                ),
              const SizedBox(height: 8),
              const Text(
                'Your documents will be checked. The service takes a small commission from each completed ride.',
                style: TextStyle(color: AppColors.grey),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _text(String label, void Function(String) onChanged, String initial, {bool required = true, bool number = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          decoration: InputDecoration(labelText: label),
          initialValue: initial,
          keyboardType: number ? TextInputType.number : TextInputType.text,
          textCapitalization: TextCapitalization.words,
          validator: (v) => !required || (v ?? '').trim().isNotEmpty ? null : 'Required',
          onChanged: (v) => onChanged(v.trim()),
        ),
      );
}

class _PhotoRow extends StatelessWidget {
  const _PhotoRow({required this.label, required this.path, required this.onTap});
  final String label;
  final String? path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InfoTile(
        icon: path == null ? Icons.add_a_photo_outlined : Icons.check_circle,
        iconColor: path == null ? null : AppColors.green,
        text: label,
        subtitle: path == null ? 'Tap to add a photo' : 'Photo added · tap to change',
        onTap: onTap,
        trailing: path == null
            ? null
            : ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(path!), width: 44, height: 44, fit: BoxFit.cover)),
      );
}

/// Shown while documents are checked (or rejected).
class DriverStatusScreen extends ConsumerWidget {
  const DriverStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(sessionProvider).driver;
    final status = d?.status ?? 'pending';
    final (icon, title, text) = switch (status) {
      'rejected' => (Icons.cancel_outlined, 'Application rejected', d?.rejectionReason ?? 'Please check your documents and apply again.'),
      'blocked' => (Icons.block, 'Account blocked', d?.rejectionReason ?? 'Please contact support.'),
      'approved' => (Icons.verified, 'You are approved!', 'You can start driving now.'),
      _ => (Icons.hourglass_top, 'Documents are being checked', 'This usually takes a few hours. We will let you know.'),
    };
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Spacer(),
          Icon(icon, size: 72, color: status == 'approved' ? AppColors.green : AppColors.grey),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.grey)),
          const Spacer(),
          if (status == 'approved')
            FilledButton(
              onPressed: () async {
                await ref.read(sessionProvider.notifier).setMode(AppMode.driver);
                if (context.mounted) context.go('/driver');
              },
              child: Text(tr('Go online')),
            ),
          if (status == 'rejected') FilledButton(onPressed: () => context.go('/driver/register'), child: const Text('Apply again')),
          const SizedBox(height: 8),
          LoadingButton(
            outlined: true,
            label: 'Check status',
            onPressed: () => ref.read(sessionProvider.notifier).refreshMe(),
          ),
          TextButton(onPressed: () => context.go('/home'), child: Text(tr('Passenger mode'))),
        ]),
      ),
    );
  }
}
