import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for fetching horoscope data from the API
class HoroscopeService {
  static const String _baseUrl =
      'https://horoscope-app-api.vercel.app/api/v1/get-horoscope/daily';

  /// Available zodiac signs
  static const List<String> zodiacSigns = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];

  /// Get horoscope for a specific sign and day
  static Future<HoroscopeResponse> getHoroscope({
    required String sign,
    required String day,
  }) async {
    try {
      final url = '$_baseUrl?sign=${sign.toLowerCase()}&day=$day';
      print('📡 Fetching horoscope from: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return HoroscopeResponse.fromJson(data);
      } else {
        throw Exception('Failed to fetch horoscope: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching horoscope: $e');
      rethrow;
    }
  }

  /// Convert date from DD-MM-YYYY to YYYY-MM-DD format
  static String formatDateForAPI(String date) {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        final day = parts[0];
        final month = parts[1];
        final year = parts[2];
        return '$year-$month-$day';
      }
      return date;
    } catch (e) {
      print('❌ Error formatting date: $e');
      return date;
    }
  }

  /// Convert date from YYYY-MM-DD to DD-MM-YYYY format
  static String formatDateFromAPI(String date) {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        final year = parts[0];
        final month = parts[1];
        final day = parts[2];
        return '$day-$month-$year';
      }
      return date;
    } catch (e) {
      print('❌ Error formatting date from API: $e');
      return date;
    }
  }

  /// Get formatted date for today, tomorrow, or yesterday
  static String getFormattedDate(String type) {
    final now = DateTime.now();
    DateTime targetDate;

    switch (type.toUpperCase()) {
      case 'TODAY':
        targetDate = now;
        break;
      case 'TOMORROW':
        targetDate = now.add(const Duration(days: 1));
        break;
      case 'YESTERDAY':
        targetDate = now.subtract(const Duration(days: 1));
        break;
      default:
        targetDate = now;
    }

    return '${targetDate.year.toString().padLeft(4, '0')}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';
  }
}

/// Model for horoscope API response
class HoroscopeResponse {
  final HoroscopeData data;
  final int status;
  final bool success;

  HoroscopeResponse({
    required this.data,
    required this.status,
    required this.success,
  });

  factory HoroscopeResponse.fromJson(Map<String, dynamic> json) {
    return HoroscopeResponse(
      data: HoroscopeData.fromJson(json['data']),
      status: json['status'],
      success: json['success'],
    );
  }
}

/// Model for horoscope data
class HoroscopeData {
  final String date;
  final String horoscopeData;

  HoroscopeData({required this.date, required this.horoscopeData});

  factory HoroscopeData.fromJson(Map<String, dynamic> json) {
    return HoroscopeData(
      date: json['date'],
      horoscopeData: json['horoscope_data'],
    );
  }
}
