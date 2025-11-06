import 'dart:convert';
import 'package:flutter/services.dart';

/// Service to load and manage cities data
class CitiesService {
  static List<String>? _cachedCities;

  /// Load cities from JSON file
  static Future<List<String>> loadCities() async {
    // Return cached cities if already loaded
    if (_cachedCities != null) {
      return _cachedCities!;
    }

    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString('cities.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Extract the cities array
      final List<dynamic> citiesList = jsonData['data'] as List<dynamic>;

      // Convert to List<String> and cache it
      _cachedCities = citiesList.map((city) => city.toString()).toList();

      return _cachedCities!;
    } catch (e) {
      // If there's an error loading cities, return an empty list
      print('Error loading cities: $e');
      return [];
    }
  }

  /// Search cities by query
  static List<String> searchCities(List<String> cities, String query) {
    if (query.isEmpty) {
      return cities;
    }

    final lowerQuery = query.toLowerCase();
    return cities.where((city) {
      return city.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Clear cached cities (useful for testing)
  static void clearCache() {
    _cachedCities = null;
  }
}
