class AppConfig {
  static const publicContactEmail = String.fromEnvironment(
    'PUBLIC_CONTACT_EMAIL',
    defaultValue: '',
  );

  static bool get hasPublicContactEmail => publicContactEmail.trim().isNotEmpty;
}
