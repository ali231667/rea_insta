import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/realtime/socket_events.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format.dart';
import '../../models/misc.dart';
import '../../widgets/common.dart';
import '../auth/session_controller.dart';

/// In-ride chat between passenger and driver (realtime with Socket.IO).
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.rideId});
  final String rideId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final _messages = <ChatMessage>[];
  StreamSubscription<dynamic>? _sub;
  bool _loading = true;

  static const _quick = ['I am coming', 'I am here', 'Please wait 2 minutes', 'Where are you?', 'OK 👍'];

  @override
  void initState() {
    super.initState();
    _sub = ref.read(socketProvider).on(SocketEvents.chatMessage).listen((d) {
      final m = ChatMessage.fromJson(d);
      if (m.rideId != widget.rideId || _messages.any((x) => x.id == m.id)) return;
      setState(() => _messages.add(m));
      _toBottom();
    });
    Future.microtask(() async {
      try {
        final list = await ref.read(rideRepositoryProvider).messages(widget.rideId);
        if (mounted) {
          setState(() {
            _messages
              ..clear()
              ..addAll(list);
            _loading = false;
          });
          _toBottom();
        }
      } catch (e) {
        if (mounted) {
          setState(() => _loading = false);
          showError(context, e);
        }
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _toBottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      });

  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    _ctrl.clear();
    try {
      final m = await ref.read(rideRepositoryProvider).sendMessage(widget.rideId, text.trim());
      if (!_messages.any((x) => x.id == m.id)) setState(() => _messages.add(m));
      _toBottom();
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = ref.watch(sessionProvider).user?.id;
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(children: [
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.all(12),
                  itemCount: _messages.length,
                  itemBuilder: (context, i) {
                    final m = _messages[i];
                    final mine = m.senderId == me;
                    return Align(
                      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
                        decoration: BoxDecoration(
                          color: mine ? AppColors.lime : Theme.of(context).inputDecorationTheme.fillColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text(m.body, style: TextStyle(fontSize: 15, color: mine ? AppColors.black : null)),
                          Text(timeText(m.createdAt), style: TextStyle(fontSize: 11, color: mine ? Colors.black54 : AppColors.grey)),
                        ]),
                      ),
                    );
                  },
                ),
        ),
        SizedBox(
          height: 44,
          child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 12), children: [
            for (final q in _quick) Padding(padding: const EdgeInsets.only(right: 8), child: ActionChip(label: Text(q), onPressed: () => _send(q))),
          ]),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _send,
                  decoration: const InputDecoration(hintText: 'Message'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: AppColors.lime, foregroundColor: AppColors.black),
                onPressed: () => _send(_ctrl.text),
                icon: const Icon(Icons.send),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}
