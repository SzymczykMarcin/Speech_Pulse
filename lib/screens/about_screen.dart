import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/pulse_widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          const SurfacePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionLabel('Links'),
                SizedBox(height: 12),
                Text(
                  'Buy Me a Coffee: https://buymeacoffee.com/marcinszymczyk',
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
