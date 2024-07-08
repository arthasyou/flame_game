import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:typed_data';

class WebSocketNotifier extends ChangeNotifier {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse('ws://127.0.0.1:8080'), // 这里你可以替换成你自己的 WebSocket 地址
  );

  final List<Uint8List> _messages = [];
  List<Uint8List> get messages => _messages;

  WebSocketNotifier() {
    _channel.stream.listen((message) {
      if (message is List<int>) {
        _messages.add(Uint8List.fromList(message));
      }
      notifyListeners();
    });
  }

  void sendMessage(Uint8List data) {
    _channel.sink.add(data);
  }

  @override
  void dispose() {
    _channel.sink.close(status.goingAway);
    super.dispose();
  }
}

final webSocketProvider = ChangeNotifierProvider<WebSocketNotifier>((ref) {
  return WebSocketNotifier();
});
