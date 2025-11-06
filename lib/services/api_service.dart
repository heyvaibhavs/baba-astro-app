import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/api_models.dart';
import '../utils/mock_api_service.dart';

/// API service for handling network requests
class ApiService {
  static const String _logTag = 'ApiService';
  static const String _baseUrl = AppConstants.baseUrl;

  // Set to true to use mock responses when API is not available
  static const bool _useMockMode = false; // DISABLED - Using real API

  /// Headers for API requests
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Headers with authorization token
  Map<String, String> _headersWithAuth(String token) => {
    ..._headers,
    'Authorization': 'Bearer $token',
  };

  /// Google authentication
  Future<AuthResponse> googleAuth(String idToken) async {
    final endpoint = '$_baseUrl${AppConstants.googleAuthEndpoint}';
    developer.log(
      '🚀 API CALL: Starting Google Auth API request',
      name: _logTag,
    );
    developer.log('🌐 API ENDPOINT: $endpoint', name: _logTag);
    developer.log('🔧 Mock mode enabled: $_useMockMode', name: _logTag);
    developer.log(
      '🎫 ID Token length: ${idToken.length} characters',
      name: _logTag,
    );
    developer.log(
      '🎫 ID Token preview (first 100 chars): ${idToken.substring(0, idToken.length > 100 ? 100 : idToken.length)}...',
      name: _logTag,
    );

    print('🚀 API CALL: Starting Google Auth API request');
    print('🌐 API ENDPOINT: $endpoint');
    print('🔧 Mock mode enabled: $_useMockMode');
    print('🎫 ID Token length: ${idToken.length} characters');

    // Use mock response if in mock mode
    if (_useMockMode) {
      developer.log('❌❌❌ MOCK MODE IS ENABLED - THIS IS WRONG!', name: _logTag);
      print('❌❌❌ MOCK MODE IS ENABLED - THIS IS WRONG!');
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay
      developer.log(
        '✅ MOCK RESPONSE: Generated mock auth response',
        name: _logTag,
      );
      print('✅ MOCK RESPONSE: Generated mock auth response');
      return MockApiService.createMockAuthResponse(
        'test@gumbotech.in',
        'Test User',
      );
    }

    developer.log('✅✅✅ REAL API MODE - Calling localhost:3000', name: _logTag);
    print('✅✅✅ REAL API MODE - Calling localhost:3000');

    try {
      developer.log(
        '📤 HTTP REQUEST: Preparing POST request to Google Auth endpoint',
        name: _logTag,
      );
      developer.log('📋 REQUEST HEADERS: $_headers', name: _logTag);
      print('📤 HTTP REQUEST: Sending POST to $endpoint');
      print('📤 THIS IS A REAL HTTP CALL TO YOUR BACKEND!');

      final requestBody = jsonEncode({'idToken': idToken});
      developer.log('📦 REQUEST PAYLOAD (full): $requestBody', name: _logTag);
      developer.log(
        '📊 PAYLOAD SIZE: ${requestBody.length} bytes',
        name: _logTag,
      );
      print('📦 REQUEST PAYLOAD SIZE: ${requestBody.length} bytes');
      print('📦 Sending REAL Google ID Token to backend...');

      developer.log('⏳ CALLING http.post() NOW...', name: _logTag);
      print('⏳ CALLING http.post() NOW...');
      print('⏳ URL: $endpoint');
      print('⏳ Headers: $_headers');
      print('⏳ Body contains Google idToken: ${idToken.substring(0, 50)}...');

      final response = await http.post(
        Uri.parse(endpoint),
        headers: _headers,
        body: requestBody,
      );

      developer.log(
        '📥 HTTP RESPONSE RECEIVED FROM YOUR BACKEND!',
        name: _logTag,
      );
      developer.log(
        '📊 Response Status Code: ${response.statusCode}',
        name: _logTag,
      );
      developer.log('📋 Response Headers: ${response.headers}', name: _logTag);
      developer.log('📦 Response Body: ${response.body}', name: _logTag);
      developer.log(
        '📏 Response Body Length: ${response.body.length} characters',
        name: _logTag,
      );

      print('📥 HTTP RESPONSE RECEIVED FROM YOUR BACKEND!');
      print('📊 Response Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');
      print('📏 Response Body Length: ${response.body.length} characters');

      if (response.statusCode == 200) {
        developer.log(
          '✅ SUCCESS: Google Auth API call successful',
          name: _logTag,
        );
        print('✅ SUCCESS: Google Auth API call successful');

        final data = jsonDecode(response.body);
        developer.log('📋 PARSED RESPONSE: $data', name: _logTag);
        developer.log(
          '🔍 Response contains ${data.keys.length} fields',
          name: _logTag,
        );
        print('🔍 Response contains ${data.keys.length} fields');

        final authResponse = AuthResponse.fromJson(data);
        developer.log(
          '✅ AUTH RESPONSE OBJECT CREATED SUCCESSFULLY',
          name: _logTag,
        );
        print('✅ AUTH RESPONSE OBJECT CREATED SUCCESSFULLY');
        return authResponse;
      } else {
        developer.log('❌ FAILURE: Google Auth API call failed', name: _logTag);
        developer.log('❌ Status Code: ${response.statusCode}', name: _logTag);
        developer.log('❌ Error Body: ${response.body}', name: _logTag);
        print('❌ FAILURE: API call failed with status ${response.statusCode}');

        throw ApiException(
          'Authentication failed',
          response.statusCode,
          response.body,
        );
      }
    } on SocketException catch (e, stackTrace) {
      developer.log(
        '🌐 NETWORK ERROR: Socket Exception in Google Auth',
        name: _logTag,
      );
      developer.log('🌐 Socket Exception: ${e.toString()}', name: _logTag);
      developer.log('📚 Stack Trace: $stackTrace', name: _logTag);
      developer.log(
        '🔄 FALLBACK: Using mock response due to network error',
        name: _logTag,
      );

      print('🌐 NETWORK ERROR: Socket Exception in Google Auth');
      print('🔄 FALLBACK: Using mock response due to network error');

      // Fallback to mock response
      return MockApiService.createMockAuthResponse(
        'fallback@gumbotech.in',
        'Fallback User',
      );
    } catch (e, stackTrace) {
      developer.log(
        '❌ EXCEPTION in Google Auth: ${e.toString()}',
        name: _logTag,
      );
      developer.log('🔍 Exception type: ${e.runtimeType}', name: _logTag);
      developer.log('📚 Stack trace: $stackTrace', name: _logTag);

      print('❌ EXCEPTION in Google Auth: ${e.toString()}');
      print('🔍 Exception type: ${e.runtimeType}');

      if (e is ApiException) rethrow;
      throw ApiException('Authentication failed', 0, e.toString());
    }
  }

  /// Submit onboarding data
  Future<OnboardingResponse> submitOnboarding(
    OnboardingRequest request,
    String token,
  ) async {
    final endpoint = '$_baseUrl${AppConstants.onboardingEndpoint}';
    developer.log('Starting Onboarding API call', name: _logTag);
    developer.log('Endpoint: $endpoint', name: _logTag);
    developer.log('Mock mode enabled: $_useMockMode', name: _logTag);
    developer.log(
      'Token (first 50 chars): ${token.substring(0, 50)}...',
      name: _logTag,
    );
    developer.log('Request data: ${request.toJson()}', name: _logTag);

    // Use mock response if in mock mode (you need to get user data from storage)
    if (_useMockMode) {
      developer.log('Using mock response for Onboarding', name: _logTag);
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      // Create a mock user for onboarding response
      // In real scenario, you'd get the current user from storage
      final mockUser = MockApiService.createMockAuthResponse(
        'test@gumbotech.in',
        'Test User',
      ).data.user;
      return MockApiService.createMockOnboardingResponse(
        mockUser,
        request.name,
        request.age,
        request.city,
        request.phoneNumber,
      );
    }

    try {
      final headers = _headersWithAuth(token);
      developer.log('Request headers: $headers', name: _logTag);

      final requestBody = jsonEncode(request.toJson());
      developer.log('Request body: $requestBody', name: _logTag);

      final response = await http.post(
        Uri.parse(endpoint),
        headers: headers,
        body: requestBody,
      );

      developer.log(
        'Onboarding Response Status Code: ${response.statusCode}',
        name: _logTag,
      );
      developer.log(
        'Onboarding Response Headers: ${response.headers}',
        name: _logTag,
      );
      developer.log(
        'Onboarding Response Body: ${response.body}',
        name: _logTag,
      );

      if (response.statusCode == 200) {
        developer.log('Onboarding API call successful', name: _logTag);
        final data = jsonDecode(response.body);
        return OnboardingResponse.fromJson(data);
      } else {
        developer.log(
          'Onboarding API call failed with status: ${response.statusCode}',
          name: _logTag,
        );
        throw ApiException(
          'Onboarding submission failed',
          response.statusCode,
          response.body,
        );
      }
    } on SocketException catch (e) {
      developer.log(
        'Socket Exception in Onboarding: ${e.toString()}',
        name: _logTag,
      );
      throw ApiException(
        'No internet connection',
        0,
        'Please check your internet connection and try again.',
      );
    } catch (e) {
      developer.log('Exception in Onboarding: ${e.toString()}', name: _logTag);
      developer.log('Exception type: ${e.runtimeType}', name: _logTag);
      if (e is ApiException) rethrow;
      throw ApiException('Onboarding submission failed', 0, e.toString());
    }
  }

  /// Get user config (including subscription status)
  Future<UserConfigResponse> getUserConfig(String token) async {
    final endpoint = '$_baseUrl${AppConstants.userConfigEndpoint}';
    developer.log('Starting getUserConfig API call', name: _logTag);
    developer.log('Endpoint: $endpoint', name: _logTag);
    developer.log(
      'Token (first 50 chars): ${token.substring(0, 50)}...',
      name: _logTag,
    );

    try {
      final headers = _headersWithAuth(token);
      developer.log('Request headers: $headers', name: _logTag);

      final response = await http.get(Uri.parse(endpoint), headers: headers);

      developer.log(
        'UserConfig Response Status Code: ${response.statusCode}',
        name: _logTag,
      );
      developer.log(
        'UserConfig Response Body: ${response.body}',
        name: _logTag,
      );

      if (response.statusCode == 200) {
        developer.log('UserConfig API call successful', name: _logTag);
        final data = jsonDecode(response.body);
        return UserConfigResponse.fromJson(data);
      } else {
        developer.log(
          'UserConfig API call failed with status: ${response.statusCode}',
          name: _logTag,
        );
        throw ApiException(
          'Failed to fetch user config',
          response.statusCode,
          response.body,
        );
      }
    } on SocketException catch (e) {
      developer.log(
        'Socket Exception in getUserConfig: ${e.toString()}',
        name: _logTag,
      );
      throw ApiException(
        'No internet connection',
        0,
        'Please check your internet connection and try again.',
      );
    } catch (e) {
      developer.log(
        'Exception in getUserConfig: ${e.toString()}',
        name: _logTag,
      );
      developer.log('Exception type: ${e.runtimeType}', name: _logTag);
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch user config', 0, e.toString());
    }
  }
}

/// Custom API exception
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String details;

  const ApiException(this.message, this.statusCode, this.details);

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode) - $details';
  }

  /// User-friendly error message
  String get userMessage {
    // Try to parse error message from response body
    try {
      final data = jsonDecode(details);
      if (data is Map && data['message'] != null) {
        final serverMessage = data['message'].toString();

        // Check for specific error patterns
        if (serverMessage.toLowerCase().contains('duplicate phone number') ||
            serverMessage.toLowerCase().contains(
              'phone number already exists',
            )) {
          return 'This phone number is already registered. Please use a different number or contact support.';
        }

        // Return server message if available
        return serverMessage;
      }
    } catch (e) {
      // If parsing fails, fall through to default messages
    }

    // Fallback to status code-based messages
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Authentication failed. Please try logging in again.';
      case 403:
        return 'Access denied. You don\'t have permission to perform this action.';
      case 404:
        return 'Service not found. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 0:
        return message; // Custom message for network errors
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
