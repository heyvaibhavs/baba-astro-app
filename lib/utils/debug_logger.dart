import 'dart:developer' as developer;

/// Debug utility for comprehensive logging
class DebugLogger {
  static const bool _isDebugMode = true; // Set to false in production

  static void log(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_isDebugMode) return;

    final String logTag = tag ?? 'BabaApp';
    final String timestamp = DateTime.now().toIso8601String();

    developer.log(
      '[$timestamp] $message',
      name: logTag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    log('ERROR: $message', tag: tag, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, {String? tag}) {
    log('WARNING: $message', tag: tag);
  }

  static void info(String message, {String? tag}) {
    log('INFO: $message', tag: tag);
  }

  /// Log API request details
  static void logApiRequest({
    required String method,
    required String endpoint,
    Map<String, String>? headers,
    String? body,
  }) {
    log('API Request: $method $endpoint', tag: 'API');
    if (headers != null) {
      log('Headers: $headers', tag: 'API');
    }
    if (body != null) {
      log('Body: $body', tag: 'API');
    }
  }

  /// Log API response details
  static void logApiResponse({
    required int statusCode,
    required String body,
    Map<String, String>? headers,
  }) {
    log('API Response: Status $statusCode', tag: 'API');
    if (headers != null) {
      log('Response Headers: $headers', tag: 'API');
    }
    log('Response Body: $body', tag: 'API');
  }

  /// Log Google Sign-In events
  static void logGoogleSignIn(String event, {Object? data}) {
    log('Google Sign-In: $event', tag: 'GoogleAuth');
    if (data != null) {
      log('Data: $data', tag: 'GoogleAuth');
    }
  }
}
