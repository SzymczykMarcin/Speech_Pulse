import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_pulse/models/app_settings.dart';
import 'package:speech_pulse/models/person.dart';
import 'package:speech_pulse/services/app_store.dart';

void main() {
  Future<AppStore> loadStore(Map<String, Object> initialValues) async {
    SharedPreferences.setMockInitialValues(initialValues);
    final store = AppStore();
    await store.load();
    return store;
  }

  test('loads valid people and settings from local preferences', () async {
    final store = await loadStore({
      'people': Person.encodeList(
        const [Person(id: 'anna', name: 'Anna')],
      ),
      'countButtonOption': CountButtonOption.rubberDuck.name,
      'themePreference': AppThemePreference.light.name,
    });

    expect(store.people, hasLength(1));
    expect(store.people.single.name, 'Anna');
    expect(store.settings.countButtonOption, CountButtonOption.rubberDuck);
    expect(store.settings.themePreference, AppThemePreference.light);
  });

  test('falls back to empty people when local people data is corrupted',
      () async {
    final store = await loadStore({
      'people': 'not-json',
    });

    expect(store.people, isEmpty);
    expect(store.loaded, isTrue);
  });

  test('falls back to default settings when local enum names are unknown',
      () async {
    final store = await loadStore({
      'countButtonOption': 'missing-button',
      'themePreference': 'missing-theme',
    });

    expect(store.settings.countButtonOption, CountButtonOption.hotelBell);
    expect(store.settings.themePreference, AppThemePreference.dark);
    expect(store.loaded, isTrue);
  });
}
