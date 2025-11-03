import 'package:flutter/widgets.dart';

class Logger {
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    // Implement your logging logic here
    debugPrint('Error: $message');
    if (error != null) {
      debugPrint('Error details: $error');
    }
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }

  static void info(String message) {
    debugPrint('Info: $message');
  }
}
