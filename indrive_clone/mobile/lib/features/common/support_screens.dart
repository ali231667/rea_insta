import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/strings.dart';
import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../data/support_repository.dart';
import '../../widgets/common.dart';

final ticketsProvider = FutureProvider.autoDispose<List<SupportTicket>>((ref) => ref.watch(supportRepositoryProvider).tickets());

/// "My support requests" + button to write a new one.
class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(ticketsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(tr('Support'))),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.lime,
        foregroundColor: AppColors.black,
        onPressed: () async {
          await context.push('/support/new');
          ref.invalidate(ticketsProvider);
        },
        icon: const Icon(Icons.add),
        label: Text(tr('New request')),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: TextButton(onPressed: () => ref.invalidate(ticketsProvider), child: Text('$e\n${tr('Retry')}'))),
        data: (list) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(ticketsProvider),
          child: list.isEmpty
              ? ListView(children: const [
                  SizedBox(height: 120),
                  Icon(Icons.support_agent, size: 56, color: AppColors.grey),
                  SizedBox(height: 8),
                  Center(child: Text('No requests yet. We usually answer within a few hours.', style: TextStyle(color: AppColors.grey))),
                ])
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _TicketCard(ticket: list[i]),
                ),
        ),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});
  final SupportTicket ticket;

  @override
  Widget build(BuildContext context) {
    final t = ticket;
    final (label, color) = switch (t.status) {
      'answered' => ('Answered', AppColors.lime),
      'closed' => ('Closed', AppColors.line),
      _ => ('Waiting for reply', const Color(0xFFFFF3C4)),
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).dividerColor)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(ticketCategories[t.category] ?? t.category, style: const TextStyle(fontWeight: FontWeight.w700))),
          Pill(label, color: color),
        ]),
        const SizedBox(height: 4),
        Text(dateText(t.createdAt), style: const TextStyle(color: AppColors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Text(t.message),
        if (t.adminReply != null) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.lime.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
            child: Text('Support: ${t.adminReply}'),
          ),
        ],
      ]),
    );
  }
}

/// Form to report a problem. Can be opened from a ride ("rideId") with a category already chosen.
class NewTicketScreen extends ConsumerStatefulWidget {
  const NewTicketScreen({super.key, this.rideId, this.category});
  final String? rideId;
  final String? category;

  @override
  ConsumerState<NewTicketScreen> createState() => _NewTicketScreenState();
}

class _NewTicketScreenState extends ConsumerState<NewTicketScreen> {
  late String _category = widget.category ?? (widget.rideId != null ? 'lost_item' : 'app_problem');
  final _msg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('Report a problem'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        if (widget.rideId != null)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: InfoTile(icon: Icons.receipt_long, text: 'About your ride', subtitle: 'We will look at the details of this ride'),
          ),
        const Text('What happened?', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final e in ticketCategories.entries)
            ChoiceChip(label: Text(e.value), selected: _category == e.key, onSelected: (_) => setState(() => _category = e.key)),
        ]),
        const SizedBox(height: 16),
        TextField(
          controller: _msg,
          maxLines: 6,
          maxLength: 2000,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: _category == 'lost_item'
                ? 'What did you lose? Describe it (color, brand) and where you sat.'
                : 'Tell us what happened. Please give details.',
          ),
        ),
        const SizedBox(height: 8),
        LoadingButton(
          label: tr('Send'),
          onPressed: _msg.text.trim().length < 10
              ? null
              : () async {
                  await ref.read(supportRepositoryProvider).create(category: _category, message: _msg.text.trim(), rideId: widget.rideId);
                  if (!context.mounted) return;
                  showMessage(context, 'Sent. We will answer you here and with a notification.');
                  context.pop();
                },
        ),
      ]),
    );
  }
}
