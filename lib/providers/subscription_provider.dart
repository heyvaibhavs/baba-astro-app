import 'package:flutter/foundation.dart';
import '../models/subscription_plan.dart';
import '../services/subscription_service.dart';

/// Provider to fetch and hold subscription plans
class SubscriptionProvider with ChangeNotifier {
  final SubscriptionService _service = SubscriptionService();
  List<SubscriptionPlan> _plans = [];
  bool _isLoading = false;
  String? _error;
  bool _trialEligible = false;
  Map<String, dynamic>? _meta;

  List<SubscriptionPlan> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get trialEligible => _trialEligible;
  Map<String, dynamic>? get meta => _meta;

  Future<void> fetchPlans(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final resp = await _service.fetchPlans(token);
      _plans = resp.plans;
      _trialEligible = resp.trialEligible;
      _meta = resp.meta;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
