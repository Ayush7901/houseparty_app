import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import './file_handler.dart';

class LoggingService {
  static final LoggingService _instance = LoggingService._internal();
  late Logger _logger;
  
  factory LoggingService() {
    return _instance;
  }

  LoggingService._internal() {
    _initLogger();
  }

  void _initLogger() async {
    final logFile = await _logFile;
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 5, // Number of method calls to be displayed
        errorMethodCount: 8, // Number of method calls if stacktrace is provided
        lineLength: 120, // Width of the output
        colors: true, // Colorful log messages
        printEmojis: false, // Print an emoji for each log message
      ),
      output: MultiOutput([
        ConsoleOutput(),
        FileHandler(file: logFile, overrideExisting: true, encoding: utf8),
      ]),
    );
  }

  static Future<File> get _logFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/app.log');
  }

  void debug(String message) {
    _logger.d(message);
  }

  void info(String message) {
    _logger.i(message);
  }

  void warning(String message) {
    _logger.w(message);
  }

  void error(String message) {
    _logger.e(message);
  }
}