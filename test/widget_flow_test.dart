import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_pulse/models/app_settings.dart';
import 'package:speech_pulse/models/person.dart';
import 'package:speech_pulse/screens/active_meeting_screen.dart';
import 'package:speech_pulse/screens/about_screen.dart';
import 'package:speech_pulse/screens/home_screen.dart';
import 'package:speech_pulse/screens/meeting_setup_screen.dart';
import 'package:speech_pulse/screens/people_screen.dart';
import 'package:speech_pulse/screens/settings_screen.dart';
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

  Widget testApp(Widget home) {
    return MaterialApp(
      theme: buildPulseTheme(Brightness.light),
      darkTheme: buildPulseTheme(Brightness.dark),
      themeMode: ThemeMode.dark,
      home: home,
    );
  }

  void usePhoneViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('home meeting flow reaches report screen', (tester) async {
    usePhoneViewport(tester);
    final store = await loadedStore(
      people: const [Person(id: 'anna', name: 'Anna')],
    );
    await tester.pumpWidget(testApp(HomeScreen(store: store)));

    await tester.tap(find.text('Start Meeting'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Anna'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('startCountingButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('End Meeting'));
    await tester.pumpAndSettle();

    expect(find.text('Meeting Report'), findsOneWidget);
    expect(find.text('Anna'), findsOneWidget);
    expect(find.text('0 filler sounds'), findsOneWidget);
  });

  testWidgets('meeting setup enables start counting after selection',
      (tester) async {
    final store = await loadedStore(
      people: const [Person(id: 'anna', name: 'Anna')],
    );
    await tester.pumpWidget(testApp(MeetingSetupScreen(store: store)));

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
      testApp(
        ActiveMeetingScreen(
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
      testApp(
        ActiveMeetingScreen(
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

  testWidgets('people screen adds edits and deletes a saved person',
      (tester) async {
    final store = await loadedStore();
    await tester.pumpWidget(testApp(PeopleScreen(store: store)));

    await tester.tap(find.text('Add Person'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Alice');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Alice'), findsOneWidget);
    expect(store.people.single.name, 'Alice');

    await tester.tap(find.byTooltip('Edit Alice'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), 'Alicia');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Alice'), findsNothing);
    expect(find.text('Alicia'), findsOneWidget);
    expect(store.people.single.name, 'Alicia');

    await tester.tap(find.byTooltip('Delete Alicia'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Alicia'), findsNothing);
    expect(find.text('No saved people yet.'), findsOneWidget);
    expect(store.people, isEmpty);
  });

  testWidgets('settings screen changes button style and theme',
      (tester) async {
    final store = await loadedStore();
    await tester.pumpWidget(testApp(SettingsScreen(store: store)));

    await tester.tap(find.text('Live Duck'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();

    expect(store.settings.countButtonOption, CountButtonOption.liveDuck);
    expect(store.settings.themePreference, AppThemePreference.light);

    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString('countButtonOption'),
      CountButtonOption.liveDuck.name,
    );
    expect(
      preferences.getString('themePreference'),
      AppThemePreference.light.name,
    );
  });

  testWidgets('about screen shows public contact email', (tester) async {
    usePhoneViewport(tester);
    await tester.pumpWidget(testApp(const AboutScreen()));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Contact: marcin.szymczyk@solutionsms.pl'),
      160,
    );

    expect(
      find.text('Contact: marcin.szymczyk@solutionsms.pl'),
      findsOneWidget,
    );
  });
}
