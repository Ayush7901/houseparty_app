import 'dart:convert';

import 'package:logger/logger.dart';
import 'dart:io';

class FileHandler extends LogOutput {
  final File file;
  final bool overrideExisting;
  final Encoding encoding;

  FileHandler({
    required this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
  });

  @override
  void output(OutputEvent event) async {
    final logString = event.lines.join('\n');
    await file.writeAsString(
      '$logString\n',
      mode: overrideExisting ? FileMode.write : FileMode.append,
      encoding: encoding,
    );
  }
}