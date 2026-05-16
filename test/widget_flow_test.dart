import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_pulse/models/person.dart';
import 'package:speech_pulse/screens/active_meeting_screen.dart';
import 'package:speech_pulse/screens/meeting_setup_screen.dart';
import 'package:speech_pulse/services/app_store.dart';
import 'package:speech_pulse/theme.dart';

void main() {
  Future<AppStore> loadedStore({List<Person> people = const []}) async {
    SharedPreferences.setMockInitialValues({
      'people': Person.encodeList(people),
    });
    final store = AppStore();
    await store.load();
    return store;
  }

  testWidgets('meeting setup enables start counting after selection',
      (tester) async {
    final store = await loadedStore(
      people: const [Person(id: 'anna', name: 'Anna')],
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: buildPulseTheme(Brightness.dark),
        home: MeetingSetupScreen(store: store),
      ),
    );

    final button = tester.widget<ElevatedButton>(
      find.byKey(const Key('startCountingButton')),
    );
    expect(button.onPressed, isNull);

    await tester.tap(find.text('Anna'));
    await tester.pumpAndSettle();

    final enabledButton = tester.widget<ElevatedButton>(
      find.byKey(const Key('startCountingButton')),
    );
    expect(enabledButton.onPressed, isNotNull);
  });

  testWidgets('active meeting increments and undoes counts', (tester) async {
    final store = await loadedStore();
    final playedOptions = <Object>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: buildPulseTheme(Brightness.dark),
        home: ActiveMeetingScreen(
          store: store,
          playCountSound: (option) async => playedOptions.add(option),
          participants: const [
            Person(id: 'anna', name: 'Anna'),
            Person(id: 'david', name: 'David'),
          ],
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('countButton')));
    await tester.pump();

    expect(find.text('Last: Anna +1'), findsOneWidget);
    expect(playedOptions, hasLength(1));

    await tester.tap(find.text('David').first);
    await tester.pump();
    expect(playedOptions, hasLength(1));
    await tester.tap(find.byKey(const Key('countButton')));
    await tester.pump();
    expect(playedOptions, hasLength(2));
    await tester.tap(find.byKey(const Key('undoButton')));
    await tester.pump();

    expect(find.text('Last: Anna +1'), findsOneWidget);
    expect(playedOptions, hasLength(2));
  });

  testWidgets('active meeting participant chips wrap inside bounded area',
      (tester) async {
    final store = await loadedStore();
    await tester.pumpWidget(
      MaterialApp(
        theme: buildPulseTheme(Brightness.dark),
        home: ActiveMeetingScreen(
          store: store,
          playCountSound: (_) async {},
          participants: [
            for (var index = 0; index < 24; index++)
              Person(id: 'person-$index', name: 'Person $index'),
          ],
        ),
      ),
    );

    final selectorBox = tester.renderObject<RenderBox>(
      find.byKey(const Key('participantSelector')),
    );
    final countButtonBox = tester.renderObject<RenderBox>(
      find.byKey(const Key('countButton')),
    );
    final selectorBottom =
        selectorBox.localToGlobal(Offset.zero).dy + selectorBox.size.height;
    final countButtonTop = countButtonBox.localToGlobal(Offset.zero).dy;

    expect(selectorBox.size.height, lessThanOrEqualTo(124));
    expect(selectorBottom, lessThan(countButtonTop));
  });
}
