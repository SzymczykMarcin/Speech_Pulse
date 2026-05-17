import 'package:flutter/material.dart';

import 'debug_log.dart';
import 'models/app_settings.dart';
import 'screens/home_screen.dart';
import 'services/app_store.dart';
import 'theme.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    appDebugLog('Flutter error: ${details.exceptionAsString()}');
  };
  appDebugLog('App starting');
  runApp(SpeechPulseApp(store: AppStore()));
}

class SpeechPulseApp extends StatefulWidget {
  const SpeechPulseApp({super.key, required this.store});

  final AppStore store;

  @override
  State<SpeechPulseApp> createState() => _SpeechPulseAppState();
}

class _SpeechPulseAppState extends State<SpeechPulseApp> {
  @override
  void initState() {
    super.initState();
    appDebugLog('SpeechPulseApp initState: loading store');
    widget.store.load();
    widget.store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    widget.store.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    appDebugLog(
      'Store changed: loaded=${widget.store.loaded}, '
      'theme=${widget.store.settings.themePreference.name}, '
      'button=${widget.store.settings.countButtonOption.name}, '
      'people=${widget.store.people.length}',
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final preference = widget.store.settings.themePreference;
    return MaterialApp(
      title: 'Speech Pulse',
      debugShowCheckedModeBanner: false,
      theme: buildPulseTheme(Brightness.light),
      darkTheme: buildPulseTheme(Brightness.dark),
      themeMode: switch (preference) {
        AppThemePreference.light => ThemeMode.light,
        AppThemePreference.system => ThemeMode.system,
        AppThemePreference.dark => ThemeMode.dark,
      },
      home: widget.store.loaded
          ? HomeScreen(store: widget.store)
          : const _LoadingScreen(),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Speech Pulse',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
