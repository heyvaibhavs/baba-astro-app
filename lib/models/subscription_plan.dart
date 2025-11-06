/// Model for subscription plan returned by /api/subscriptions/plans
class SubscriptionPlan {
  final String planId;
  final String label;
  final String currency;
  final double price;
  final double priceAfterTax;
  final double? strikePrice;
  final double? trialPrice;
  final bool freeTrial;
  final int validityInDays;
  final String billingCycle;
  final bool autoRenew;

  SubscriptionPlan({
    required this.planId,
    required this.label,
    required this.currency,
    required this.price,
    required this.priceAfterTax,
    this.strikePrice,
    this.trialPrice,
    required this.freeTrial,
    required this.validityInDays,
    required this.billingCycle,
    required this.autoRenew,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is int) return v.toDouble();
      if (v is double) return v;
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return SubscriptionPlan(
      planId: json['planId'] ?? '',
      label: json['label'] ?? '',
      currency: json['currency'] ?? 'INR',
      price: _toDouble(json['price']),
      priceAfterTax: _toDouble(json['priceAfterTax']),
      strikePrice: json['strikePrice'] != null
          ? _toDouble(json['strikePrice'])
          : null,
      trialPrice: json['trialPrice'] != null
          ? _toDouble(json['trialPrice'])
          : null,
      freeTrial: json['freeTrial'] ?? false,
      validityInDays: json['validityInDays'] ?? 0,
      billingCycle: json['billingCycle'] ?? 'monthly',
      autoRenew: json['autoRenew'] ?? true,
    );
  }
}
