import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:typed_data';

class WebSocketMessage {
  final int errorCode;
  final int cmd;
  final int length;
  final Uint8List data;

  WebSocketMessage({
    required this.errorCode,
    required this.cmd,
    required this.length,
    required this.data,
  });
}

class WebSocketNotifier extends ChangeNotifier {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    // Uri.parse(
    //     'wss://wap-v101-gtmservice.rosetts.com/ws/fruit?session_id=6671446771c1d0000b0137e3'),
    Uri.parse('ws://127.0.0.1:8080'),
  );

  final List<WebSocketMessage> _messages = [];
  List<WebSocketMessage> get messages => _messages;

  WebSocketNotifier() {
    _channel.stream.listen((message) {
      if (message is List<int>) {
        Uint8List data = Uint8List.fromList(message);
        WebSocketMessage parsedMessage = _parseMessage(data);
        _messages.add(parsedMessage);
      }
      notifyListeners();
    });
  }

  void sendMessage(Uint8List data, int errorCode, int cmd) {
    // 分配包头字节数组（6字节）
    ByteData header = ByteData(6);
    header.setUint16(0, errorCode, Endian.big); // 前16位为 error_code
    header.setUint16(2, cmd, Endian.big); // 中间16位为 cmd
    header.setUint16(4, data.length, Endian.big); // 后16位为 data_length

    // 将包头和消息体合并
    Uint8List messageBytes = Uint8List(header.lengthInBytes + data.length);
    messageBytes.setRange(0, header.lengthInBytes, header.buffer.asUint8List());
    messageBytes.setRange(header.lengthInBytes, messageBytes.length, data);
    print("messageBytes: $messageBytes");
    _channel.sink.add(messageBytes);
  }

  WebSocketMessage _parseMessage(Uint8List data) {
    if (data.length < 6) {
      throw Exception('Invalid data length');
    }

    ByteData byteData = ByteData.sublistView(data);
    int errorCode = byteData.getUint16(0, Endian.big);
    int cmd = byteData.getUint16(2, Endian.big);
    int length = byteData.getUint16(4, Endian.big);

    return WebSocketMessage(
      errorCode: errorCode,
      cmd: cmd,
      length: length,
      data: data.sublist(6),
    );
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
