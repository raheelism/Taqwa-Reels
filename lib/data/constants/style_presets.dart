/// A curated style preset that applies font, color, dimming, and other settings.
class StylePreset {
  final String id;
  final String name;
  final String description;
  final String fontId;
  final String textColor;
  final double dimOpacity;
  final double fontSize;
  final bool showArabicShadow;
  final double textPosition;
  final double backgroundBlur;
  final double translationFontScale;

  const StylePreset({
    required this.id,
    required this.name,
    required this.description,
    required this.fontId,
    required this.textColor,
    required this.dimOpacity,
    this.fontSize = 28,
    this.showArabicShadow = true,
    this.textPosition = 0.5,
    this.backgroundBlur = 0.0,
    this.translationFontScale = 0.52,
  });
}

const kStylePresets = <StylePreset>[
  StylePreset(
    id: 'elegant_gold',
    name: 'Elegant Gold',
    description: 'Warm gold text, centered, gentle dim',
    fontId: 'amiri',
    textColor: '#C8A24E',
    dimOpacity: 0.45,
    fontSize: 30,
    showArabicShadow: true,
    textPosition: 0.5,
  ),
  StylePreset(
    id: 'minimal_white',
    name: 'Minimal White',
    description: 'Clean white, bottom-aligned, light dim',
    fontId: 'scheherazade',
    textColor: '#FFFFFF',
    dimOpacity: 0.3,
    fontSize: 26,
    showArabicShadow: false,
    textPosition: 0.85,
  ),
  StylePreset(
    id: 'ocean_blue',
    name: 'Ocean Blue',
    description: 'Cool blue text with soft blur',
    fontId: 'noto_arabic',
    textColor: '#4A9EE0',
    dimOpacity: 0.5,
    fontSize: 28,
    showArabicShadow: true,
    textPosition: 0.5,
    backgroundBlur: 5.0,
  ),
  StylePreset(
    id: 'cinematic_dark',
    name: 'Cinematic Dark',
    description: 'High contrast, heavy dim, large text',
    fontId: 'amiri',
    textColor: '#FFFFFF',
    dimOpacity: 0.7,
    fontSize: 34,
    showArabicShadow: true,
    textPosition: 0.5,
    translationFontScale: 0.45,
  ),
  StylePreset(
    id: 'soft_green',
    name: 'Soft Green',
    description: 'Nature-inspired green, top aligned',
    fontId: 'noto_arabic',
    textColor: '#4CAF50',
    dimOpacity: 0.4,
    fontSize: 26,
    showArabicShadow: true,
    textPosition: 0.15,
  ),
  StylePreset(
    id: 'sunset_warm',
    name: 'Sunset Warm',
    description: 'Orange glow with medium blur',
    fontId: 'scheherazade',
    textColor: '#FFB74D',
    dimOpacity: 0.45,
    fontSize: 28,
    showArabicShadow: true,
    textPosition: 0.5,
    backgroundBlur: 3.0,
  ),
  StylePreset(
    id: 'royal_purple',
    name: 'Royal Purple',
    description: 'Rich silver on deep dim',
    fontId: 'amiri',
    textColor: '#A0AAC4',
    dimOpacity: 0.6,
    fontSize: 30,
    showArabicShadow: true,
    textPosition: 0.5,
  ),
  StylePreset(
    id: 'classic_naskh',
    name: 'Classic Naskh',
    description: 'Traditional Arabic, light gold, centered',
    fontId: 'noto_arabic',
    textColor: '#E8C96E',
    dimOpacity: 0.5,
    fontSize: 32,
    showArabicShadow: true,
    textPosition: 0.5,
    translationFontScale: 0.48,
  ),
];
