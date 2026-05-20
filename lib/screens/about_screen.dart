import 'package:flutter/material.dart';

import '../services/support_purchase_service.dart';
import '../theme.dart';
import '../widgets/pulse_widgets.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final SupportPurchaseService _supportPurchaseService;

  @override
  void initState() {
    super.initState();
    _supportPurchaseService = SupportPurchaseService()..load();
    _supportPurchaseService.addListener(_onSupportPurchaseChanged);
  }

  @override
  void dispose() {
    _supportPurchaseService.removeListener(_onSupportPurchaseChanged);
    _supportPurchaseService.dispose();
    super.dispose();
  }

  void _onSupportPurchaseChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _buySupport() async {
    await _supportPurchaseService.buySupport();
    if (!mounted) {
      return;
    }

    final message = _supportPurchaseService.message;
    if (message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final supportProduct = _supportPurchaseService.supportProduct;
    final supportButtonLabel = supportProduct == null
        ? 'Support Developer'
        : 'Support Developer ${supportProduct.price}';

    return PulsePage(
      child: ListView(
        children: [
          Text(
            'About',
            style: TextStyle(
              color: context.pulseOnSurface,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          const SurfacePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Created by Marcin, a QA and test automation engineer, public speaking practitioner, and builder of practical tools for speaking meetings.',
                  style: TextStyle(fontSize: 16, height: 1.45),
                ),
                SizedBox(height: 16),
                Text(
                  'Speech Pulse is an independent app for public speaking clubs and meeting roles.',
                  style: TextStyle(fontSize: 16, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SurfacePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel('Disclaimer'),
                SizedBox(height: 12),
                Text(
                  'This app is not affiliated with, endorsed by, or sponsored by Toastmasters International or any public speaking organization.',
                  style: TextStyle(fontSize: 16, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SurfacePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('Support'),
                const SizedBox(height: 12),
                Text(
                  'Speech Pulse is free to use. This optional purchase supports continued development and does not unlock extra features.',
                  style: TextStyle(
                    color: context.pulseOnSurface,
                    fontSize: 16,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: _supportPurchaseService.purchaseInProgress
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.favorite),
                    label: Text(supportButtonLabel),
                    onPressed: _supportPurchaseService.canPurchase
                        ? _buySupport
                        : null,
                  ),
                ),
                if (_supportPurchaseService.loading ||
                    _supportPurchaseService.message != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _supportPurchaseService.loading
                        ? 'Checking Google Play Billing...'
                        : _supportPurchaseService.message!,
                    style: TextStyle(
                      color: context.pulseOnSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          const SurfacePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel('Links'),
                SizedBox(height: 12),
                Text(
                  'Privacy policy: see the Google Play listing or project documentation.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Privacy: participant names and preferences stay on this device. Speech Pulse does not use accounts, analytics, ads, cloud sync, or telemetry.',
            style:
                TextStyle(color: context.pulseOnSurfaceVariant, height: 1.45),
          ),
        ],
      ),
    );
  }
}
