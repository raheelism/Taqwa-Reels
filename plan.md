# 🕌 TaqwaReels — Flutter Implementation Plan (Proper Video Export)

> Full-stack Flutter guide for a **real video export engine** — FFmpeg renders directly without screen capture, supports looping video backgrounds, Ken Burns image animation, precise audio-video sync, and Google Fonts overlays.

---

## Table of Contents
1. [Architecture Overview](#1-architecture-overview)
2. [Flutter Package Stack](#2-flutter-package-stack)
3. [Project Setup](#3-project-setup)
4. [Folder Structure](#4-folder-structure)
5. [Design System](#5-design-system)
6. [Google Fonts Setup](#6-google-fonts-setup)
7. [Data Models](#7-data-models)
8. [State Management — Riverpod](#8-state-management--riverpod)
9. [Services Layer](#9-services-layer)
10. [Screen 1 — Ayah Selection](#10-screen-1--ayah-selection)
11. [Screen 2 — Background Picker](#11-screen-2--background-picker)
12. [Screen 3 — Customize Style](#12-screen-3--customize-style)
13. [Screen 4 — Preview & Export](#13-screen-4--preview--export)
14. [Video Export Pipeline (Core Engine)](#14-video-export-pipeline-core-engine)
15. [FFmpeg Command Reference](#15-ffmpeg-command-reference)
16. [pubspec.yaml](#16-pubspecyaml)
17. [Android Manifest & Gradle](#17-android-manifest--gradle)
18. [Navigation](#18-navigation)
19. [Testing Checklist](#19-testing-checklist)
20. [Migration Checklist](#20-migration-checklist)

---

## 1. Architecture Overview

### Core Rendering Strategy — Pure FFmpeg (No Screen Capture)

The **key upgrade** over the React Native version: instead of capturing Flutter widget screenshots, the entire video is **rendered server-side by FFmpeg** directly from:
- Downloaded background video/image files
- Downloaded MP3 audio files
- Text baked into the video via FFmpeg `drawtext` filter

This gives:
- ✅ Pixel-perfect 720×1280 output regardless of device screen size
- ✅ Proper audio-video frame sync (frame duration = exact audio duration)
- ✅ Video backgrounds loop/trim to match audio length
- ✅ Image backgrounds can animate (Ken Burns zoom/pan)
- ✅ No UI jitter, no render timing issues

### 4-Step User Flow

```
Step 1: AyahSelectionScreen
  └─ Pick Surah → Ayah range → Reciter → Translation → Preview audio

Step 2: BackgroundScreen
  └─ Browse Pixabay images & videos → Select one

Step 3: CustomizeScreen
  └─ Font family, font size, text color, position, dim opacity, translation toggle
  └─ Live preview card (Flutter widget only, not used for export)

Step 4: PreviewExportScreen
  └─ Slide-by-slide preview widget
  └─ Tap Export → FFmpeg pipeline runs → Save to gallery
```

---

## 2. Flutter Package Stack

| Concern | Package | Version |
|---------|---------|---------|
| State | `flutter_riverpod` | ^2.5.1 |
| Navigation | `go_router` | ^14.0.0 |
| HTTP | `dio` | ^5.4.3 |
| Audio preview | `just_audio` | ^0.9.40 |
| Video preview | `video_player` | ^2.8.6 |
| Image loading | `cached_network_image` | ^3.3.1 |
| **Video export** | `ffmpeg_kit_flutter` | ^6.0.3 |
| File I/O | `path_provider` | ^2.1.3 |
| Gallery save | `gal` | ^2.3.0 |
| Sharing | `share_plus` | ^9.0.0 |
| Permissions | `permission_handler` | ^11.3.1 |
| Connectivity | `connectivity_plus` | ^6.0.3 |
| **Fonts** | `google_fonts` | ^6.2.1 |
| Immutable state | `freezed_annotation` | ^2.4.1 |
| Progress UI | `percent_indicator` | ^4.2.3 |

---

## 3. Project Setup

```bash
flutter create taqwa_reels --org com.taqwareels --platforms android,ios
cd taqwa_reels
flutter pub get
```

### `android/app/build.gradle`
```gradle
android {
    defaultConfig {
        applicationId "com.taqwareels.app"
        minSdkVersion 24       // Required by ffmpeg_kit_flutter
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    buildTypes {
        release {
            minifyEnabled false   // Keep false — FFmpeg needs native libs
            shrinkResources false
        }
    }
}
```

---

## 4. Folder Structure

```
lib/
├── main.dart
├── app.dart                        # MaterialApp + GoRouter
│
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_spacing.dart
│   │   └── app_theme.dart
│   └── utils/
│       ├── retry_dio.dart          # Dio retry interceptor
│       └── duration_parser.dart   # Parse FFmpeg duration output
│
├── data/
│   ├── models/
│   │   ├── surah.dart
│   │   ├── ayah.dart
│   │   ├── reel_slide.dart
│   │   ├── reciter.dart
│   │   ├── translation_edition.dart
│   │   └── background_item.dart
│   ├── constants/
│   │   ├── reciters.dart
│   │   ├── translations.dart
│   │   ├── font_options.dart      # Google Fonts list for Arabic + Latin
│   │   └── backgrounds.dart       # Category list, text color presets
│   └── services/
│       ├── quran_api_service.dart
│       ├── pixabay_service.dart
│       ├── audio_service.dart
│       └── video_export_service.dart   # Core FFmpeg engine
│
├── state/
│   ├── reel_state.dart
│   └── reel_provider.dart
│
└── screens/
    ├── ayah_selection/
    │   ├── ayah_selection_screen.dart
    │   └── widgets/
    │       ├── surah_list_item.dart
    │       ├── ayah_range_picker.dart
    │       ├── reciter_chip.dart
    │       └── translation_tile.dart
    ├── background/
    │   ├── background_screen.dart
    │   └── widgets/
    │       ├── category_tab.dart
    │       ├── media_grid.dart
    │       └── media_grid_item.dart
    ├── customize/
    │   ├── customize_screen.dart
    │   └── widgets/
    │       ├── reel_preview_card.dart
    │       ├── font_picker_sheet.dart
    │       ├── color_swatch_row.dart
    │       └── position_picker.dart
    └── preview_export/
        ├── preview_export_screen.dart
        └── widgets/
            ├── slide_preview_widget.dart
            ├── export_progress_overlay.dart
            └── export_result_card.dart
```

---

## 5. Design System

### `lib/core/theme/app_colors.dart`
```dart
import 'package:flutter/material.dart';

class AppColors {
  static const bg           = Color(0xFF0A0E1A);
  static const bgCard       = Color(0xFF131832);
  static const bgCardLight  = Color(0xFF1A2040);
  static const primary      = Color(0xFFC8A24E); // Gold
  static const primaryLight = Color(0xFFE8C96E);
  static const primaryDim   = Color(0x33C8A24E);
  static const secondary    = Color(0xFF4A9EE0);
  static const textPrimary  = Color(0xFFFFFFFF);
  static const textSecondary= Color(0xFFA0AAC4);
  static const textMuted    = Color(0xFF6B7494);
  static const success      = Color(0xFF4CAF50);
  static const error        = Color(0xFFEF5350);
  static const warning      = Color(0xFFFFB74D);
}
```

### `lib/core/theme/app_theme.dart`
```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

ThemeData buildAppTheme() => ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.bg,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    surface: AppColors.bgCard,
  ),
  textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.bg,
    elevation: 0,
    titleTextStyle: GoogleFonts.outfit(
      color: AppColors.primary,
      fontSize: 22,
      fontWeight: FontWeight.w800,
    ),
  ),
);
```

---

## 6. Google Fonts Setup

### Available Font Options for Text Overlay

```dart
// lib/data/constants/font_options.dart

class FontOption {
  final String id;
  final String displayName;
  final String googleFontFamily; // for UI preview
  final String ffmpegFontFile;   // local .ttf path for FFmpeg drawtext
  const FontOption({
    required this.id,
    required this.displayName,
    required this.googleFontFamily,
    required this.ffmpegFontFile,
  });
}

const kFontOptions = [
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
```

### Font Asset Setup (Required for FFmpeg `drawtext`)

FFmpeg's `drawtext` filter needs the font as a **local file path**. Download TTF files and bundle them:

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/fonts/Amiri-Regular.ttf
    - assets/fonts/Amiri-Bold.ttf
    - assets/fonts/ScheherazadeNew-Regular.ttf
    - assets/fonts/NotoNaskhArabic-Regular.ttf
    - assets/fonts/Cinzel-Regular.ttf
    - assets/fonts/CormorantGaramond-Regular.ttf
  fonts:
    - family: Amiri
      fonts:
        - asset: assets/fonts/Amiri-Regular.ttf
        - asset: assets/fonts/Amiri-Bold.ttf
          weight: 700
    - family: Scheherazade New
      fonts:
        - asset: assets/fonts/ScheherazadeNew-Regular.ttf
```

### Copying Fonts to Temp Dir for FFmpeg

FFmpeg cannot read assets directly — fonts must be copied to the device's filesystem first:

```dart
// lib/core/utils/font_utils.dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getFontPath(String fontFileName) async {
  final dir = await getApplicationSupportDirectory();
  final fontFile = File('${dir.path}/fonts/$fontFileName');
  if (!await fontFile.exists()) {
    await fontFile.parent.create(recursive: true);
    final bytes = await rootBundle.load('assets/fonts/$fontFileName');
    await fontFile.writeAsBytes(bytes.buffer.asUint8List());
  }
  return fontFile.path;
}
```

---

## 7. Data Models

### `reel_slide.dart`
```dart
class ReelSlide {
  final String arabicText;
  final String translationText;
  final int ayahNumber;
  final String slideLabel;
  final bool isPartial;
  const ReelSlide({
    required this.arabicText,
    required this.translationText,
    required this.ayahNumber,
    required this.slideLabel,
    required this.isPartial,
  });
}
```

### `background_item.dart`
```dart
enum BackgroundType { image, video }

class BackgroundItem {
  final int id;
  final BackgroundType type;
  final String previewUrl;
  final String fullUrl;      // High-res image or medium video
  String? localPath;         // Set after download

  BackgroundItem({
    required this.id,
    required this.type,
    required this.previewUrl,
    required this.fullUrl,
    this.localPath,
  });
}
```

### `export_options.dart`
```dart
enum ExportQuality { hd720, fhd1080 }

class ExportOptions {
  final ExportQuality quality;
  final bool kenBurnsEffect;  // Image: slow zoom
  final bool audioFadeOut;    // Fade out last 1s of audio
  final double textShadowOpacity;

  const ExportOptions({
    this.quality = ExportQuality.hd720,
    this.kenBurnsEffect = true,
    this.audioFadeOut = true,
    this.textShadowOpacity = 0.6,
  });

  // Resolution
  String get resolution => quality == ExportQuality.fhd1080 ? '1080x1920' : '720x1280';
  int get width  => quality == ExportQuality.fhd1080 ? 1080 : 720;
  int get height => quality == ExportQuality.fhd1080 ? 1920 : 1280;
}
```

---

## 8. State Management — Riverpod

### `lib/state/reel_state.dart`
```dart
import '../data/models/reel_slide.dart';
import '../data/models/reciter.dart';
import '../data/models/translation_edition.dart';
import '../data/models/background_item.dart';
import '../data/models/export_options.dart';
import '../data/constants/reciters.dart';
import '../data/constants/translations.dart';
import '../data/constants/font_options.dart';

class ReelState {
  // Step 1
  final int? surahNumber;
  final String surahName;
  final int? fromAyah;
  final int? toAyah;
  final List<ReelSlide> slides;
  final int currentSlideIndex;
  final Reciter reciter;
  final TranslationEdition translation;
  // Step 2
  final BackgroundItem? background;
  // Step 3
  final FontOption font;
  final String textColor;      // Hex e.g. '#FFFFFF'
  final double textPosition;   // 0.0=top 0.5=center 1.0=bottom
  final double fontSize;
  final double dimOpacity;
  final bool showTranslation;
  final bool showArabicShadow;
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
    exportOptions: exportOptions ?? this.exportOptions,
  );
}
```

### `lib/state/reel_provider.dart`
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reel_state.dart';
import '../data/models/reel_slide.dart';
import '../data/services/quran_api_service.dart';

// ── Slide splitting logic (max 12 Arabic words per slide) ──
const _kMaxWords = 12;

List<ReelSlide> buildSlides(List<AyahWithTranslation> ayahs, String surahName) =>
  ayahs.expand((a) => _split(a, surahName)).toList();

List<ReelSlide> _split(AyahWithTranslation ayah, String surahName) {
  final arWords = ayah.arabic.trim().split(RegExp(r'\s+'));
  final trWords = ayah.translation.trim().split(RegExp(r'\s+'));
  if (arWords.length <= _kMaxWords) {
    return [ReelSlide(
      arabicText: ayah.arabic,
      translationText: ayah.translation,
      ayahNumber: ayah.ayahNumber,
      slideLabel: '$surahName ${ayah.surahNumber}:${ayah.ayahNumber}',
      isPartial: false,
    )];
  }
  final parts = (arWords.length / _kMaxWords).ceil();
  return List.generate(parts, (p) {
    final s = p * _kMaxWords;
    final e = (s + _kMaxWords).clamp(0, arWords.length);
    final ts = ((s / arWords.length) * trWords.length).round().clamp(0, trWords.length);
    final te = ((e / arWords.length) * trWords.length).round().clamp(0, trWords.length);
    return ReelSlide(
      arabicText: arWords.sublist(s, e).join(' '),
      translationText: trWords.sublist(ts, te).join(' '),
      ayahNumber: ayah.ayahNumber,
      slideLabel: '$surahName ${ayah.surahNumber}:${ayah.ayahNumber} (${p+1}/$parts)',
      isPartial: true,
    );
  });
}

class ReelNotifier extends StateNotifier<ReelState> {
  ReelNotifier() : super(ReelState.initial());

  void setSurah(int n, String name) => state = state.copyWith(
    surahNumber: n, surahName: name,
    slides: [], fromAyah: null, toAyah: null, currentSlideIndex: 0,
  );
  void setAyahRange(int from, int to, List<ReelSlide> slides) =>
    state = state.copyWith(fromAyah: from, toAyah: to, slides: slides, currentSlideIndex: 0);
  void setCurrentSlide(int i) =>
    state = state.copyWith(currentSlideIndex: i.clamp(0, state.slides.length - 1));
  void nextSlide() => setCurrentSlide(state.currentSlideIndex + 1);
  void prevSlide() => setCurrentSlide(state.currentSlideIndex - 1);
  void setReciter(r)        => state = state.copyWith(reciter: r);
  void setTranslation(t)    => state = state.copyWith(translation: t);
  void setBackground(bg)    => state = state.copyWith(background: bg);
  void setFont(f)           => state = state.copyWith(font: f);
  void setTextColor(c)      => state = state.copyWith(textColor: c);
  void setTextPosition(p)   => state = state.copyWith(textPosition: p);
  void setFontSize(s)       => state = state.copyWith(fontSize: s);
  void setDimOpacity(o)     => state = state.copyWith(dimOpacity: o);
  void setShowTranslation(v)=> state = state.copyWith(showTranslation: v);
  void setShowShadow(v)     => state = state.copyWith(showArabicShadow: v);
  void setExportOptions(o)  => state = state.copyWith(exportOptions: o);
  void reset()              => state = ReelState.initial();
}

final reelProvider = StateNotifierProvider<ReelNotifier, ReelState>(
  (_) => ReelNotifier(),
);
final currentSlideProvider = Provider<ReelSlide?>(
  (ref) {
    final s = ref.watch(reelProvider);
    return s.slides.isEmpty ? null : s.slides[s.currentSlideIndex];
  },
);
```

---

## 9. Services Layer

### 9.1 Quran API Service

```dart
// lib/data/services/quran_api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/surah.dart';
import '../models/ayah.dart';

class QuranApiService {
  static const _base = 'https://api.alquran.cloud/v1';
  final _dio = Dio(BaseOptions(baseUrl: _base,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));
  List<Surah>? _cache;

  Future<List<Surah>> fetchSurahs() async {
    if (_cache != null) return _cache!;
    final r = await _dio.get('/surah');
    _cache = (r.data['data'] as List)
        .map((e) => Surah.fromJson(e)).toList();
    return _cache!;
  }

  Future<AyahWithTranslation> fetchAyah(int surah, int ayah, String edition) async {
    final ref = '$surah:$ayah';
    final results = await Future.wait([
      _dio.get('/ayah/$ref'),
      _dio.get('/ayah/$ref/$edition'),
    ]);
    final ar = results[0].data['data'];
    final tr = results[1].data['data'];
    return AyahWithTranslation(
      arabic: ar['text'],
      translation: tr['text'],
      surahNumber: ar['surah']['number'],
      ayahNumber: ar['numberInSurah'],
      surahName: ar['surah']['name'],
      surahEnglishName: ar['surah']['englishName'],
    );
  }

  Future<List<AyahWithTranslation>> fetchRange(
    int surah, int from, int to, String edition,
  ) => Future.wait([for (int i = from; i <= to; i++) fetchAyah(surah, i, edition)]);
}

final quranApiProvider = Provider((_) => QuranApiService());
```

### 9.2 Pixabay Service

```dart
// lib/data/services/pixabay_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/background_item.dart';

const _kKey = 'YOUR_PIXABAY_API_KEY';

class PixabayService {
  final _dio = Dio(BaseOptions(baseUrl: 'https://pixabay.com/api',
    connectTimeout: const Duration(seconds: 12),
  ));
  final _imgCache = <String, List<BackgroundItem>>{};
  final _vidCache = <String, List<BackgroundItem>>{};

  Future<List<BackgroundItem>> searchImages(String q, {int page=1}) async {
    final key = '${q}_$page';
    if (_imgCache[key] != null) return _imgCache[key]!;
    final r = await _dio.get('/', queryParameters: {
      'key': _kKey, 'q': q, 'image_type': 'photo',
      'orientation': 'vertical', 'per_page': 15, 'page': page,
      'safesearch': 'true', 'min_width': 720,
    });
    final items = (r.data['hits'] as List).map((h) => BackgroundItem(
      id: h['id'], type: BackgroundType.image,
      previewUrl: h['previewURL'], fullUrl: h['largeImageURL'],
    )).toList();
    _imgCache[key] = items;
    return items;
  }

  Future<List<BackgroundItem>> searchVideos(String q, {int page=1}) async {
    final key = '${q}_$page';
    if (_vidCache[key] != null) return _vidCache[key]!;
    final r = await _dio.get('/videos/', queryParameters: {
      'key': _kKey, 'q': q, 'per_page': 10, 'page': page, 'safesearch': 'true',
    });
    final items = (r.data['hits'] as List).map((h) {
      final v = h['videos'];
      return BackgroundItem(
        id: h['id'], type: BackgroundType.video,
        previewUrl: v['tiny']['url'],
        fullUrl: v['medium']['url'],
      );
    }).toList();
    _vidCache[key] = items;
    return items;
  }
}

final pixabayProvider = Provider((_) => PixabayService());
```

### 9.3 Audio Service

```dart
// lib/data/services/audio_service.dart

/// EveryAyah CDN — same as the RN version
String getAudioUrl(String folder, int surah, int ayah) {
  final s = surah.toString().padLeft(3, '0');
  final a = ayah.toString().padLeft(3, '0');
  return 'https://everyayah.com/data/$folder/$s$a.mp3';
}
```

---

## 10. Screen 1 — Ayah Selection

Key widgets and behaviour — identical logic to the current `index.tsx`:

| Widget | Details |
|--------|---------|
| `SurahListItem` | Number badge, English name, Arabic name, ayah count |
| `AyahRangePicker` | Two `TextField` + Load button; validates against `surah.numberOfAyahs` |
| `SlideSummaryCard` | Green card: "✅ N slides generated (long ayahs auto-split)" |
| `AyahPreviewCard` | RTL Arabic text + translation + slide label |
| `ReciterChipRow` | `SingleChildScrollView` horizontal with 5 `ChoiceChip` |
| `AudioPreviewButton` | `just_audio` player — tap to play/pause recitation |
| `TranslationTileList` | Radio-style list tiles, auto-reloads on change |
| `StepIndicator` | 4 dots + 3 connecting lines |

### Audio Preview
```dart
final player = AudioPlayer();

Future<void> togglePreview(String url) async {
  if (player.playing) { await player.stop(); return; }
  await player.setUrl(url);
  await player.play();
}
// Dispose in State.dispose()
```

---

## 11. Screen 2 — Background Picker

| Feature | Detail |
|---------|--------|
| Tab bar | Images / Videos (`TabBar` with 2 tabs) |
| Category chips | mosque, nature, sky, ocean, desert, stars |
| Grid | `GridView.builder` 2-col, `CachedNetworkImage` |
| Video items | `VideoPlayerController` init on first visible, loop |
| Selection | Gold border highlight on selected item |
| Load more | Infinite scroll, increment `page` counter |

### Video Background Grid Item
```dart
class VideoGridItem extends StatefulWidget {
  @override
  State<VideoGridItem> createState() => _VideoGridItemState();
}
class _VideoGridItemState extends State<VideoGridItem> {
  late VideoPlayerController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = VideoPlayerController.networkUrl(Uri.parse(widget.item.previewUrl))
      ..initialize().then((_) {
        _ctrl.setLooping(true);
        _ctrl.setVolume(0);
        _ctrl.play();
        setState(() {});
      });
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => _ctrl.value.isInitialized
    ? VideoPlayer(_ctrl) : const Center(child: CircularProgressIndicator());
}
```

---

## 12. Screen 3 — Customize Style

| Control | Widget | State Key |
|---------|--------|-----------|
| Font family | Bottom sheet `FontPickerSheet` | `font` |
| Font size | `Slider` 16–52 | `fontSize` |
| Dim opacity | `Slider` 0.0–0.9 | `dimOpacity` |
| Text position | 3 `SegmentedButton` (Top/Center/Bottom) | `textPosition` |
| Text color | Row of `GestureDetector` color circles | `textColor` |
| Show translation | `SwitchListTile` | `showTranslation` |
| Text shadow | `SwitchListTile` | `showArabicShadow` |
| Export quality | `DropdownButton` — 720p / 1080p | `exportOptions.quality` |
| Ken Burns | `SwitchListTile` (images only) | `exportOptions.kenBurnsEffect` |
| Audio fade out | `SwitchListTile` | `exportOptions.audioFadeOut` |
| Live preview | `ReelPreviewCard` — Flutter widget only | all state |

### `ReelPreviewCard` (Flutter widget preview only — NOT used for export)
```dart
class ReelPreviewCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reelProvider);
    final slide  = ref.watch(currentSlideProvider);
    if (slide == null) return const SizedBox.shrink();

    final textColor = Color(int.parse(
      state.textColor.replaceFirst('#', '0xFF'),
    ));
    final yFrac = state.textPosition; // 0.0 top → 1.0 bottom

    return AspectRatio(
      aspectRatio: 9 / 16,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(children: [
          // Background
          if (state.background?.type == BackgroundType.video)
            _LoopingVideoBackground(url: state.background!.fullUrl)
          else if (state.background?.type == BackgroundType.image)
            CachedNetworkImage(
              imageUrl: state.background!.fullUrl, fit: BoxFit.cover,
              width: double.infinity, height: double.infinity,
            ),
          // Dim overlay
          Container(color: Colors.black.withOpacity(state.dimOpacity)),
          // Text positioned
          Align(
            alignment: Alignment(0, (yFrac * 2) - 1),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(slide.arabicText,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: state.font.googleFontFamily,
                    fontSize: state.fontSize,
                    color: textColor,
                    height: 1.8,
                    shadows: state.showArabicShadow ? [
                      Shadow(blurRadius: 8, color: Colors.black87),
                    ] : null,
                  ),
                ),
                if (state.showTranslation) ...[
                  const SizedBox(height: 12),
                  Text(slide.translationText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: state.fontSize * 0.52,
                      color: textColor.withOpacity(0.85),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Text(slide.slideLabel,
                  style: TextStyle(
                    fontSize: 12, color: textColor.withOpacity(0.6),
                    letterSpacing: 1.2,
                  ),
                ),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
```

---

## 13. Screen 4 — Preview & Export

```
PreviewExportScreen
  ├── SlideNavigator (prev/next, slide counter)
  ├── ReelPreviewCard (same widget as Step 3)
  ├── ExportOptionsCard (collapsible summary)
  ├── ExportButton
  └── ExportProgressOverlay (shown during export)
       ├── Phase label + detail text
       ├── LinearProgressIndicator
       └── Cancel button (calls FFmpegKit.cancel())
```

### Export Trigger
```dart
Future<void> _startExport() async {
  setState(() => _exporting = true);
  try {
    final path = await VideoExportService().exportVideo(
      state: ref.read(reelProvider),
      onProgress: (p) => setState(() => _progress = p),
    );
    await Gal.putVideo(path, album: 'TaqwaReels');
    _showSuccessSheet(path);
  } catch (e) {
    _showError(e.toString());
  } finally {
    setState(() => _exporting = false);
  }
}
```

---

## 14. Video Export Pipeline (Core Engine)

> **Key principle:** FFmpeg builds the video directly from downloaded files. No Flutter widget capture needed.

### Pipeline Phases

```
Phase 1 — Download background (image or video)
Phase 2 — Download audio MP3 files for each unique ayah
Phase 3 — Probe audio: get exact duration per ayah via FFmpegKit
Phase 4 — Calculate per-slide frame durations
Phase 5 — Copy font TTF to filesystem (for drawtext)
Phase 6 — Build FFmpeg command (image vs video path differs)
Phase 7 — Execute FFmpeg → output MP4
Phase 8 — Save to gallery with gal
Phase 9 — Cleanup temp files
```

### Progress Reporting
```dart
enum ExportPhase {
  downloadingBackground,
  downloadingAudio,
  probingDurations,
  renderingVideo,
  savingToGallery,
  done,
  error,
}

class ExportProgress {
  final ExportPhase phase;
  final String label;
  final double progress; // 0.0–1.0
  final String? detail;
}
```

### Full `VideoExportService`

```dart
// lib/data/services/video_export_service.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/font_utils.dart';
import '../models/background_item.dart';
import '../../state/reel_state.dart';
import 'audio_service.dart';

typedef OnProgress = void Function(ExportProgress);

class VideoExportService {
  final _dio = Dio();

  Future<String> exportVideo({
    required ReelState state,
    required OnProgress onProgress,
  }) async {
    final tmp = await _ensureExportDir();

    // ── Phase 1: Download background ──
    onProgress(ExportProgress(
      phase: ExportPhase.downloadingBackground,
      label: 'Downloading background',
      progress: 0.0,
    ));
    final bgPath = await _downloadFile(
      state.background!.fullUrl,
      '$tmp/background.${state.background!.type == BackgroundType.video ? "mp4" : "jpg"}',
    );

    // ── Phase 2: Download audio ──
    final uniqueAyahs = state.slides.map((s) => s.ayahNumber).toSet().toList();
    final audioMap = <int, String>{};
    for (int i = 0; i < uniqueAyahs.length; i++) {
      final n = uniqueAyahs[i];
      onProgress(ExportProgress(
        phase: ExportPhase.downloadingAudio,
        label: 'Downloading audio',
        progress: 0.05 + (i / uniqueAyahs.length) * 0.2,
        detail: 'Ayah $n (${i+1}/${uniqueAyahs.length})',
      ));
      final url  = getAudioUrl(state.reciter.folder, state.surahNumber!, n);
      final path = '$tmp/audio_${n.toString().padLeft(3,"0")}.mp3';
      await _downloadFile(url, path);
      audioMap[n] = path;
    }

    // ── Phase 3: Probe audio durations ──
    onProgress(ExportProgress(
      phase: ExportPhase.probingDurations,
      label: 'Analysing audio',
      progress: 0.25,
    ));
    final durations = <int, double>{};
    for (final n in uniqueAyahs) {
      durations[n] = await _probeDuration(audioMap[n]!);
    }

    // ── Phase 4: Per-slide durations ──
    final slideCountPerAyah = <int, int>{};
    for (final s in state.slides) {
      slideCountPerAyah[s.ayahNumber] = (slideCountPerAyah[s.ayahNumber] ?? 0) + 1;
    }
    final slideDurations = state.slides.map((s) =>
      (durations[s.ayahNumber] ?? 5.0) / (slideCountPerAyah[s.ayahNumber] ?? 1)
    ).toList();

    final totalDuration = slideDurations.fold(0.0, (a, b) => a + b);

    // ── Phase 5: Merge audio ──
    final orderedAyahs = <int>[];
    for (final s in state.slides) {
      if (!orderedAyahs.contains(s.ayahNumber)) orderedAyahs.add(s.ayahNumber);
    }
    final audioConcatContent = orderedAyahs.map((n) => "file '${audioMap[n]}'").join('\n');
    final audioConcatPath = '$tmp/audio_list.txt';
    await File(audioConcatPath).writeAsString(audioConcatContent);

    final mergedAudioPath = '$tmp/merged.mp3';
    final audioSession = await FFmpegKit.execute(
      '-y -f concat -safe 0 -i "$audioConcatPath" -c copy "$mergedAudioPath"',
    );
    if (!ReturnCode.isSuccess(await audioSession.getReturnCode())) {
      throw Exception('Audio merge failed: ${await audioSession.getOutput()}');
    }

    // ── Phase 6: Get font path ──
    final fontPath = await getFontPath(state.font.ffmpegFontFile);

    // ── Phase 7: Render video ──
    onProgress(ExportProgress(
      phase: ExportPhase.renderingVideo,
      label: 'Rendering video',
      progress: 0.35,
    ));
    final opts = state.exportOptions;
    final outputPath = '$tmp/TaqwaReels_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final cmd = state.background!.type == BackgroundType.video
      ? _buildVideoBackgroundCommand(
          bgPath: bgPath,
          audioPath: mergedAudioPath,
          slides: state.slides,
          slideDurations: slideDurations,
          totalDuration: totalDuration,
          state: state,
          fontPath: fontPath,
          outputPath: outputPath,
          opts: opts,
        )
      : _buildImageBackgroundCommand(
          bgPath: bgPath,
          audioPath: mergedAudioPath,
          slides: state.slides,
          slideDurations: slideDurations,
          totalDuration: totalDuration,
          state: state,
          fontPath: fontPath,
          outputPath: outputPath,
          opts: opts,
        );

    // Track FFmpeg progress
    FFmpegKitConfig.enableStatisticsCallback((stats) {
      final t = stats.getTime() / 1000;
      onProgress(ExportProgress(
        phase: ExportPhase.renderingVideo,
        label: 'Rendering video',
        progress: 0.35 + (t / totalDuration).clamp(0, 1) * 0.55,
        detail: '${((t / totalDuration) * 100).clamp(0, 100).round()}% encoded',
      ));
    });

    final session = await FFmpegKit.execute(cmd);
    final rc = await session.getReturnCode();
    if (!ReturnCode.isSuccess(rc)) {
      final log = await session.getOutput();
      throw Exception('FFmpeg failed:\n$log');
    }

    onProgress(ExportProgress(phase: ExportPhase.done, label: 'Complete!', progress: 1.0));
    return outputPath;
  }

  // ── Helper: Download file ──
  Future<String> _downloadFile(String url, String savePath) async {
    await _dio.download(url, savePath);
    return savePath;
  }

  // ── Helper: Probe duration via FFmpeg ──
  Future<double> _probeDuration(String path) async {
    final session = await FFmpegKit.execute('-i "$path" -f null -');
    final out = await session.getOutput() ?? '';
    final m = RegExp(r'Duration:\s*(\d+):(\d+):(\d+)\.(\d+)').firstMatch(out);
    if (m != null) {
      return int.parse(m.group(1)!) * 3600 +
             int.parse(m.group(2)!) * 60 +
             int.parse(m.group(3)!) +
             int.parse(m.group(4)!) / 100;
    }
    return 5.0;
  }

  Future<String> _ensureExportDir() async {
    final tmp = await getTemporaryDirectory();
    final dir = Directory('${tmp.path}/taqwareels');
    await dir.create(recursive: true);
    return dir.path;
  }
}
```

---

## 15. FFmpeg Command Reference

### 15.1 Video Background Command

```dart
String _buildVideoBackgroundCommand({...}) {
  final W = opts.width;
  final H = opts.height;
  // Loop video, trim to totalDuration, overlay audio
  // drawtext per slide using segment timestamps
  final drawtextFilters = _buildDrawtextFilters(slides, slideDurations, state, fontPath, W, H);

  return [
    '-y',
    '-stream_loop -1 -i "$bgPath"',          // loop video background
    '-i "$audioPath"',
    '-t $totalDuration',                       // cut to exact audio length
    '-filter_complex',
    '"[0:v]scale=$W:$H:force_original_aspect_ratio=increase,'
    'crop=$W:$H,'
    'setsar=1,'
    'colorchannelmixer=aa=${1.0 - state.dimOpacity}:rr=0:rg=0:rb=0:gr=0:gg=0:gb=0:br=0:bg=0:bb=0,'  // dim
    'format=yuv420p'
    + drawtextFilters
    + '[v]"',
    '-map "[v]" -map 1:a',
    '-c:v libx264 -preset medium -crf 22',
    '-c:a aac -b:a 128k',
    '-shortest',
    '-movflags +faststart',
    '"$outputPath"',
  ].join(' ');
}
```

### 15.2 Image Background Command (with Ken Burns)

```dart
String _buildImageBackgroundCommand({...}) {
  final W = opts.width;
  final H = opts.height;
  final fps = 30;
  final totalFrames = (totalDuration * fps).ceil();
  final drawtextFilters = _buildDrawtextFilters(slides, slideDurations, state, fontPath, W, H);

  // Ken Burns: slow zoom-in over the duration
  final kenBurns = opts.kenBurnsEffect
    ? 'zoompan=z=\'min(zoom+0.0004,1.3)\':x=\'iw/2-(iw/zoom/2)\':y=\'ih/2-(ih/zoom/2)\':'
      'd=${totalFrames}:s=${W}x${H}:fps=$fps,'
    : 'scale=${W}:${H}:force_original_aspect_ratio=increase,crop=${W}:${H},';

  return [
    '-y',
    '-loop 1 -i "$bgPath"',
    '-i "$audioPath"',
    '-t $totalDuration',
    '-filter_complex',
    '"[0:v]${kenBurns}'
    'colorchannelmixer=aa=${1.0 - state.dimOpacity}:rr=0:rg=0:rb=0:gr=0:gg=0:gb=0:bb=0,'
    'setsar=1,format=yuv420p'
    + drawtextFilters
    + '[v]"',
    '-map "[v]" -map 1:a',
    '-c:v libx264 -preset medium -crf 22',
    '-c:a aac -b:a 128k',
    opts.audioFadeOut ? '-af "afade=t=out:st=${totalDuration - 1}:d=1"' : '',
    '-shortest',
    '-movflags +faststart',
    '"$outputPath"',
  ].where((s) => s.isNotEmpty).join(' ');
}
```

### 15.3 `drawtext` Filter Builder (Per-Slide Timed Text)

```dart
String _buildDrawtextFilters(
  List<ReelSlide> slides,
  List<double> durations,
  ReelState state,
  String fontPath,
  int W, int H,
) {
  final buf = StringBuffer();
  double t = 0;
  final hexColor = state.textColor.replaceFirst('#', '');
  final yFrac = state.textPosition;  // 0.0 top → 1.0 bottom
  final fontSize = state.fontSize.round();
  final shadow = state.showArabicShadow ? ':shadowcolor=black:shadowx=2:shadowy=2' : '';

  for (int i = 0; i < slides.length; i++) {
    final slide = slides[i];
    final dur   = durations[i];
    final start = t.toStringAsFixed(3);
    final end   = (t + dur).toStringAsFixed(3);

    // Escape special characters in text for FFmpeg
    final arText = _escapeDrawtext(slide.arabicText);
    final trText = _escapeDrawtext(slide.translationText);
    final refText = _escapeDrawtext(slide.slideLabel);

    // Vertical position
    final yBase = '${(yFrac * H * 0.7 + H * 0.1).round()}';

    // Arabic line
    buf.write(",drawtext=fontfile='$fontPath':text='$arText'"
      ":fontsize=$fontSize:fontcolor=0x$hexColor"
      ":x=(w-text_w)/2:y=$yBase"
      "$shadow"
      ":enable='between(t,$start,$end)'");

    // Translation line (smaller, italic via separate font if available)
    if (state.showTranslation && trText.isNotEmpty) {
      final trSize = (fontSize * 0.52).round();
      final yTr = '${(yFrac * H * 0.7 + H * 0.1 + fontSize * 2.2).round()}';
      buf.write(",drawtext=fontfile='$fontPath':text='$trText'"
        ":fontsize=$trSize:fontcolor=0x${hexColor}CC"
        ":x=(w-text_w)/2:y=$yTr"
        ":enable='between(t,$start,$end)'");
    }

    // Slide label
    final yRef = '${H - 80}';
    buf.write(",drawtext=fontfile='$fontPath':text='$refText'"
      ":fontsize=18:fontcolor=0x${hexColor}99"
      ":x=(w-text_w)/2:y=$yRef"
      ":enable='between(t,$start,$end)'");

    t += dur;
  }
  return buf.toString();
}

String _escapeDrawtext(String text) =>
  text.replaceAll("'", "\u2019")      // smart quote
      .replaceAll(':', '\\:')
      .replaceAll('[', '\\[')
      .replaceAll(']', '\\]');
```

---

## 16. `pubspec.yaml`

```yaml
name: taqwa_reels
description: Create and export beautiful Quran reels.
version: 1.0.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # State
  flutter_riverpod: ^2.5.1
  freezed_annotation: ^2.4.1

  # Navigation
  go_router: ^14.0.0

  # HTTP
  dio: ^5.4.3

  # Media
  just_audio: ^0.9.40
  video_player: ^2.8.6
  cached_network_image: ^3.3.1

  # Video Export (FFmpeg)
  ffmpeg_kit_flutter: ^6.0.3

  # File I/O
  path_provider: ^2.1.3

  # Gallery & Share
  gal: ^2.3.0
  share_plus: ^9.0.0

  # Permissions
  permission_handler: ^11.3.1
  connectivity_plus: ^6.0.3

  # Fonts
  google_fonts: ^6.2.1

  # UI Extras
  percent_indicator: ^4.2.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.9
  freezed: ^2.5.2
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/fonts/Amiri-Regular.ttf
    - assets/fonts/Amiri-Bold.ttf
    - assets/fonts/ScheherazadeNew-Regular.ttf
    - assets/fonts/NotoNaskhArabic-Regular.ttf
    - assets/fonts/Cinzel-Regular.ttf
    - assets/fonts/CormorantGaramond-Regular.ttf
  fonts:
    - family: Amiri
      fonts:
        - asset: assets/fonts/Amiri-Regular.ttf
        - asset: assets/fonts/Amiri-Bold.ttf
          weight: 700
    - family: Scheherazade New
      fonts:
        - asset: assets/fonts/ScheherazadeNew-Regular.ttf
    - family: Noto Naskh Arabic
      fonts:
        - asset: assets/fonts/NotoNaskhArabic-Regular.ttf
```

---

## 17. Android Manifest & Gradle

### `android/app/build.gradle`
```gradle
android {
    defaultConfig {
        applicationId "com.taqwareels.app"
        minSdkVersion 24
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    buildTypes {
        release {
            minifyEnabled false
            shrinkResources false
        }
    }
}
```

### `AndroidManifest.xml` (permissions)
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="29"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO"/>
```

---

## 18. Navigation

```dart
// lib/app.dart
final router = GoRouter(routes: [
  GoRoute(path: '/',           builder: (_, __) => const AyahSelectionScreen()),
  GoRoute(path: '/background', builder: (_, __) => const BackgroundScreen()),
  GoRoute(path: '/customize',  builder: (_, __) => const CustomizeScreen()),
  GoRoute(path: '/preview',    builder: (_, __) => const PreviewExportScreen()),
]);
```

---

## 19. Testing Checklist

### Unit Tests
- [ ] `buildSlides` / `_split` — correct count for 282-word ayah
- [ ] `_probeDuration` regex parses `Duration: 00:01:23.45` → `83.45`
- [ ] `_escapeDrawtext` escapes colons and brackets
- [ ] `getAudioUrl` generates correct EveryAyah URL

### Integration Tests
- [ ] Full ayah selection → slides generated → navigation to `/background`
- [ ] Background selected → persists to `/customize`
- [ ] Export triggered → FFmpeg completes → file exists at returned path

### Manual Device Tests
- [ ] Video background loops seamlessly at exact audio duration
- [ ] Image background shows Ken Burns zoom animation
- [ ] Text appears at correct Y position with Arabic RTL rendering
- [ ] Multiple slides: text changes at correct timestamps
- [ ] Audio syncs with each slide change frame-accurately
- [ ] Exported MP4 opens in gallery and plays correctly
- [ ] 1080p export produces 1080×1920 video
- [ ] Audio fade-out on last second works
- [ ] Offline error state shown when no connection

---

## 20. Migration Checklist

### Foundation
- [ ] Project created, `minSdkVersion 24` confirmed
- [ ] `pubspec.yaml` complete, `flutter pub get` passes
- [ ] Font TTF files downloaded and placed in `assets/fonts/`
- [ ] Design system (`AppColors`, `AppSpacing`, `AppTheme`) implemented
- [ ] GoRouter navigation skeleton working

### Data & State
- [ ] All models created (`Surah`, `ReelSlide`, `BackgroundItem`, `ExportOptions`)
- [ ] `ReelState` + `ReelNotifier` + all providers implemented
- [ ] Slide-splitting logic ported and unit tested

### Services
- [ ] `QuranApiService` with surah cache + parallel ayah fetch
- [ ] `PixabayService` with image + video search + cache
- [ ] `AudioService` URL builder
- [ ] `getFontPath` asset-to-filesystem copy utility

### Screens
- [ ] Screen 1: AyahSelection with audio preview
- [ ] Screen 2: BackgroundPicker with video thumbnails
- [ ] Screen 3: Customize with all controls + live preview
- [ ] Screen 4: Preview/Export with progress overlay

### Core Export Engine
- [ ] Background downloader (image + video)
- [ ] Audio downloader + merger
- [ ] Duration prober via FFmpegKit
- [ ] `drawtext` builder with per-slide timestamps
- [ ] Image command with Ken Burns filter
- [ ] Video command with loop + trim
- [ ] Audio fade-out filter (optional)
- [ ] Gallery save via `gal`
- [ ] Temp dir cleanup after export

### QA
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] Manual tests on physical Android device (minSdk 24)
- [ ] Release APK: `flutter build apk --release`

---

## Key Improvements Over React Native Version

| Factor | React Native (Old) | Flutter (New) |
|--------|--------------------|--------------|
| Export method | Screen capture → FFmpeg | Pure FFmpeg (no capture) |
| Video backgrounds | Downloaded then captured | Loop-trimmed directly by FFmpeg |
| Image backgrounds | Static screenshot | Ken Burns animated zoom |
| Audio sync | Estimated from duration ÷ slides | Frame-exact `between(t,start,end)` |
| Text overlay | React Native widget screenshot | FFmpeg `drawtext` filter with timestamps |
| Font support | 1 font (Amiri) | 5+ Google Fonts, selectable |
| Output quality | Fixed 720p | 720p or 1080p selectable |
| Audio fade | None | Optional 1s fade-out |
| Text shadow | None | Configurable shadow overlay |

---

*Updated: 2026-02-21 — Proper Video Export Architecture*
