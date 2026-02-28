import 'package:flutter/material.dart';

// ── Video quality (CRF) ──
enum VideoQuality {
  low, // CRF 28 – small file
  medium, // CRF 23 – balanced (default)
  high, // CRF 18 – best quality
}

extension VideoQualityLabel on VideoQuality {
  String get label {
    switch (this) {
      case VideoQuality.low:
        return 'Low (small file)';
      case VideoQuality.medium:
        return 'Medium';
      case VideoQuality.high:
        return 'High (best quality)';
    }
  }

  int get crf {
    switch (this) {
      case VideoQuality.low:
        return 28;
      case VideoQuality.medium:
        return 23;
      case VideoQuality.high:
        return 18;
    }
  }
}

// ── Watermark position ──
enum WatermarkPosition {
  topCenter,
  bottomCenter,
  hidden,
}

extension WatermarkPositionLabel on WatermarkPosition {
  String get label {
    switch (this) {
      case WatermarkPosition.topCenter:
        return 'Top';
      case WatermarkPosition.bottomCenter:
        return 'Bottom';
      case WatermarkPosition.hidden:
        return 'Hidden';
    }
  }
}

/// Predefined aspect ratios for social media targets and a custom option.
enum ExportRatio {
  instagramReel, // 9:16
  instagramPost, // 4:5
  instagramSquare, // 1:1
  youtubeVideo, // 16:9
  custom, // User-defined width/height
}

/// Human-readable labels for each ratio.
extension ExportRatioLabel on ExportRatio {
  String get label {
    switch (this) {
      case ExportRatio.instagramReel:
        return 'Reel / Story (9:16)';
      case ExportRatio.instagramPost:
        return 'Insta Post (4:5)';
      case ExportRatio.instagramSquare:
        return 'Square (1:1)';
      case ExportRatio.youtubeVideo:
        return 'YouTube (16:9)';
      case ExportRatio.custom:
        return 'Custom';
    }
  }

  IconData get icon {
    switch (this) {
      case ExportRatio.instagramReel:
        return Icons.phone_android_rounded;
      case ExportRatio.instagramPost:
        return Icons.crop_portrait_rounded;
      case ExportRatio.instagramSquare:
        return Icons.crop_square_rounded;
      case ExportRatio.youtubeVideo:
        return Icons.tv_rounded;
      case ExportRatio.custom:
        return Icons.tune_rounded;
    }
  }
}

class ExportOptions {
  final ExportRatio exportRatio;
  final int? customWidth;
  final int? customHeight;
  final bool kenBurnsEffect; // Image: slow zoom animation
  final bool audioFadeOut; // Fade out last 1s of audio
  final double textShadowOpacity;

  // ── New features ──
  final double backgroundBlur; // 0.0=off, up to 20.0
  final VideoQuality videoQuality; // CRF 28/23/18
  final double introPadding; // seconds of silence before first ayah
  final double outroPadding; // seconds of silence after last ayah
  final double bgSlowMo; // 0.5–1.0 (1.0 = normal speed)
  final WatermarkPosition watermarkPosition;
  final double watermarkFontSize; // 10–28 (default 14)
  final double watermarkOpacity; // 0.3–1.0 (default 0.78)
  final double translationFontScale; // multiplier vs Arabic size (default 0.52)

  const ExportOptions({
    this.exportRatio = ExportRatio.instagramReel,
    this.customWidth,
    this.customHeight,
    this.kenBurnsEffect = false,
    this.audioFadeOut = true,
    this.textShadowOpacity = 0.6,
    this.backgroundBlur = 0.0,
    this.videoQuality = VideoQuality.medium,
    this.introPadding = 0.0,
    this.outroPadding = 0.0,
    this.bgSlowMo = 1.0,
    this.watermarkPosition = WatermarkPosition.topCenter,
    this.watermarkFontSize = 14.0,
    this.watermarkOpacity = 0.78,
    this.translationFontScale = 0.52,
  });

  ExportOptions copyWith({
    ExportRatio? exportRatio,
    int? customWidth,
    int? customHeight,
    bool? kenBurnsEffect,
    bool? audioFadeOut,
    double? textShadowOpacity,
    double? backgroundBlur,
    VideoQuality? videoQuality,
    double? introPadding,
    double? outroPadding,
    double? bgSlowMo,
    WatermarkPosition? watermarkPosition,
    double? watermarkFontSize,
    double? watermarkOpacity,
    double? translationFontScale,
  }) =>
      ExportOptions(
        exportRatio: exportRatio ?? this.exportRatio,
        customWidth: customWidth ?? this.customWidth,
        customHeight: customHeight ?? this.customHeight,
        kenBurnsEffect: kenBurnsEffect ?? this.kenBurnsEffect,
        audioFadeOut: audioFadeOut ?? this.audioFadeOut,
        textShadowOpacity: textShadowOpacity ?? this.textShadowOpacity,
        backgroundBlur: backgroundBlur ?? this.backgroundBlur,
        videoQuality: videoQuality ?? this.videoQuality,
        introPadding: introPadding ?? this.introPadding,
        outroPadding: outroPadding ?? this.outroPadding,
        bgSlowMo: bgSlowMo ?? this.bgSlowMo,
        watermarkPosition: watermarkPosition ?? this.watermarkPosition,
        watermarkFontSize: watermarkFontSize ?? this.watermarkFontSize,
        watermarkOpacity: watermarkOpacity ?? this.watermarkOpacity,
        translationFontScale: translationFontScale ?? this.translationFontScale,
      );

  Map<String, dynamic> toJson() => {
    'exportRatio': exportRatio.name,
    'customWidth': customWidth,
    'customHeight': customHeight,
    'kenBurnsEffect': kenBurnsEffect,
    'audioFadeOut': audioFadeOut,
    'textShadowOpacity': textShadowOpacity,
    'backgroundBlur': backgroundBlur,
    'videoQuality': videoQuality.name,
    'introPadding': introPadding,
    'outroPadding': outroPadding,
    'bgSlowMo': bgSlowMo,
    'watermarkPosition': watermarkPosition.name,
    'watermarkFontSize': watermarkFontSize,
    'watermarkOpacity': watermarkOpacity,
    'translationFontScale': translationFontScale,
  };

  factory ExportOptions.fromJson(Map<String, dynamic> json) {
    // Backwards compatibility: map old 'quality' field → new exportRatio
    ExportRatio ratio = ExportRatio.instagramReel;
    if (json.containsKey('exportRatio')) {
      ratio = ExportRatio.values.firstWhere(
        (e) => e.name == json['exportRatio'],
        orElse: () => ExportRatio.instagramReel,
      );
    } else if (json.containsKey('quality')) {
      // Legacy: hd720 / fhd1080 both map to the default 9:16 reel
      ratio = ExportRatio.instagramReel;
    }

    return ExportOptions(
      exportRatio: ratio,
      customWidth: json['customWidth'] as int?,
      customHeight: json['customHeight'] as int?,
      kenBurnsEffect: json['kenBurnsEffect'] as bool? ?? false,
      audioFadeOut: json['audioFadeOut'] as bool? ?? true,
      textShadowOpacity:
          (json['textShadowOpacity'] as num?)?.toDouble() ?? 0.6,
      backgroundBlur:
          (json['backgroundBlur'] as num?)?.toDouble() ?? 0.0,
      videoQuality: VideoQuality.values.firstWhere(
        (e) => e.name == json['videoQuality'],
        orElse: () => VideoQuality.medium,
      ),
      introPadding:
          (json['introPadding'] as num?)?.toDouble() ?? 0.0,
      outroPadding:
          (json['outroPadding'] as num?)?.toDouble() ?? 0.0,
      bgSlowMo: (json['bgSlowMo'] as num?)?.toDouble() ?? 1.0,
      watermarkPosition: WatermarkPosition.values.firstWhere(
        (e) => e.name == json['watermarkPosition'],
        orElse: () => WatermarkPosition.topCenter,
      ),
      watermarkFontSize:
          (json['watermarkFontSize'] as num?)?.toDouble() ?? 14.0,
      watermarkOpacity:
          (json['watermarkOpacity'] as num?)?.toDouble() ?? 0.78,
      translationFontScale:
          (json['translationFontScale'] as num?)?.toDouble() ?? 0.52,
    );
  }

  // ── Computed dimensions ──

  /// Canonical width based on selected ratio.
  int get width {
    switch (exportRatio) {
      case ExportRatio.instagramReel:
        return 1080;
      case ExportRatio.instagramPost:
        return 1080;
      case ExportRatio.instagramSquare:
        return 1080;
      case ExportRatio.youtubeVideo:
        return 1920;
      case ExportRatio.custom:
        return (customWidth ?? 1080).clamp(300, 3840);
    }
  }

  /// Canonical height based on selected ratio.
  int get height {
    switch (exportRatio) {
      case ExportRatio.instagramReel:
        return 1920;
      case ExportRatio.instagramPost:
        return 1350;
      case ExportRatio.instagramSquare:
        return 1080;
      case ExportRatio.youtubeVideo:
        return 1080;
      case ExportRatio.custom:
        return (customHeight ?? 1920).clamp(300, 3840);
    }
  }

  /// Convenience aspect ratio value (width / height).
  double get aspectRatio => width / height;

  /// Resolution string for display purposes.
  String get resolution => '${width}x$height';
}
