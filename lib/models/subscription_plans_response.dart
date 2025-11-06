import 'subscription_plan.dart';

/// Response wrapper for plans endpoint
class SubscriptionPlansResponse {
  final List<SubscriptionPlan> plans;
  final bool trialEligible;
  final Map<String, dynamic>? meta;

  SubscriptionPlansResponse({
    required this.plans,
    required this.trialEligible,
    this.meta,
  });

  factory SubscriptionPlansResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final plansJson = (data['plans'] ?? []) as List<dynamic>;
    final plans = plansJson
        .map((p) => SubscriptionPlan.fromJson(p as Map<String, dynamic>))
        .toList();
    final meta = data['meta'] as Map<String, dynamic>?;
    final trialEligible = meta != null
        ? (meta['trialEligible'] ?? false)
        : false;
    return SubscriptionPlansResponse(
      plans: plans,
      trialEligible: trialEligible,
      meta: meta,
    );
  }
}
