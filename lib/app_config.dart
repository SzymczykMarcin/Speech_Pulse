class AppConfig {
  static const publicContactEmail = String.fromEnvironment(
    'PUBLIC_CONTACT_EMAIL',
    defaultValue: 'marcin.szymczyk@solutionsms.pl',
  );

  static bool get hasPublicContactEmail => publicContactEmail.trim().isNotEmpty;
}
