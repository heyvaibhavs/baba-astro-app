import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

/// Reusable App Header Widget
class AppHeader extends StatelessWidget {
  final VoidCallback? onWhatsAppTap;

  const AppHeader({super.key, this.onWhatsAppTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [_buildLogo(), const Spacer(), _buildWhatsAppButton()],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Image.asset('assets/images/ig_logo_jano.png', width: 40, height: 40),
        const SizedBox(width: 12),
        const Text(
          'Jano',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildWhatsAppButton() {
    return GestureDetector(
      onTap: onWhatsAppTap ?? _defaultWhatsAppHandler,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        child: SvgPicture.asset(
          'assets/images/whatsapp_vector.svg',
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  void _defaultWhatsAppHandler() async {
    const url = 'https://wa.me/1234567890';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
