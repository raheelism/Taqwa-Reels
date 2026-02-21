/// A font option for text overlays.
/// [googleFontFamily] is used for the Flutter UI preview.
/// [ffmpegFontFile] is the local TTF filename used by FFmpeg `drawtext`.
class FontOption {
  final String id;
  final String displayName;
  final String googleFontFamily;
  final String ffmpegFontFile;

  const FontOption({
    required this.id,
    required this.displayName,
    required this.googleFontFamily,
    required this.ffmpegFontFile,
  });
}

const kFontOptions = <FontOption>[
  FontOption(
    id: 'amiri',
    displayName: 'Amiri (Arabic)',
    googleFontFamily: 'Amiri',
    ffmpegFontFile: 'Amiri-Regular.ttf',
  ),
  FontOption(
    id: 'scheherazade',
    displayName: 'Scheherazade',
    googleFontFamily: 'Scheherazade New',
    ffmpegFontFile: 'ScheherazadeNew-Regular.ttf',
  ),
  FontOption(
    id: 'noto_arabic',
    displayName: 'Noto Naskh Arabic',
    googleFontFamily: 'Noto Naskh Arabic',
    ffmpegFontFile: 'NotoNaskhArabic-Regular.ttf',
  ),
  FontOption(
    id: 'cinzel',
    displayName: 'Cinzel (Latin)',
    googleFontFamily: 'Cinzel',
    ffmpegFontFile: 'Cinzel-Regular.ttf',
  ),
  FontOption(
    id: 'cormorant',
    displayName: 'Cormorant',
    googleFontFamily: 'Cormorant Garamond',
    ffmpegFontFile: 'CormorantGaramond-Regular.ttf',
  ),
];
