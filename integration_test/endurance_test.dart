import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_pulse/debug_log.dart';
import 'package:speech_pulse/models/app_settings.dart';
import 'package:speech_pulse/models/person.dart';
import 'package:speech_pulse/screens/meeting_setup_screen.dart';
import 'package:speech_pulse/services/app_store.dart';
import 'package:speech_pulse/theme.dart';

const _defaultMinutes = 150;
const _defaultIntervalSeconds = 30;
const _defaultPeople = 8;
const _defaultUndoEvery = 25;

int _intFromEnvironment(String name, int fallback) {
  const values = {
    'ENDURANCE_MINUTES': String.fromEnvironment('ENDURANCE_MINUTES'),
    'ENDURANCE_INTERVAL_SECONDS':
        String.fromEnvironment('ENDURANCE_INTERVAL_SECONDS'),
    'ENDURANCE_PEOPLE': String.fromEnvironment('ENDURANCE_PEOPLE'),
    'ENDURANCE_UNDO_EVERY': String.fromEnvironment('ENDURANCE_UNDO_EVERY'),
  };
  return int.tryParse(values[name] ?? '') ?? fallback;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'long meeting endurance flow',
    (tester) async {
      final minutes = _intFromEnvironment(
        'ENDURANCE_MINUTES',
        _defaultMinutes,
      );
      final intervalSeconds = _intFromEnvironment(
        'ENDURANCE_INTERVAL_SECONDS',
        _defaultIntervalSeconds,
      );
      final peopleCount = _intFromEnvironment(
        'ENDURANCE_PEOPLE',
        _defaultPeople,
      );
      final undoEvery = _intFromEnvironment(
        'ENDURANCE_UNDO_EVERY',
        _defaultUndoEvery,
      );

      final people = [
        for (var index = 1; index <= peopleCount; index++)
          Person(id: 'speaker-$index', name: 'Speaker $index'),
      ];
      SharedPreferences.setMockInitialValues({
        'people': Person.encodeList(people),
        'countButtonOption': CountButtonOption.hotelBell.name,
        'themePreference': AppThemePreference.dark.name,
      });

      final store = AppStore();
      await store.load();

      await tester.pumpWidget(
        MaterialApp(
          theme: buildPulseTheme(Brightness.light),
          darkTheme: buildPulseTheme(Brightness.dark),
          themeMode: ThemeMode.dark,
          home: MeetingSetupScreen(store: store),
        ),
      );
      await tester.pumpAndSettle();

      appDebugLog(
        'Endurance setup: minutes=$minutes, interval=${intervalSeconds}s, '
        'people=$peopleCount, undoEvery=$undoEvery',
      );

      await tester.tap(find.text('Select all'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('startCountingButton')));
      await tester.pumpAndSettle();

      final deadline = DateTime.now().add(Duration(minutes: minutes));
      final interval = Duration(seconds: intervalSeconds);
      var clicks = 0;
      var speakerIndex = 0;

      while (DateTime.now().isBefore(deadline)) {
        clicks++;

        if (clicks % 10 == 1) {
          speakerIndex = (speakerIndex % peopleCount) + 1;
          final speaker = 'Speaker $speakerIndex';
          final speakerFinder = find.text(speaker).first;
          if (speakerFinder.evaluate().isNotEmpty) {
            await tester.tap(speakerFinder);
            await tester.pump();
            appDebugLog('Endurance selected $speaker');
          }
        }

        await tester.tap(find.byKey(const Key('countButton')));
        await tester.pump();
        appDebugLog('Endurance AH click $clicks');

        if (undoEvery > 0 && clicks % undoEvery == 0) {
          final undo = find.byKey(const Key('undoButton'));
          if (undo.evaluate().isNotEmpty) {
            await tester.tap(undo);
            await tester.pump();
            appDebugLog('Endurance undo after click $clicks');
          }
        }

        await Future<void>.delayed(interval);
        await tester.pump();
      }

      appDebugLog('Endurance finishing after $clicks AH clicks');
      await tester.tap(find.text('End Meeting'));
      await tester.pumpAndSettle();

      expect(find.text('Meeting Report'), findsOneWidget);
      expect(find.textContaining('filler sounds'), findsWidgets);

      appDebugLog('Endurance report reached successfully');
    },
    timeout: Timeout.none,
  );
}
