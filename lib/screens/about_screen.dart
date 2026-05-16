import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/pulse_widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PulsePage(
      child: ListView(
        children: const [
          Text(
            'About',
            style: TextStyle(
              color: PulseColors.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 24),
          SurfacePanel(
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
          SizedBox(height: 16),
          SurfacePanel(
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
          SizedBox(height: 16),
          SurfacePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel('Links'),
                SizedBox(height: 12),
                Text('Author website: https://example.com/marcin'),
                SizedBox(height: 8),
                Text('Buy Me a Coffee: https://buymeacoffee.com/placeholder'),
              ],
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Privacy: participant names and preferences stay on this device. Speech Pulse does not use accounts, analytics, ads, cloud sync, or telemetry.',
            style: TextStyle(color: PulseColors.onSurfaceVariant, height: 1.45),
          ),
        ],
      ),
    );
  }
}
