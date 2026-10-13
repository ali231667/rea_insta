import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../models/ride.dart';
import 'passenger_controller.dart';

/// "Offer your fare" – the main InDrive idea: the passenger chooses the price.
Future<void> showFareSheet(BuildContext context, WidgetRef ref) {
  final s = ref.read(passengerProvider);
  final o = s.selectedOption;
  if (o == null) return Future.value();
  final ctrl = TextEditingController(text: '${s.offeredFare ?? o.recommendedFare}');

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(builder: (context, setState) {
      final value = int.tryParse(ctrl.text) ?? 0;
      final tooLow = value < o.minFare;
      void set(int v) => setState(() => ctrl.text = '$v');
      return Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(tr('Offer your fare'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Row(children: [
            IconButton.filledTonal(onPressed: () => set((value - 10).clamp(0, o.maxFare)), icon: const Icon(Icons.remove)),
            Expanded(
              child: TextField(
                controller: ctrl,
                autofocus: true,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
                decoration: const InputDecoration(prefixText: 'PKR ', filled: false, border: InputBorder.none, enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
                onChanged: (_) => setState(() {}),
              ),
            ),
            IconButton.filledTonal(onPressed: () => set(value + 10), icon: const Icon(Icons.add)),
          ]),
          const SizedBox(height: 8),
          Text(
            tooLow ? '${tr('Minimum fare')}: ${pkr(o.minFare)}' : '${tr('Recommended fare')}: ${pkr(o.recommendedFare)}',
            textAlign: TextAlign.center,
            style: TextStyle(color: tooLow ? AppColors.red : AppColors.grey),
          ),
          const SizedBox(height: 8),
          Wrap(alignment: WrapAlignment.center, spacing: 8, children: [
            for (final f in [0.9, 1.0, 1.1, 1.2])
              ActionChip(
                label: Text(pkr((o.recommendedFare * f / 10).round() * 10)),
                onPressed: () => set((o.recommendedFare * f / 10).round() * 10),
              ),
          ]),
          const SizedBox(height: 8),
          const Text('Low prices may take longer to get offers. Drivers can also suggest their own price.',
              textAlign: TextAlign.center, style: TextStyle(color: AppColors.grey, fontSize: 12)),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: tooLow || value > o.maxFare
                ? null
                : () {
                    ref.read(passengerProvider.notifier).setFare(value);
                    Navigator.pop(context);
                  },
            child: Text(tr('Done')),
          ),
        ]),
      );
    }),
  );
}

/// Comment + extra fields for each service.
Future<void> showOptionsSheet(BuildContext context, WidgetRef ref) {
  final s = ref.read(passengerProvider);
  final comment = TextEditingController(text: s.comment);
  final pkg = TextEditingController(text: s.details.packageDescription ?? s.details.cargoDescription ?? '');
  final rName = TextEditingController(text: s.details.receiverName ?? '');
  final rPhone = TextEditingController(text: s.details.receiverPhone ?? '');
  var d = s.details;

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(builder: (context, setState) {
      Widget sw(String label, bool? v, void Function(bool) on) =>
          SwitchListTile(contentPadding: EdgeInsets.zero, title: Text(label), value: v ?? false, onChanged: (x) => setState(() => on(x)));

      return Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, MediaQuery.viewInsetsOf(context).bottom + 20),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(tr('Comments and wishes'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            if (s.serviceType == 'courier') ...[
              TextField(controller: pkg, decoration: const InputDecoration(labelText: 'What are you sending? (e.g. documents, keys)')),
              const SizedBox(height: 8),
              TextField(controller: rName, decoration: const InputDecoration(labelText: 'Receiver name')),
              const SizedBox(height: 8),
              TextField(controller: rPhone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Receiver phone')),
              const SizedBox(height: 8),
            ],
            if (s.serviceType == 'freight') ...[
              TextField(controller: pkg, decoration: const InputDecoration(labelText: 'What do you need to move? (e.g. fridge, sofa)')),
              sw('I need loaders (helpers)', d.needLoaders, (x) => d = d.copyWith(needLoaders: x)),
            ],
            if (s.serviceType == 'intercity') ...[
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: Text(d.departureAt == null
                    ? 'Departure: as soon as possible'
                    : 'Departure: ${DateFormat('d MMM, h:mm a').format(DateTime.parse(d.departureAt!).toLocal())}'),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final now = DateTime.now();
                  final date = await showDatePicker(context: context, firstDate: now, lastDate: now.add(const Duration(days: 30)), initialDate: now);
                  if (date == null || !context.mounted) return;
                  final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(now.add(const Duration(hours: 1))));
                  if (time == null) return;
                  final at = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                  setState(() => d = d.copyWith(departureAt: at.toUtc().toIso8601String()));
                },
              ),
              Row(children: [
                const Icon(Icons.event_seat_outlined),
                const SizedBox(width: 16),
                const Expanded(child: Text('Passengers')),
                IconButton(onPressed: () => setState(() => d = d.copyWith(seats: ((d.seats ?? 1) - 1).clamp(1, 7))), icon: const Icon(Icons.remove_circle_outline)),
                Text('${d.seats ?? 1}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                IconButton(onPressed: () => setState(() => d = d.copyWith(seats: ((d.seats ?? 1) + 1).clamp(1, 7))), icon: const Icon(Icons.add_circle_outline)),
              ]),
              sw('I can share the car with other passengers', d.sharedRide, (x) => d = d.copyWith(sharedRide: x)),
            ],
            if (s.serviceType == 'city') ...[
              sw('Child seat', d.childSeat, (x) => d = d.copyWith(childSeat: x)),
              sw('Travelling with a pet', d.withPet, (x) => d = d.copyWith(withPet: x)),
            ],
            const SizedBox(height: 8),
            TextField(
              controller: comment,
              maxLines: 2,
              maxLength: 300,
              decoration: const InputDecoration(hintText: 'Comment for the driver (e.g. "I am at gate 2")'),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                if (s.serviceType == 'courier') {
                  d = d.copyWith(packageDescription: _orNull(pkg.text), receiverName: _orNull(rName.text), receiverPhone: _orNull(rPhone.text));
                } else if (s.serviceType == 'freight') {
                  d = d.copyWith(cargoDescription: _orNull(pkg.text));
                }
                final n = ref.read(passengerProvider.notifier);
                n.setComment(comment.text);
                n.setDetails(d);
                Navigator.pop(context);
              },
              child: Text(tr('Save')),
            ),
          ]),
        ),
      );
    }),
  );
}

String? _orNull(String s) => s.trim().isEmpty ? null : s.trim();

/// Short text lines for ride details (shown to drivers and in history).
List<String> detailLines(RideDetails d) => [
      if (d.packageDescription != null) '📦 ${d.packageDescription}',
      if (d.receiverName != null || d.receiverPhone != null) '👤 Receiver: ${d.receiverName ?? ''} ${d.receiverPhone ?? ''}'.trim(),
      if (d.cargoDescription != null) '🚚 ${d.cargoDescription}',
      if (d.needLoaders == true) '💪 Needs loaders',
      if (d.departureAt != null) '🗓 ${DateFormat('d MMM, h:mm a').format(DateTime.parse(d.departureAt!).toLocal())}',
      if (d.seats != null) '💺 ${d.seats} passenger(s)',
      if (d.sharedRide == true) '👥 Can share the car',
      if (d.childSeat == true) '🧒 Child seat',
      if (d.withPet == true) '🐾 With a pet',
    ];
