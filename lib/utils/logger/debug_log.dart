import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class DebugLog {
  static const String _appName = 'APP';

  static void info(String message, {String tag = 'INFO'}) {
    _log(message, tag, 'ℹ️');
  }

  static void success(String message, {String tag = 'SUCCESS'}) {
    _log(message, tag, '✅');
  }

  static void warning(String message, {String tag = 'WARNING'}) {
    _log(message, tag, '⚠️');
  }

  static void error(
    String message, {
    String tag = 'ERROR',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(message, tag, '❌', error: error, stackTrace: stackTrace);
  }

  static void debug(String message, {String tag = 'DEBUG'}) {
    if (kDebugMode) {
      _log(message, tag, '🐞');
    }
  }

  static void _log(
    String message,
    String tag,
    String emoji, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kReleaseMode) return;

    developer.log(
      '$emoji [$tag] $message',
      name: _appName,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
