enum ExportQuality { hd720, fhd1080 }

class ExportOptions {
  final ExportQuality quality;
  final bool kenBurnsEffect; // Image: slow zoom animation
  final bool audioFadeOut; // Fade out last 1s of audio
  final double textShadowOpacity;

  const ExportOptions({
    this.quality = ExportQuality.hd720,
    this.kenBurnsEffect = false,
    this.audioFadeOut = true,
    this.textShadowOpacity = 0.6,
  });

  Map<String, dynamic> toJson() => {
    'quality': quality.name,
    'kenBurnsEffect': kenBurnsEffect,
    'audioFadeOut': audioFadeOut,
    'textShadowOpacity': textShadowOpacity,
  };

  factory ExportOptions.fromJson(Map<String, dynamic> json) {
    return ExportOptions(
      quality: ExportQuality.values.firstWhere(
        (e) => e.name == json['quality'],
        orElse: () => ExportQuality.hd720,
      ),
      kenBurnsEffect: json['kenBurnsEffect'] as bool? ?? false,
      audioFadeOut: json['audioFadeOut'] as bool? ?? true,
      textShadowOpacity: (json['textShadowOpacity'] as num?)?.toDouble() ?? 0.6,
    );
  }

  /// Resolution string for FFmpeg
  String get resolution =>
      quality == ExportQuality.fhd1080 ? '1080x1920' : '720x1280';

  int get width => quality == ExportQuality.fhd1080 ? 1080 : 720;

  int get height => quality == ExportQuality.fhd1080 ? 1920 : 1280;
}
