/// A translation edition available from the AlQuran Cloud API.
class TranslationEdition {
  final String id;
  final String displayName;
  final String language;
  final String edition;     // API edition identifier, e.g. 'en.sahih'

  const TranslationEdition({
    required this.id,
    required this.displayName,
    required this.language,
    required this.edition,
  });
}
