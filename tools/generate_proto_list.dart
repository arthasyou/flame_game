import 'dart:io';

void main() {
  final protoFiles = [
    'protos/message.proto', // 添加你的proto文件路径
    // 'path/to/another.proto',
  ];

  final buffer = StringBuffer();
  buffer.writeln('// generated_message_list.dart');
  buffer.writeln('// This file is auto-generated. Do not edit manually.');
  buffer.writeln("import 'package:protobuf/protobuf.dart';");
  buffer.writeln("import '../protos/message.pb.dart';"); // 导入生成的proto文件

  buffer.writeln('List<GeneratedMessage Function()> getAllMessageTypes() {');
  buffer.writeln('  return [');

  for (final protoFile in protoFiles) {
    final lines = File(protoFile).readAsLinesSync();
    for (final line in lines) {
      final match = RegExp(r'message (\w+)').firstMatch(line);
      if (match != null) {
        final messageName = match.group(1);
        buffer.writeln('    () => $messageName(),');
      }
    }
  }

  buffer.writeln('  ];');
  buffer.writeln('}');

  final outputFile = File('lib/generators/proto_list_generator.dart');
  outputFile.writeAsStringSync(buffer.toString());
  print('Generated file: generated_message_list.dart');
}
