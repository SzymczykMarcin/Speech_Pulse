import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _preferences ??= await SharedPreferences.getInstance();
    final prefs = _preferences!;
    final rawPeople = prefs.getString(_peopleKey);
    _people = rawPeople == null ? [] : Person.decodeList(rawPeople);
    _settings = AppSettings(
      countButtonOption: CountButtonOption.values.byName(
        prefs.getString(_countButtonOptionKey) ??
            CountButtonOption.hotelBell.name,
      ),
      themePreference: AppThemePreference.values.byName(
        prefs.getString(_themePreferenceKey) ?? AppThemePreference.dark.name,
      ),
    );
    _loaded = true;
    notifyListeners();
  }

  Future<void> addPerson(String name) async {
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
    _people = _people.where((item) => item.id != person.id).toList();
    await _savePeople();
  }

  Future<void> updateSettings(AppSettings settings) async {
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
