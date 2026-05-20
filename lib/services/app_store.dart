import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../debug_log.dart';
import '../models/app_settings.dart';
import '../models/person.dart';

class AppStore extends ChangeNotifier {
  AppStore({SharedPreferences? preferences}) : _preferences = preferences;

  static const _peopleKey = 'people';
  static const _countButtonOptionKey = 'countButtonOption';
  static const _themePreferenceKey = 'themePreference';

  SharedPreferences? _preferences;
  List<Person> _people = [];
  AppSettings _settings = const AppSettings();
  bool _loaded = false;

  List<Person> get people => List.unmodifiable(_people);
  AppSettings get settings => _settings;
  bool get loaded => _loaded;

  Future<void> load() async {
    appDebugLog('AppStore.load started');
    _preferences ??= await SharedPreferences.getInstance();
    final prefs = _preferences!;
    final rawPeople = prefs.getString(_peopleKey);
    _people = _decodePeople(rawPeople);
    _settings = AppSettings(
      countButtonOption: _decodeCountButtonOption(
        prefs.getString(_countButtonOptionKey),
      ),
      themePreference: _decodeThemePreference(
        prefs.getString(_themePreferenceKey),
      ),
    );
    _loaded = true;
    appDebugLog(
      'AppStore.load completed: people=${_people.length}, '
      'theme=${_settings.themePreference.name}, '
      'button=${_settings.countButtonOption.name}',
    );
    notifyListeners();
  }

  List<Person> _decodePeople(String? rawPeople) {
    if (rawPeople == null) {
      return [];
    }

    try {
      return Person.decodeList(rawPeople);
    } catch (error) {
      appDebugLog('AppStore.load people decode failed: $error');
      return [];
    }
  }

  CountButtonOption _decodeCountButtonOption(String? rawValue) {
    if (rawValue == null) {
      return CountButtonOption.hotelBell;
    }

    try {
      return CountButtonOption.values.byName(rawValue);
    } catch (error) {
      appDebugLog('AppStore.load count button decode failed: $error');
      return CountButtonOption.hotelBell;
    }
  }

  AppThemePreference _decodeThemePreference(String? rawValue) {
    if (rawValue == null) {
      return AppThemePreference.dark;
    }

    try {
      return AppThemePreference.values.byName(rawValue);
    } catch (error) {
      appDebugLog('AppStore.load theme decode failed: $error');
      return AppThemePreference.dark;
    }
  }

  Future<void> addPerson(String name) async {
    appDebugLog('AppStore.addPerson requested');
    final trimmed = name.trim();
    if (Person.validateName(trimmed) != null) {
      throw ArgumentError('Name is required');
    }
    _people = [
      ..._people,
      Person(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: trimmed,
      ),
    ];
    await _savePeople();
  }

  Future<void> updatePerson(Person person, String name) async {
    appDebugLog('AppStore.updatePerson requested: ${person.id}');
    final trimmed = name.trim();
    if (Person.validateName(trimmed) != null) {
      throw ArgumentError('Name is required');
    }
    _people = _people
        .map((item) =>
            item.id == person.id ? item.copyWith(name: trimmed) : item)
        .toList();
    await _savePeople();
  }

  Future<void> deletePerson(Person person) async {
    appDebugLog('AppStore.deletePerson requested: ${person.id}');
    _people = _people.where((item) => item.id != person.id).toList();
    await _savePeople();
  }

  Future<void> updateSettings(AppSettings settings) async {
    appDebugLog(
      'AppStore.updateSettings requested: '
      'theme=${settings.themePreference.name}, '
      'button=${settings.countButtonOption.name}',
    );
    _settings = settings;
    final prefs = _preferences!;
    await prefs.setString(
      _countButtonOptionKey,
      settings.countButtonOption.name,
    );
    await prefs.setString(_themePreferenceKey, settings.themePreference.name);
    notifyListeners();
  }

  Future<void> _savePeople() async {
    await _preferences!.setString(_peopleKey, Person.encodeList(_people));
    notifyListeners();
  }
}
