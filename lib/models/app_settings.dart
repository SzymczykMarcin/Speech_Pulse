enum CountButtonOption {
  hotelBell,
  liveDuck,
  rubberDuck;

  String get label {
    return switch (this) {
      CountButtonOption.hotelBell => 'Hotel Bell',
      CountButtonOption.liveDuck => 'Live Duck',
      CountButtonOption.rubberDuck => 'Rubber Duck',
    };
  }

  String get iconAsset {
    return switch (this) {
      CountButtonOption.hotelBell =>
        'assets/button_icons/hotel_bell_button.png',
      CountButtonOption.liveDuck => 'assets/button_icons/live_duck_button.png',
      CountButtonOption.rubberDuck =>
        'assets/button_icons/rubber_duck_button.png',
    };
  }

  String get soundAsset {
    return switch (this) {
      CountButtonOption.hotelBell => 'sounds/hotel_bell.wav',
      CountButtonOption.liveDuck => 'sounds/live_duck.wav',
      CountButtonOption.rubberDuck => 'sounds/rubber_duck.wav',
    };
  }
}

enum AppThemePreference { dark, light, system }

class AppSettings {
  const AppSettings({
    this.countButtonOption = CountButtonOption.hotelBell,
    this.themePreference = AppThemePreference.dark,
  });

  final CountButtonOption countButtonOption;
  final AppThemePreference themePreference;

  AppSettings copyWith({
    CountButtonOption? countButtonOption,
    AppThemePreference? themePreference,
  }) {
    return AppSettings(
      countButtonOption: countButtonOption ?? this.countButtonOption,
      themePreference: themePreference ?? this.themePreference,
    );
  }
}
