/// A font option for text overlays.
/// [googleFontFamily] is the Google Fonts family name — used for both
/// the Flutter UI preview (via the `google_fonts` package) and for
/// FFmpeg export (the TTF is downloaded from Google Fonts cache).
class FontOption {
  final String id;
  final String displayName;
  final String googleFontFamily; // Google Fonts family name

  const FontOption({
    required this.id,
    required this.displayName,
    required this.googleFontFamily,
  });
}

const kFontOptions = <FontOption>[
  FontOption(
    id: 'amiri',
    displayName: 'Amiri (Arabic)',
    googleFontFamily: 'Amiri',
  ),
  FontOption(
    id: 'scheherazade',
    displayName: 'Scheherazade',
    googleFontFamily: 'Scheherazade New',
  ),
  FontOption(
    id: 'noto_arabic',
    displayName: 'Noto Naskh Arabic',
    googleFontFamily: 'Noto Naskh Arabic',
  ),
  FontOption(
    id: 'cinzel',
    displayName: 'Cinzel (Latin)',
    googleFontFamily: 'Cinzel',
  ),
  FontOption(
    id: 'cormorant',
    displayName: 'Cormorant',
    googleFontFamily: 'Cormorant Garamond',
  ),
];
