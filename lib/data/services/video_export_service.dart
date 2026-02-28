import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/text_renderer.dart';
import '../models/background_item.dart';
import '../models/export_options.dart';
import '../models/generated_video.dart';
import '../../state/reel_state.dart';
import 'audio_service.dart';

// ── Progress Reporting ──

enum ExportPhase {
  downloadingBackground,
  downloadingAudio,
  probingDurations,
  renderingTextOverlays,
  renderingVideo,
  savingMetadata,
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
  final _uuid = const Uuid();

  /// Main export entry point. Downloads assets, renders text overlays
  /// as PNG images, builds FFmpeg overlay command, and renders the final MP4.
  Future<String> exportVideo({
    required ReelState state,
    required OnProgress onProgress,
  }) async {
    final tmp = await _ensureExportDir();

    // ── Phase 1: Download background ──
    onProgress(
      const ExportProgress(
        phase: ExportPhase.downloadingBackground,
        label: 'Downloading background',
        progress: 0.0,
      ),
    );
    String bgPath;
    if (state.background!.type == BackgroundType.solidColor) {
      // Solid color — no download needed, create a placeholder path
      bgPath = '$tmp/background.jpg';
    } else {
      final bgExt = state.background!.type == BackgroundType.video
          ? 'mp4'
          : 'jpg';
      bgPath = await _downloadFile(
        state.background!.fullUrl,
        '$tmp/background.$bgExt',
      );
    }

    // ── Phase 2: Download audio ──
    final uniqueAyahs = state.slides.map((s) => s.ayahNumber).toSet().toList();
    final audioMap = <int, String>{};
    for (int i = 0; i < uniqueAyahs.length; i++) {
      final n = uniqueAyahs[i];
      onProgress(
        ExportProgress(
          phase: ExportPhase.downloadingAudio,
          label: 'Downloading audio',
          progress: 0.05 + (i / uniqueAyahs.length) * 0.15,
          detail: 'Ayah $n (${i + 1}/${uniqueAyahs.length})',
        ),
      );
      final url = getAudioUrl(state.reciter.folder, state.surahNumber!, n);
      final path = '$tmp/audio_${n.toString().padLeft(3, "0")}.mp3';
      await _downloadFile(url, path);
      audioMap[n] = path;
    }

    // ── Phase 3: Probe audio durations ──
    onProgress(
      const ExportProgress(
        phase: ExportPhase.probingDurations,
        label: 'Analysing audio',
        progress: 0.20,
      ),
    );
    final durations = <int, double>{};
    for (final n in uniqueAyahs) {
      durations[n] = await _probeDuration(audioMap[n]!);
    }

    // ── Phase 4: Per-slide durations ──
    final totalWordsPerAyah = <int, int>{};
    for (final s in state.slides) {
      final wc = s.arabicText.split(RegExp(r'\s+')).length;
      totalWordsPerAyah[s.ayahNumber] =
          (totalWordsPerAyah[s.ayahNumber] ?? 0) + wc;
    }

    final slideDurations = state.slides.map((s) {
      final ayahDuration = durations[s.ayahNumber] ?? 5.0;
      final slideWords = s.arabicText.split(RegExp(r'\s+')).length;
      final totalWords = totalWordsPerAyah[s.ayahNumber] ?? 1;
      return ayahDuration * (slideWords / totalWords);
    }).toList();

    final totalDuration = slideDurations.fold(0.0, (a, b) => a + b);

    final opts = state.exportOptions;

    // ── Phase 5: Merge audio (with optional intro/outro padding) ──
    final orderedAyahs = <int>[];
    for (final s in state.slides) {
      if (!orderedAyahs.contains(s.ayahNumber)) {
        orderedAyahs.add(s.ayahNumber);
      }
    }
    final audioConcatContent = orderedAyahs
        .map((n) => "file '${audioMap[n]}'")
        .join('\n');
    final audioConcatPath = '$tmp/audio_list.txt';
    await File(audioConcatPath).writeAsString(audioConcatContent);

    final rawMergedPath = '$tmp/merged_raw.mp3';
    final audioSession = await FFmpegKit.execute(
      '-y -f concat -safe 0 -i "$audioConcatPath" -c copy "$rawMergedPath"',
    );
    if (!ReturnCode.isSuccess(await audioSession.getReturnCode())) {
      throw Exception('Audio merge failed: ${await audioSession.getOutput()}');
    }

    // Apply intro / outro silence padding if configured
    final intro = opts.introPadding;
    final outro = opts.outroPadding;
    final mergedAudioPath = '$tmp/merged.mp3';
    if (intro > 0 || outro > 0) {
      // adelay delays the audio, apad adds silence at the end
      final delayMs = (intro * 1000).round();
      final filters = <String>[];
      if (intro > 0) filters.add('adelay=${delayMs}|${delayMs}');
      if (outro > 0) filters.add('apad=pad_dur=${outro.toStringAsFixed(2)}');
      await FFmpegKit.execute(
        '-y -i "$rawMergedPath" -af "${filters.join(',')}" "$mergedAudioPath"',
      );
    } else {
      // No padding, just rename
      await File(rawMergedPath).copy(mergedAudioPath);
    }

    final effectiveTotalDuration = totalDuration + intro + outro;

    // ── Phase 6: Render text overlays as PNG images ──
    onProgress(
      const ExportProgress(
        phase: ExportPhase.renderingTextOverlays,
        label: 'Rendering text overlays',
        progress: 0.25,
      ),
    );
    final slidePngs = await TextRenderer.renderAllSlides(
      state: state,
      width: opts.width,
      height: opts.height,
      outputDir: tmp,
      onProgress: (i, total) {
        onProgress(
          ExportProgress(
            phase: ExportPhase.renderingTextOverlays,
            label: 'Rendering text overlays',
            progress: 0.25 + (i / total) * 0.10,
            detail: 'Slide ${i + 1}/$total',
          ),
        );
      },
    );

    // ── Phase 7: Render video with FFmpeg ──
    onProgress(
      const ExportProgress(
        phase: ExportPhase.renderingVideo,
        label: 'Rendering video',
        progress: 0.35,
      ),
    );
    final videoId = _uuid.v4();
    final persistentDir = await _ensurePersistentDir();
    final outputPath = '$persistentDir/$videoId.mp4';
    final thumbPath = '$persistentDir/${videoId}_thumb.jpg';

    // Pre-bake the looped video background to exact duration to
    // eliminate timestamp discontinuities that cause early-second jitter.
    String effectiveBgPath = bgPath;
    if (state.background!.type == BackgroundType.video) {
      onProgress(
        const ExportProgress(
          phase: ExportPhase.renderingVideo,
          label: 'Preparing background',
          progress: 0.35,
        ),
      );
      effectiveBgPath = await _preprocessBackgroundVideo(
        bgPath: bgPath,
        totalDuration: effectiveTotalDuration,
        width: opts.width,
        height: opts.height,
        tmpDir: tmp,
        blurRadius: opts.backgroundBlur,
        slowMo: opts.bgSlowMo,
      );
    }

    String cmd;
    if (state.background!.type == BackgroundType.video) {
      cmd = _buildVideoBackgroundCommand(
        bgPath: effectiveBgPath,
        audioPath: mergedAudioPath,
        slidePngs: slidePngs,
        slideDurations: slideDurations,
        totalDuration: effectiveTotalDuration,
        state: state,
        outputPath: outputPath,
        opts: opts,
      );
    } else if (state.background!.type == BackgroundType.solidColor) {
      cmd = _buildSolidColorBackgroundCommand(
        colorHex: state.background!.solidColorHex ?? '#0A0E1A',
        audioPath: mergedAudioPath,
        slidePngs: slidePngs,
        slideDurations: slideDurations,
        totalDuration: effectiveTotalDuration,
        state: state,
        outputPath: outputPath,
        opts: opts,
      );
    } else {
      cmd = _buildImageBackgroundCommand(
        bgPath: bgPath,
        audioPath: mergedAudioPath,
        slidePngs: slidePngs,
        slideDurations: slideDurations,
        totalDuration: effectiveTotalDuration,
        state: state,
        outputPath: outputPath,
        opts: opts,
      );
    }

    // Track FFmpeg progress via statistics callback
    FFmpegKitConfig.enableStatisticsCallback((stats) {
      final t = stats.getTime() / 1000;
      onProgress(
        ExportProgress(
          phase: ExportPhase.renderingVideo,
          label: 'Rendering video',
          progress: 0.35 + (t / effectiveTotalDuration).clamp(0, 1) * 0.55,
          detail:
              '${((t / effectiveTotalDuration) * 100).clamp(0, 100).round()}% encoded',
        ),
      );
    });

    final session = await FFmpegKit.execute(cmd);
    final rc = await session.getReturnCode();
    if (!ReturnCode.isSuccess(rc)) {
      final log = await session.getOutput();
      throw Exception('FFmpeg failed:\n$log');
    }

    // ── Phase 8: Save Metadata and generate thumbnail ──
    onProgress(
      const ExportProgress(
        phase: ExportPhase.savingMetadata,
        label: 'Saving to Gallery',
        progress: 0.95,
      ),
    );

    // Grab a clean frame from the background to use as the thumbnail
    // For images, we just scale it. For videos, we grab a frame at 3 seconds
    // to bypass typical Pixabay intro slates, or at 50% if the video is very short.
    if (state.background!.type == BackgroundType.video) {
      final thumbTime = effectiveTotalDuration > 10.0
          ? '00:00:03.000'
          : (effectiveTotalDuration / 2).toStringAsFixed(3);
      await FFmpegKit.execute(
        '-y -i "$effectiveBgPath" -ss $thumbTime -vframes 1 -vf "scale=${opts.width}:${opts.height}:force_original_aspect_ratio=increase,crop=${opts.width}:${opts.height}" "$thumbPath"',
      );
    } else if (state.background!.type == BackgroundType.solidColor) {
      final hex = (state.background!.solidColorHex ?? '#0A0E1A').replaceFirst('#', '');
      await FFmpegKit.execute(
        '-y -f lavfi -i "color=c=0x$hex:s=${opts.width}x${opts.height}:d=1" -vframes 1 "$thumbPath"',
      );
    } else {
      await FFmpegKit.execute(
        '-y -i "$bgPath" -vframes 1 -vf "scale=${opts.width}:${opts.height}:force_original_aspect_ratio=increase,crop=${opts.width}:${opts.height}" "$thumbPath"',
      );
    }

    final metadataJson = jsonEncode({
      'surahNumber': state.surahNumber,
      'surahName': state.surahName,
      'fromAyah': state.fromAyah,
      'toAyah': state.toAyah,
      'slides': state.slides.map((s) => s.toJson()).toList(),
      'reciter': state.reciter.toJson(),
      'exportOptions': state.exportOptions.toJson(),
      'backgroundId': state.background?.id,
      'backgroundPreviewUrl': state.background?.previewUrl,
      'backgroundFullUrl': state.background?.fullUrl,
      'backgroundDuration': state.background?.duration,
      'backgroundType': state.background?.type == BackgroundType.video
          ? 'video'
          : state.background?.type == BackgroundType.solidColor
              ? 'solidColor'
              : 'image',
      'solidColorHex': state.background?.solidColorHex,
      // Text options
      'fontId': state.font.id,
      'textColor': state.textColor,
      'textPosition': state.textPosition,
      'fontSize': state.fontSize,
      'dimOpacity': state.dimOpacity,
      'showTranslation': state.showTranslation,
      'showArabicShadow': state.showArabicShadow,
      'includeBismillah': state.includeBismillah,
      'showAyahNumber': state.showAyahNumber,
      'watermarkText': state.watermarkText,
      'translationId': state.translation.id,
    });

    final box = Hive.box<GeneratedVideo>('videos');
    await box.put(
      videoId,
      GeneratedVideo(
        id: videoId,
        videoPath: outputPath,
        thumbnailPath: thumbPath,
        createdAt: DateTime.now(),
        metadataJson: metadataJson,
      ),
    );

    onProgress(
      const ExportProgress(
        phase: ExportPhase.done,
        label: 'Complete!',
        progress: 1.0,
      ),
    );
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
    final m = RegExp(r'Duration:\s*(\d+):(\d+):(\d+)\.(\d+)').firstMatch(out);
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

  Future<String> _ensurePersistentDir() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/taqwa_gallery');
    await dir.create(recursive: true);
    return dir.path;
  }

  /// Pre-bake the looped video background into a single clip of the exact
  /// required duration. This eliminates all loop-seam timestamp issues
  /// *before* the complex overlay filter graph runs.
  Future<String> _preprocessBackgroundVideo({
    required String bgPath,
    required double totalDuration,
    required int width,
    required int height,
    required String tmpDir,
    double blurRadius = 0.0,
    double slowMo = 1.0,
  }) async {
    final processedPath = '$tmpDir/background_processed.mp4';
    // Slow-mo: setpts=PTS*factor stretches video (factor > 1 = slower)
    final ptsFactor = (1.0 / slowMo.clamp(0.25, 1.0)).toStringAsFixed(4);
    // Blur filter (applied after scale/crop)
    final blurFilter = blurRadius > 0
        ? ',boxblur=${blurRadius.round()}:${blurRadius.round()}'
        : '';
    final session = await FFmpegKit.execute(
      '-y -stream_loop -1 -i "$bgPath" -t $totalDuration '
      '-vf "fps=30,setpts=PTS*$ptsFactor,'
      'scale=$width:$height:force_original_aspect_ratio=increase,'
      'crop=$width:$height,setsar=1$blurFilter" '
      '-vsync cfr -c:v libx264 -preset ultrafast -crf 23 -an "$processedPath"',
    );
    final rc = await session.getReturnCode();
    if (!ReturnCode.isSuccess(rc)) {
      final log = await session.getOutput();
      throw Exception('Background pre-processing failed:\n$log');
    }
    return processedPath;
  }

  // ── Overlay filter builder ──
  /// Builds the -filter_complex string that chains overlay filters
  /// for each slide PNG, each enabled for its time window.
  String _buildOverlayFilterChain({
    required List<String> slidePngs,
    required List<double> slideDurations,
    required String bgFilterChain,
    double introOffset = 0.0,
  }) {
    // bgFilterChain produces [bg] label
    final buf = StringBuffer(bgFilterChain);

    double t = introOffset;
    for (int i = 0; i < slidePngs.length; i++) {
      final inputIdx = i + 2; // inputs 0=bg, 1=audio, 2..N+1=slides
      final start = t.toStringAsFixed(3);
      final end = (t + slideDurations[i]).toStringAsFixed(3);
      final inLabel = i == 0 ? 'bg' : 's${i - 1}';
      final outLabel = i == slidePngs.length - 1 ? 'v' : 's$i';

      buf.write(
        ";[$inLabel][$inputIdx:v]overlay=0:0:format=auto"
        ":enable='between(t,$start,$end)'[$outLabel]",
      );
      t += slideDurations[i];
    }

    return buf.toString();
  }

  // ── FFmpeg command builders ──

  String _buildVideoBackgroundCommand({
    required String bgPath,
    required String audioPath,
    required List<String> slidePngs,
    required List<double> slideDurations,
    required double totalDuration,
    required ReelState state,
    required String outputPath,
    required ExportOptions opts,
  }) {
    // Dim overlay
    final dimAlpha = state.dimOpacity.toStringAsFixed(2);

    // Background filter chain → produces [bg]
    // bgPath is already pre-baked (looped, scaled, cropped) so only
    // timestamp reset, pixel format, and dimming are needed here.
    final bgChain =
        '[0:v]setpts=PTS-STARTPTS,format=yuv420p,'
        'drawbox=c=black@$dimAlpha:t=fill[bg]';

    final filterComplex = _buildOverlayFilterChain(
      slidePngs: slidePngs,
      slideDurations: slideDurations,
      bgFilterChain: bgChain,
      introOffset: opts.introPadding,
    );

    // Build input list — no -stream_loop, bgPath is already the right length
    final inputs = [
      '-i "$bgPath"',
      '-i "$audioPath"',
      ...slidePngs.map((p) => '-i "$p"'),
    ];

    final crf = opts.videoQuality.crf;

    return [
      '-y',
      ...inputs,
      '-t $totalDuration',
      '-filter_complex',
      '"$filterComplex"',
      '-map "[v]" -map 1:a',
      '-vsync cfr',
      '-c:v libx264 -preset ultrafast -crf $crf',
      '-c:a aac -b:a 128k',
      '-pix_fmt yuv420p',
      '-movflags +faststart',
      '"$outputPath"',
    ].join(' ');
  }

  String _buildImageBackgroundCommand({
    required String bgPath,
    required String audioPath,
    required List<String> slidePngs,
    required List<double> slideDurations,
    required double totalDuration,
    required ReelState state,
    required String outputPath,
    required ExportOptions opts,
  }) {
    final w = opts.width;
    final h = opts.height;
    const fps = 30;
    final totalFrames = (totalDuration * fps).ceil();

    final dimAlpha = state.dimOpacity.toStringAsFixed(2);

    // Blur filter for image backgrounds
    final blurFilter = opts.backgroundBlur > 0
        ? ',boxblur=${opts.backgroundBlur.round()}:${opts.backgroundBlur.round()}'
        : '';

    final kenBurns = opts.kenBurnsEffect
        ? "zoompan=z='min(zoom+0.0004,1.3)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':"
              'd=$totalFrames:s=${w}x$h:fps=$fps,'
        : 'scale=$w:$h:force_original_aspect_ratio=increase,crop=$w:$h,';

    // Background filter chain → produces [bg]
    final bgChain =
        '[0:v]$kenBurns'
        'setsar=1,format=yuva420p$blurFilter,'
        'drawbox=c=black@$dimAlpha:t=fill[bg]';

    final filterComplex = _buildOverlayFilterChain(
      slidePngs: slidePngs,
      slideDurations: slideDurations,
      bgFilterChain: bgChain,
      introOffset: opts.introPadding,
    );

    final inputs = [
      '-loop 1 -i "$bgPath"',
      '-i "$audioPath"',
      ...slidePngs.map((p) => '-i "$p"'),
    ];

    final crf = opts.videoQuality.crf;

    return [
      '-y',
      ...inputs,
      '-t $totalDuration',
      '-filter_complex',
      '"$filterComplex"',
      '-map "[v]" -map 1:a',
      '-c:v libx264 -preset ultrafast -crf $crf',
      '-c:a aac -b:a 128k',
      '-pix_fmt yuv420p',
      if (opts.audioFadeOut) '-af "afade=t=out:st=${totalDuration - 1}:d=1"',
      '-shortest',
      '-movflags +faststart',
      '"$outputPath"',
    ].where((s) => s.isNotEmpty).join(' ');
  }

  /// Build FFmpeg command using a solid-color background (no file input).
  String _buildSolidColorBackgroundCommand({
    required String colorHex,
    required String audioPath,
    required List<String> slidePngs,
    required List<double> slideDurations,
    required double totalDuration,
    required ReelState state,
    required String outputPath,
    required ExportOptions opts,
  }) {
    final w = opts.width;
    final h = opts.height;
    final hex = colorHex.replaceFirst('#', '');

    final dimAlpha = state.dimOpacity.toStringAsFixed(2);

    // Solid color source → dim → [bg]
    final bgChain =
        '[0:v]format=yuva420p,'
        'drawbox=c=black@$dimAlpha:t=fill[bg]';

    final filterComplex = _buildOverlayFilterChain(
      slidePngs: slidePngs,
      slideDurations: slideDurations,
      bgFilterChain: bgChain,
      introOffset: opts.introPadding,
    );

    final inputs = [
      '-f lavfi -i "color=c=0x$hex:s=${w}x$h:d=$totalDuration:r=30"',
      '-i "$audioPath"',
      ...slidePngs.map((p) => '-i "$p"'),
    ];

    final crf = opts.videoQuality.crf;

    return [
      '-y',
      ...inputs,
      '-t $totalDuration',
      '-filter_complex',
      '"$filterComplex"',
      '-map "[v]" -map 1:a',
      '-c:v libx264 -preset ultrafast -crf $crf',
      '-c:a aac -b:a 128k',
      '-pix_fmt yuv420p',
      if (opts.audioFadeOut) '-af "afade=t=out:st=${totalDuration - 1}:d=1"',
      '-shortest',
      '-movflags +faststart',
      '"$outputPath"',
    ].where((s) => s.isNotEmpty).join(' ');
  }
}
