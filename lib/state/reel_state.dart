import '../data/models/reel_slide.dart';
import '../data/models/reciter.dart';
import '../data/models/translation_edition.dart';
import '../data/models/background_item.dart';
import '../data/models/export_options.dart';
import '../data/constants/reciters.dart';
import '../data/constants/translations.dart';
import '../data/constants/font_options.dart';

class ReelState {
  // Step 1 — Ayah selection
  final int? surahNumber;
  final String surahName;
  final int? fromAyah;
  final int? toAyah;
  final List<ReelSlide> slides;
  final int currentSlideIndex;
  final Reciter reciter;
  final TranslationEdition translation;

  // Step 2 — Background
  final BackgroundItem? background;

  // Step 3 — Customization
  final FontOption font;
  final String textColor; // Hex e.g. '#FFFFFF'
  final double textPosition; // 0.0=top  0.5=center  1.0=bottom
  final double fontSize;
  final double dimOpacity;
  final bool showTranslation;
  final bool showArabicShadow;
  final bool includeBismillah;
  final bool showAyahNumber;
  final String watermarkText;

  // Export options
  final ExportOptions exportOptions;

  const ReelState({
    this.surahNumber,
    this.surahName = '',
    this.fromAyah,
    this.toAyah,
    this.slides = const [],
    this.currentSlideIndex = 0,
    required this.reciter,
    required this.translation,
    this.background,
    required this.font,
    this.textColor = '#FFFFFF',
    this.textPosition = 0.5,
    this.fontSize = 28,
    this.dimOpacity = 0.4,
    this.showTranslation = true,
    this.showArabicShadow = true,
    this.includeBismillah = false,
    this.showAyahNumber = true,
    this.watermarkText = 'TaqwaReels',
    this.exportOptions = const ExportOptions(),
  });

  factory ReelState.initial() => ReelState(
    reciter: kReciters.first,
    translation: kTranslations.first,
    font: kFontOptions.first,
  );

  ReelState copyWith({
    int? surahNumber,
    String? surahName,
    int? fromAyah,
    int? toAyah,
    List<ReelSlide>? slides,
    int? currentSlideIndex,
    Reciter? reciter,
    TranslationEdition? translation,
    BackgroundItem? background,
    FontOption? font,
    String? textColor,
    double? textPosition,
    double? fontSize,
    double? dimOpacity,
    bool? showTranslation,
    bool? showArabicShadow,
    bool? includeBismillah,
    bool? showAyahNumber,
    String? watermarkText,
    ExportOptions? exportOptions,
  }) => ReelState(
    surahNumber: surahNumber ?? this.surahNumber,
    surahName: surahName ?? this.surahName,
    fromAyah: fromAyah ?? this.fromAyah,
    toAyah: toAyah ?? this.toAyah,
    slides: slides ?? this.slides,
    currentSlideIndex: currentSlideIndex ?? this.currentSlideIndex,
    reciter: reciter ?? this.reciter,
    translation: translation ?? this.translation,
    background: background ?? this.background,
    font: font ?? this.font,
    textColor: textColor ?? this.textColor,
    textPosition: textPosition ?? this.textPosition,
    fontSize: fontSize ?? this.fontSize,
    dimOpacity: dimOpacity ?? this.dimOpacity,
    showTranslation: showTranslation ?? this.showTranslation,
    showArabicShadow: showArabicShadow ?? this.showArabicShadow,
    includeBismillah: includeBismillah ?? this.includeBismillah,
    showAyahNumber: showAyahNumber ?? this.showAyahNumber,
    watermarkText: watermarkText ?? this.watermarkText,
    exportOptions: exportOptions ?? this.exportOptions,
  );
}
