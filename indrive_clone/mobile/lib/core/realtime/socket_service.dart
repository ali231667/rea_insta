import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../config/app_config.dart';
import '../network/api_client.dart';
import 'socket_events.dart';

typedef SocketMessage = ({String event, Map<String, dynamic> data});

/// One WebSocket connection to the backend for the whole app.
/// Screens listen with `socket.on('ride:updated')`.
class SocketService {
  SocketService(this.api);
  final ApiClient api;

  io.Socket? _socket;
  final _messages = StreamController<SocketMessage>.broadcast();
  final connected = ValueNotifier<bool>(false);

  Stream<Map<String, dynamic>> on(String event) => _messages.stream.where((m) => m.event == event).map((m) => m.data);

  /// Called after login.
  void connect() {
    if (_socket != null) return;
    final s = io.io(
      AppConfig.apiUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          // A function, so every reconnect uses the newest token.
          .setAuthFn((cb) => cb({'token': api.tokens.accessToken ?? ''}))
          .build(),
    );
    s.onConnect((_) => connected.value = true);
    s.onDisconnect((_) => connected.value = false);
    s.onConnectError((err) async {
      connected.value = false;
      // Token expired: get a new one; socket.io will retry by itself.
      if ('$err'.contains('unauthorized')) {
        try {
          await api.refresh();
          s.connect();
        } catch (_) {}
      }
    });
    for (final e in SocketEvents.all) {
      s.on(e, (data) {
        if (data is Map) _messages.add((event: e, data: Map<String, dynamic>.from(data)));
      });
    }
    s.connect();
    _socket = s;
  }

  void emit(String event, Map<String, dynamic> data) => _socket?.emit(event, data);

  /// Called on logout.
  void disconnect() {
    _socket?.dispose();
    _socket = null;
    connected.value = false;
  }
}
