import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/subscription_plans_response.dart';

class SubscriptionService {
  static const String _logTag = 'SubscriptionService';

  Future<SubscriptionPlansResponse> fetchPlans(String token) async {
    final endpoint = '${AppConstants.baseUrl}/api/subscriptions/plans';
    developer.log('Fetching subscription plans from $endpoint', name: _logTag);

    try {
      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      developer.log('Status code: ${response.statusCode}', name: _logTag);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return SubscriptionPlansResponse.fromJson(data);
      } else {
        throw Exception('Failed to fetch plans: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      developer.log('Network error: ${e.toString()}', name: _logTag);
      rethrow;
    } catch (e) {
      developer.log('Error fetching plans: ${e.toString()}', name: _logTag);
      rethrow;
    }
  }
}
