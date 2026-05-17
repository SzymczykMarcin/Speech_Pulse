import 'package:flutter/material.dart';

import '../debug_log.dart';
import '../models/app_settings.dart';
import '../services/app_store.dart';
import '../theme.dart';
import '../widgets/pulse_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.store});

  final AppStore store;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppSettings get _settings => widget.store.settings;

  Future<void> _save(AppSettings settings) async {
    appDebugLog(
      'Settings: save requested theme=${settings.themePreference.name}, '
      'button=${settings.countButtonOption.name}',
    );
    await widget.store.updateSettings(settings);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PulsePage(
      child: ListView(
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: context.pulseOnSurface,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 24),
          SurfacePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionLabel('AH Button & Sound'),
                const SizedBox(height: 16),
                for (final option in CountButtonOption.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ButtonOptionTile(
                      option: option,
                      selected: _settings.countButtonOption == option,
                      onTap: () => _save(
                        _settings.copyWith(countButtonOption: option),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SurfacePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionLabel('Theme'),
                const SizedBox(height: 12),
                SegmentedButton<AppThemePreference>(
                  segments: const [
                    ButtonSegment(
                        value: AppThemePreference.dark, label: Text('Dark')),
                    ButtonSegment(
                        value: AppThemePreference.light, label: Text('Light')),
                    ButtonSegment(
                        value: AppThemePreference.system,
                        label: Text('System')),
                  ],
                  selected: {_settings.themePreference},
                  onSelectionChanged: (values) => _save(
                    _settings.copyWith(themePreference: values.first),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtonOptionTile extends StatelessWidget {
  const _ButtonOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final CountButtonOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: false,
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Material(
        color: selected ? context.pulseSecondary : context.pulseSurfaceHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? context.pulseSecondary : context.pulsePanelBorder,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Image.asset(option.iconAsset, width: 52, height: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  option.label,
                  style: TextStyle(
                    color: selected
                        ? PulseColors.background
                        : context.pulseOnSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected
                    ? PulseColors.background
                    : context.pulseOnSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
