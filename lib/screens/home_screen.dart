import 'package:flutter/material.dart';

import '../services/app_store.dart';
import '../theme.dart';
import '../widgets/pulse_widgets.dart';
import 'about_screen.dart';
import 'meeting_setup_screen.dart';
import 'people_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.store});

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Speech Pulse',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: PulseColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ah Counter for Speakers',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: PulseColors.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fast filler sound tracking for speaking meetings.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PulseColors.onSurfaceVariant,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 96,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.play_circle_fill, size: 36),
                      label: const Text('Start Meeting'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MeetingSetupScreen(store: store),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _HomeAction(
                    icon: Icons.groups,
                    label: 'People',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PeopleScreen(store: store),
                      ),
                    ),
                  ),
                  _HomeAction(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsScreen(store: store),
                      ),
                    ),
                  ),
                  _HomeAction(
                    icon: Icons.info_outline,
                    label: 'About',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        enableFeedback: false,
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SurfacePanel(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: PulseColors.surfaceVariant,
                foregroundColor: PulseColors.secondary,
                child: Icon(icon),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: PulseColors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: PulseColors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
