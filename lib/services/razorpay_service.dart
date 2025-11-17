import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// Minimal Razorpay helper for a simple ₹3 one-time payment
class RazorpayService {
  RazorpayService._internal();
  static final RazorpayService _instance = RazorpayService._internal();
  factory RazorpayService() => _instance;

  Razorpay? _razorpay;

  void init({
    required void Function(PaymentSuccessResponse) onSuccess,
    required void Function(PaymentFailureResponse) onError,
    void Function(ExternalWalletResponse)? onExternalWallet,
  }) {
    dispose();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, onError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet ?? (res) {});
  }

  /// Opens Razorpay checkout with a fixed ₹3 amount (300 paise)
  void openCheckout({
    required BuildContext context,
    String merchantName = 'Baba App',
    String description = 'Premium Subscription',
    String? email,
    String? contact,
    String? customerName,
  }) {
    final options = {
      'key': 'rzp_live_EWIcFTdUd0CymA', // Provided API key (live)
      'amount': 300, // paise -> ₹3
      'name': merchantName,
      'description': description,
      'timeout': 120, // seconds
      'retry': {'enabled': false},
      'send_sms_hash': true,
      'prefill': {
        if (customerName != null && customerName.isNotEmpty)
          'name': customerName,
        'email': email ?? '',
        'contact': contact ?? '',
      },
      'notes': {
        if (customerName != null && customerName.isNotEmpty)
          'customer_name': customerName,
      },
      // You can set currency explicitly if needed: 'currency': 'INR'
    };

    try {
      _razorpay?.open(options);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to open payment: $e')));
    }
  }

  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
  }
}
