import 'package:flutter/widgets.dart';

/// Logging utility for debug, info, and error messages.
///
/// Provides methods to log messages with different severity levels:
/// - `error()` - logs errors with optional error object and stack trace
/// - `info()` - logs informational messages
class Logger {
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('Error: $message');
    if (error != null) {
      debugPrint('*****************\r\nError details: $error');
    }
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackTrace');
    }
  }

  static void info(String message) {
    debugPrint('Info: $message');
  }
}
