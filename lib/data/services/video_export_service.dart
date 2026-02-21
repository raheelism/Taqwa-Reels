import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/font_utils.dart';
import '../models/background_item.dart';
import '../models/reel_slide.dart';
import '../models/export_options.dart';
import '../../state/reel_state.dart';
import 'audio_service.dart';

// ── Progress Reporting ──

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

  const ExportProgress({
    required this.phase,
    required this.label,
    required this.progress,
    this.detail,
  });
}

typedef OnProgress = void Function(ExportProgress);

// ── Video Export Service ──

class VideoExportService {
  final _dio = Dio();

  /// Main export entry point. Downloads assets, probes durations,
  /// builds FFmpeg command, and renders the final MP4.
  Future<String> exportVideo({
    required ReelState state,
    required OnProgress onProgress,
  }) async {
    final tmp = await _ensureExportDir();

    // ── Phase 1: Download background ──
    onProgress(const ExportProgress(
      phase: ExportPhase.downloadingBackground,
      label: 'Downloading background',
      progress: 0.0,
    ));
    final bgExt = state.background!.type == BackgroundType.video ? 'mp4' : 'jpg';
    final bgPath = await _downloadFile(
      state.background!.fullUrl,
      '$tmp/background.$bgExt',
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
        detail: 'Ayah $n (${i + 1}/${uniqueAyahs.length})',
      ));
      final url = getAudioUrl(state.reciter.folder, state.surahNumber!, n);
      final path = '$tmp/audio_${n.toString().padLeft(3, "0")}.mp3';
      await _downloadFile(url, path);
      audioMap[n] = path;
    }

    // ── Phase 3: Probe audio durations ──
    onProgress(const ExportProgress(
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
      slideCountPerAyah[s.ayahNumber] =
          (slideCountPerAyah[s.ayahNumber] ?? 0) + 1;
    }
    final slideDurations = state.slides
        .map((s) =>
            (durations[s.ayahNumber] ?? 5.0) /
            (slideCountPerAyah[s.ayahNumber] ?? 1))
        .toList();

    final totalDuration = slideDurations.fold(0.0, (a, b) => a + b);

    // ── Phase 5: Merge audio ──
    final orderedAyahs = <int>[];
    for (final s in state.slides) {
      if (!orderedAyahs.contains(s.ayahNumber)) orderedAyahs.add(s.ayahNumber);
    }
    final audioConcatContent =
        orderedAyahs.map((n) => "file '${audioMap[n]}'").join('\n');
    final audioConcatPath = '$tmp/audio_list.txt';
    await File(audioConcatPath).writeAsString(audioConcatContent);

    final mergedAudioPath = '$tmp/merged.mp3';
    final audioSession = await FFmpegKit.execute(
      '-y -f concat -safe 0 -i "$audioConcatPath" -c copy "$mergedAudioPath"',
    );
    if (!ReturnCode.isSuccess(await audioSession.getReturnCode())) {
      throw Exception(
          'Audio merge failed: ${await audioSession.getOutput()}');
    }

    // ── Phase 6: Get font path ──
    final fontPath = await getFontPath(state.font.ffmpegFontFile);

    // ── Phase 7: Render video ──
    onProgress(const ExportProgress(
      phase: ExportPhase.renderingVideo,
      label: 'Rendering video',
      progress: 0.35,
    ));
    final opts = state.exportOptions;
    final outputPath =
        '$tmp/TaqwaReels_${DateTime.now().millisecondsSinceEpoch}.mp4';

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

    // Track FFmpeg progress via statistics callback
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

    onProgress(const ExportProgress(
      phase: ExportPhase.done,
      label: 'Complete!',
      progress: 1.0,
    ));
    return outputPath;
  }

  // ── Helpers ──

  Future<String> _downloadFile(String url, String savePath) async {
    await _dio.download(url, savePath);
    return savePath;
  }

  Future<double> _probeDuration(String path) async {
    final session = await FFmpegKit.execute('-i "$path" -f null -');
    final out = await session.getOutput() ?? '';
    final m =
        RegExp(r'Duration:\s*(\d+):(\d+):(\d+)\.(\d+)').firstMatch(out);
    if (m != null) {
      return int.parse(m.group(1)!) * 3600 +
          int.parse(m.group(2)!) * 60 +
          int.parse(m.group(3)!) +
          int.parse(m.group(4)!) / 100;
    }
    return 5.0; // fallback if duration cannot be probed
  }

  Future<String> _ensureExportDir() async {
    final tmp = await getTemporaryDirectory();
    final dir = Directory('${tmp.path}/taqwareels');
    await dir.create(recursive: true);
    return dir.path;
  }

  // ── FFmpeg command builders ──

  String _buildVideoBackgroundCommand({
    required String bgPath,
    required String audioPath,
    required List<ReelSlide> slides,
    required List<double> slideDurations,
    required double totalDuration,
    required ReelState state,
    required String fontPath,
    required String outputPath,
    required ExportOptions opts,
  }) {
    final w = opts.width;
    final h = opts.height;
    final drawtextFilters =
        _buildDrawtextFilters(slides, slideDurations, state, fontPath, w, h);

    return [
      '-y',
      '-stream_loop -1 -i "$bgPath"',
      '-i "$audioPath"',
      '-t $totalDuration',
      '-filter_complex',
      '"[0:v]scale=$w:$h:force_original_aspect_ratio=increase,'
          'crop=$w:$h,'
          'setsar=1,'
          'format=yuv420p'
          '$drawtextFilters'
          '[v]"',
      '-map "[v]" -map 1:a',
      '-c:v libx264 -preset medium -crf 22',
      '-c:a aac -b:a 128k',
      '-shortest',
      '-movflags +faststart',
      '"$outputPath"',
    ].join(' ');
  }

  String _buildImageBackgroundCommand({
    required String bgPath,
    required String audioPath,
    required List<ReelSlide> slides,
    required List<double> slideDurations,
    required double totalDuration,
    required ReelState state,
    required String fontPath,
    required String outputPath,
    required ExportOptions opts,
  }) {
    final w = opts.width;
    final h = opts.height;
    const fps = 30;
    final totalFrames = (totalDuration * fps).ceil();
    final drawtextFilters =
        _buildDrawtextFilters(slides, slideDurations, state, fontPath, w, h);

    final kenBurns = opts.kenBurnsEffect
        ? "zoompan=z='min(zoom+0.0004,1.3)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':"
            'd=$totalFrames:s=${w}x$h:fps=$fps,'
        : 'scale=$w:$h:force_original_aspect_ratio=increase,crop=$w:$h,';

    return [
      '-y',
      '-loop 1 -i "$bgPath"',
      '-i "$audioPath"',
      '-t $totalDuration',
      '-filter_complex',
      '"[0:v]$kenBurns'
          'setsar=1,format=yuv420p'
          '$drawtextFilters'
          '[v]"',
      '-map "[v]" -map 1:a',
      '-c:v libx264 -preset medium -crf 22',
      '-c:a aac -b:a 128k',
      if (opts.audioFadeOut)
        '-af "afade=t=out:st=${totalDuration - 1}:d=1"',
      '-shortest',
      '-movflags +faststart',
      '"$outputPath"',
    ].where((s) => s.isNotEmpty).join(' ');
  }

  String _buildDrawtextFilters(
    List<ReelSlide> slides,
    List<double> durations,
    ReelState state,
    String fontPath,
    int w,
    int h,
  ) {
    final buf = StringBuffer();
    double t = 0;
    final hexColor = state.textColor.replaceFirst('#', '');
    final yFrac = state.textPosition;
    final fontSize = state.fontSize.round();
    final shadow =
        state.showArabicShadow ? ':shadowcolor=black:shadowx=2:shadowy=2' : '';

    for (int i = 0; i < slides.length; i++) {
      final slide = slides[i];
      final dur = durations[i];
      final start = t.toStringAsFixed(3);
      final end = (t + dur).toStringAsFixed(3);

      final arText = _escapeDrawtext(slide.arabicText);
      final trText = _escapeDrawtext(slide.translationText);
      final refText = _escapeDrawtext(slide.slideLabel);

      final yBase = '${(yFrac * h * 0.7 + h * 0.1).round()}';

      // Arabic line
      buf.write(",drawtext=fontfile='$fontPath':text='$arText'"
          ":fontsize=$fontSize:fontcolor=0x$hexColor"
          ":x=(w-text_w)/2:y=$yBase"
          "$shadow"
          ":enable='between(t,$start,$end)'");

      // Translation line
      if (state.showTranslation && trText.isNotEmpty) {
        final trSize = (fontSize * 0.52).round();
        final yTr = '${(yFrac * h * 0.7 + h * 0.1 + fontSize * 2.2).round()}';
        buf.write(",drawtext=fontfile='$fontPath':text='$trText'"
            ":fontsize=$trSize:fontcolor=0x${hexColor}CC"
            ":x=(w-text_w)/2:y=$yTr"
            ":enable='between(t,$start,$end)'");
      }

      // Slide label
      final yRef = '${h - 80}';
      buf.write(",drawtext=fontfile='$fontPath':text='$refText'"
          ":fontsize=18:fontcolor=0x${hexColor}99"
          ":x=(w-text_w)/2:y=$yRef"
          ":enable='between(t,$start,$end)'");

      t += dur;
    }
    return buf.toString();
  }

  String _escapeDrawtext(String text) => text
      .replaceAll("'", "\u2019") // smart quote
      .replaceAll(':', '\\:')
      .replaceAll('[', '\\[')
      .replaceAll(']', '\\]');
}
