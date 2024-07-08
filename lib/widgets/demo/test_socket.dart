import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../protos/message.pb.dart';
import '../../services/proto_service.dart';
import '../../services/web_socket_service.dart';

class SocketPage extends ConsumerStatefulWidget {
  const SocketPage({super.key});

  @override
  SocketPageState createState() => SocketPageState();
}

class SocketPageState extends ConsumerState<SocketPage> {
  late ProtoHandler _protoHandler;

  @override
  void initState() {
    super.initState();
    _protoHandler = ProtoHandler();

    // Listen for new messages
    ref.read(webSocketProvider).addListener(_onMessageReceived);
  }

  @override
  void dispose() {
    ref.read(webSocketProvider).removeListener(_onMessageReceived);
    super.dispose();
  }

  void _onMessageReceived() {
    final webSocketNotifier = ref.read(webSocketProvider);
    if (webSocketNotifier.messages.isNotEmpty) {
      // Get the last received message
      Uint8List messageBytes = webSocketNotifier.messages.last;
      String messageType = 'tos_101'; // 替换为实际的消息类型
      try {
        final message = _protoHandler.parseMessage(messageType, messageBytes);
        print('Parsed message: $message');
        // Handle the parsed message
      } catch (e) {
        print('Failed to parse message: $e');
      }
    }
  }

  void _sendMessage() {
    final webSocketNotifier = ref.read(webSocketProvider);
    // 创建tos_101消息实例并设置字段
    final tos101Message = tos_101()..message = 'Hello, this is tos_101';
    // 将消息序列化为字节数组
    Uint8List messageBytes = Uint8List.fromList(tos101Message.writeToBuffer());
    webSocketNotifier.sendMessage(messageBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('WebSocket and Protobuf Example'),
          ElevatedButton(
            onPressed: _sendMessage,
            child: const Text('Send Message'),
          ),
        ],
      ),
    );
  }
}
