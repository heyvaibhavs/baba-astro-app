import 'package:flutter/foundation.dart';
import 'dart:convert';

/// Utility class for logging and analyzing authentication tokens
class TokenLogger {
  /// Logs comprehensive information about a Google ID token
  static void logGoogleIdToken(
    String? idToken, {
    String? userEmail,
    String? userName,
    String? userId,
  }) {
    if (!kDebugMode) return; // Only log in debug mode

    debugPrint('=' * 60);
    debugPrint('🔐 GOOGLE AUTHENTICATION TOKEN LOG');
    debugPrint('=' * 60);

    // Basic user info
    if (userEmail != null) debugPrint('📧 Email: $userEmail');
    if (userName != null) debugPrint('👤 Name: $userName');
    if (userId != null) debugPrint('🆔 User ID: $userId');

    if (idToken == null || idToken.isEmpty) {
      debugPrint('❌ ID Token: NULL or EMPTY');
      debugPrint('=' * 60);
      return;
    }

    // Token basic info
    debugPrint('🎫 Token Length: ${idToken.length} characters');
    debugPrint('🎫 Token Start: ${idToken.substring(0, 50)}...');
    debugPrint('🎫 Token End: ...${idToken.substring(idToken.length - 20)}');

    // Full token (only in debug assertions)
    assert(() {
      debugPrint('🔓 FULL GOOGLE ID TOKEN:');
      debugPrint(idToken);
      return true;
    }());

    // Decode JWT payload
    _decodeAndLogJwtPayload(idToken, 'GOOGLE');

    debugPrint('=' * 60);
  }

  /// Logs comprehensive information about a Firebase ID token
  static void logFirebaseIdToken(String? idToken) {
    if (!kDebugMode) return; // Only log in debug mode

    debugPrint('=' * 60);
    debugPrint('🔥 FIREBASE AUTHENTICATION TOKEN LOG');
    debugPrint('=' * 60);

    if (idToken == null || idToken.isEmpty) {
      debugPrint('❌ Firebase ID Token: NULL or EMPTY');
      debugPrint('=' * 60);
      return;
    }

    // Token basic info
    debugPrint('🎫 Token Length: ${idToken.length} characters');
    debugPrint('🎫 Token Start: ${idToken.substring(0, 50)}...');
    debugPrint('🎫 Token End: ...${idToken.substring(idToken.length - 20)}');

    // Full token (only in debug assertions)
    assert(() {
      debugPrint('🔓 FULL FIREBASE ID TOKEN:');
      debugPrint(idToken);
      return true;
    }());

    // Decode JWT payload
    _decodeAndLogJwtPayload(idToken, 'FIREBASE');

    debugPrint('=' * 60);
  }

  /// Logs access token information
  static void logAccessToken(String? accessToken) {
    if (!kDebugMode) return;

    if (accessToken == null || accessToken.isEmpty) {
      debugPrint('🔑 Access Token: NULL or EMPTY');
      return;
    }

    debugPrint('🔑 Access Token Length: ${accessToken.length} characters');
    debugPrint('🔑 Access Token Start: ${accessToken.substring(0, 30)}...');

    assert(() {
      debugPrint('🔓 FULL ACCESS TOKEN: $accessToken');
      return true;
    }());
  }

  /// Logs API request details
  static void logApiRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? payload,
    Map<String, String>? headers,
  }) {
    if (!kDebugMode) return;

    debugPrint('=' * 60);
    debugPrint('🌐 API REQUEST');
    debugPrint('=' * 60);
    debugPrint('📍 Endpoint: $endpoint');
    debugPrint('🔧 Method: $method');

    if (headers != null && headers.isNotEmpty) {
      debugPrint('📋 Headers:');
      headers.forEach((key, value) {
        debugPrint('  $key: $value');
      });
    }

    if (payload != null && payload.isNotEmpty) {
      debugPrint('📦 Payload:');
      final payloadJson = jsonEncode(payload);
      debugPrint('  Size: ${payloadJson.length} bytes');
      debugPrint('  Content: $payloadJson');
    }

    debugPrint('⏳ Sending request...');
    debugPrint('=' * 60);
  }

  /// Logs API response details
  static void logApiResponse({
    required String endpoint,
    required int statusCode,
    dynamic responseBody,
    Map<String, dynamic>? headers,
  }) {
    if (!kDebugMode) return;

    debugPrint('=' * 60);
    debugPrint('📥 API RESPONSE');
    debugPrint('=' * 60);
    debugPrint('📍 Endpoint: $endpoint');
    debugPrint('📊 Status Code: $statusCode');

    if (headers != null && headers.isNotEmpty) {
      debugPrint('📋 Headers:');
      headers.forEach((key, value) {
        debugPrint('  $key: $value');
      });
    }

    if (responseBody != null) {
      final bodyString = responseBody.toString();
      debugPrint('📦 Response Body:');
      debugPrint('  Length: ${bodyString.length} characters');
      debugPrint('  Content: $bodyString');
    }

    if (statusCode >= 200 && statusCode < 300) {
      debugPrint('✅ Request successful');
    } else if (statusCode >= 400) {
      debugPrint('❌ Request failed');
    }

    debugPrint('=' * 60);
  }

  /// Decodes JWT token and logs its payload
  static void _decodeAndLogJwtPayload(String idToken, [String tokenType = '']) {
    try {
      final parts = idToken.split('.');
      if (parts.length != 3) {
        debugPrint(
          '❌ Invalid JWT format (expected 3 parts, got ${parts.length})',
        );
        return;
      }

      // Decode header
      final header = _decodeBase64Part(parts[0]);
      debugPrint('📋 JWT Header: $header');

      // Decode payload
      final payload = _decodeBase64Part(parts[1]);
      final payloadMap = jsonDecode(payload) as Map<String, dynamic>;

      debugPrint('📋 $tokenType JWT Payload Information:');
      payloadMap.forEach((key, value) {
        if (key == 'iat' || key == 'exp') {
          // Convert timestamp to readable date
          final timestamp = value as int? ?? 0;
          final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
          debugPrint('  $key: $value ($date)');
        } else if (key == 'aud') {
          debugPrint('  $key (audience): $value ⚠️ CRITICAL FOR BACKEND');
        } else {
          debugPrint('  $key: $value');
        }
      });

      // Signature info
      debugPrint(
        '🔒 Signature: ${parts[2].substring(0, 20)}... (${parts[2].length} chars)',
      );
    } catch (e) {
      debugPrint('❌ Failed to decode JWT: $e');
    }
  }

  /// Helper to decode base64 JWT parts
  static String _decodeBase64Part(String part) {
    // Add padding if needed
    final normalized = base64.normalize(part);
    return utf8.decode(base64.decode(normalized));
  }
}
