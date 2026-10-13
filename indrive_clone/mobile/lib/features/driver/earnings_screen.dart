import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/strings.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../models/misc.dart';
import '../../widgets/common.dart';
import '../auth/session_controller.dart';

/// Driver money: balance (for commission), earnings today/week/month, wallet history.
final earningsProvider = FutureProvider.autoDispose<Earnings>((ref) => ref.watch(driverRepositoryProvider).earnings());

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(earningsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(tr('Earnings'))),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: TextButton(onPressed: () => ref.invalidate(earningsProvider), child: Text('$e\n${tr('Retry')}'))),
        data: (e) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(earningsProvider),
          child: ListView(padding: const EdgeInsets.all(16), children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.black, borderRadius: BorderRadius.circular(20)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tr('Balance'), style: const TextStyle(color: Colors.white70)),
                Text(pkr(e.balance),
                    style: TextStyle(color: e.balance < 0 ? AppColors.red : AppColors.lime, fontSize: 34, fontWeight: FontWeight.w900)),
                Text('Commission ${(e.commissionRate * 100).round()}% is taken from this balance after each ride.',
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => _topUp(context, ref),
                  icon: const Icon(Icons.add),
                  label: Text(tr('Top up')),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            DefaultTabController(
              length: 3,
              child: Column(children: [
                const TabBar(tabs: [Tab(text: 'Today'), Tab(text: 'This week'), Tab(text: 'This month')]),
                SizedBox(
                  height: 170,
                  child: TabBarView(children: [_Period(e.today), _Period(e.week), _Period(e.month)]),
                ),
              ]),
            ),
            const SizedBox(height: 8),
            const Text('Wallet history', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            for (final t in e.transactions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: t.amount >= 0 ? AppColors.lime : AppColors.greyLight,
                  child: Icon(t.amount >= 0 ? Icons.arrow_downward : Icons.arrow_upward, color: AppColors.black),
                ),
                title: Text(t.note ?? t.type),
                subtitle: Text(dateText(t.createdAt)),
                trailing: Text('${t.amount >= 0 ? '+' : ''}${pkr(t.amount)}',
                    style: TextStyle(fontWeight: FontWeight.w700, color: t.amount >= 0 ? AppColors.green : AppColors.red)),
              ),
          ]),
        ),
      ),
    );
  }

  Future<void> _topUp(BuildContext context, WidgetRef ref) async {
    var amount = 500;
    var method = 'jazzcash';
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(tr('Top up'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, children: [
                for (final a in [200, 500, 1000, 2000])
                  ChoiceChip(label: Text(pkr(a)), selected: amount == a, onSelected: (_) => setState(() => amount = a)),
              ]),
              const SizedBox(height: 8),
              RadioGroup<String>(
                groupValue: method,
                onChanged: (v) => setState(() => method = v ?? method),
                child: Column(children: [
                  for (final m in const [('jazzcash', 'JazzCash'), ('easypaisa', 'Easypaisa'), ('card', 'Debit / credit card')])
                    RadioListTile<String>(contentPadding: EdgeInsets.zero, title: Text(m.$2), value: m.$1),
                ]),
              ),
              const Text('Demo payment: no real money is charged.', style: TextStyle(color: AppColors.grey, fontSize: 12)),
              const SizedBox(height: 12),
              LoadingButton(
                label: 'Pay ${pkr(amount)}',
                onPressed: () async {
                  final balance = await ref.read(driverRepositoryProvider).topUp(amount, method);
                  ref.read(sessionProvider.notifier).setBalance(balance);
                  ref.invalidate(earningsProvider);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Period extends StatelessWidget {
  const _Period(this.p);
  final EarningPeriod p;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2.6,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _Stat('Net earnings', pkr(p.net)),
            _Stat('Rides', '${p.rides}'),
            _Stat('Cash collected', pkr(p.gross)),
            _Stat('Commission', pkr(p.commission)),
          ],
        ),
      );
}

class _Stat extends StatelessWidget {
  const _Stat(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Theme.of(context).inputDecorationTheme.fillColor, borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(color: AppColors.grey, fontSize: 12)),
        ]),
      );
}
