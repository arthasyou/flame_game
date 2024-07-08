// proto_handler.dart
import 'package:protobuf/protobuf.dart';
import 'dart:typed_data';
import '../generators/proto_generator.dart'; // 导入生成的proto文件

typedef ProtoParser = GeneratedMessage Function(Uint8List bytes);

class ProtoHandler {
  final Map<String, ProtoParser> _parsers = {};

  ProtoHandler() {
    // 注册所有已知的消息类型解析器
    _registerAllParsers();
  }

  void _registerAllParsers() {
    for (var messageType in getAllMessageTypes()) {
      _parsers[messageType().info_.qualifiedMessageName] = (Uint8List bytes) {
        final message = messageType();
        message.mergeFromBuffer(bytes);
        return message;
      };
    }
  }

  GeneratedMessage parseMessage(String messageType, Uint8List bytes) {
    final parser = _parsers[messageType];
    if (parser == null) {
      throw Exception('No parser registered for message type: $messageType');
    }
    return parser(bytes);
  }
}

// 使用示例
void main() {
  final handler = ProtoHandler();

  // 假设我们收到了一条'tos_101'类型的消息
  final messageBytes = Uint8List.fromList([/*...*/]);
  final messageType = 'tos_101';
  final message = handler.parseMessage(messageType, messageBytes);

  print(message);
}
