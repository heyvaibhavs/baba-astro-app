import 'package:flutter/material.dart';
import '../models/subscription_plan.dart';

class SubscriptionTile extends StatelessWidget {
  final SubscriptionPlan plan;
  final VoidCallback? onSubscribe;
  final bool trialEligible;

  const SubscriptionTile({
    Key? key,
    required this.plan,
    this.onSubscribe,
    this.trialEligible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(plan.label),
                  const SizedBox(height: 6),
                  Text(
                    '${plan.currency} ${plan.priceAfterTax.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (plan.strikePrice != null)
                    Text(
                      '${plan.currency} ${plan.strikePrice!.toStringAsFixed(0)}',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 6),
                  if (trialEligible && plan.freeTrial)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Free Trial',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    '${plan.validityInDays} days • ${plan.billingCycle}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onSubscribe,
              child: Text(
                trialEligible && plan.freeTrial ? 'Start Trial' : 'Subscribe',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
