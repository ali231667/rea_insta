import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/strings.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../models/misc.dart';
import 'passenger_controller.dart';

/// Search an address. Returns the chosen [Place] with context.pop(place).
class PlaceSearchScreen extends ConsumerStatefulWidget {
  const PlaceSearchScreen({super.key, required this.field});
  final String field; // pickup | dropoff | save

  @override
  ConsumerState<PlaceSearchScreen> createState() => _PlaceSearchScreenState();
}

class _PlaceSearchScreenState extends ConsumerState<PlaceSearchScreen> {
  final _ctrl = TextEditingController();
  Timer? _debounce;
  List<Place> _results = [];
  List<Place> _suggestions = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        final saved = await ref.read(userRepositoryProvider).savedPlaces();
        final recent = await ref.read(rideRepositoryProvider).recentPlaces();
        if (mounted) setState(() => _suggestions = [...saved, ...recent]);
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  void _onChanged(String q) {
    _debounce?.cancel();
    // Wait until the user stops typing (saves map API calls).
    _debounce = Timer(const Duration(milliseconds: 450), () async {
      if (q.trim().length < 2) {
        setState(() => _results = []);
        return;
      }
      setState(() => _loading = true);
      try {
        final near = ref.read(passengerProvider).myPosition ?? ref.read(passengerProvider).pickup?.latLng;
        final r = await ref.read(mapsRepositoryProvider).search(q, near: near);
        if (mounted && _ctrl.text == q) setState(() => _results = r);
      } catch (_) {
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    });
  }

  Future<void> _chooseOnMap() async {
    final p = await context.push<Place>('/pick-on-map');
    if (p != null && mounted) context.pop(p);
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.field == 'pickup' ? tr('From') : tr('Where to?');
    final list = _ctrl.text.trim().length >= 2 ? _results : _suggestions;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            controller: _ctrl,
            autofocus: true,
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: tr('Search street, market, place...'),
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _loading
                  ? const Padding(padding: EdgeInsets.all(14), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)))
                  : (_ctrl.text.isEmpty ? null : IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _ctrl.clear()))),
            ),
          ),
        ),
        ListTile(
          leading: const CircleAvatar(backgroundColor: AppColors.lime, child: Icon(Icons.map_outlined, color: AppColors.black)),
          title: Text(tr('Choose on map')),
          onTap: _chooseOnMap,
        ),
        const Divider(),
        Expanded(
          child: list.isEmpty
              ? Center(
                  child: Text(_ctrl.text.length >= 2 && !_loading ? 'Nothing found. Try another name or choose on map.' : '',
                      style: const TextStyle(color: AppColors.grey)))
              : ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const Divider(indent: 72),
                  itemBuilder: (context, i) {
                    final p = list[i];
                    final icon = p.label == 'home'
                        ? Icons.home_outlined
                        : p.label == 'work'
                            ? Icons.work_outline
                            : (_ctrl.text.length >= 2 ? Icons.place_outlined : Icons.history);
                    return ListTile(
                      leading: CircleAvatar(child: Icon(icon)),
                      title: Text(p.label == 'home' ? '${tr('Home')} · ${p.name}' : p.label == 'work' ? '${tr('Work')} · ${p.name}' : p.name,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: p.address.isEmpty || p.address == p.name
                          ? null
                          : Text(p.address, maxLines: 2, overflow: TextOverflow.ellipsis),
                      onTap: () => context.pop(p),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}
