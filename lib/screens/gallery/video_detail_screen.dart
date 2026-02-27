import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/models/generated_video.dart';
import '../../data/models/reciter.dart';
import '../../data/models/export_options.dart';
import '../../data/constants/reciters.dart';
import '../../data/constants/font_options.dart';
import '../../data/constants/translations.dart';
import '../../data/models/background_item.dart';
import '../../state/reel_provider.dart';
import '../../state/reel_state.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/reel_slide.dart';

class VideoDetailScreen extends ConsumerStatefulWidget {
  final String videoId;

  const VideoDetailScreen({super.key, required this.videoId});

  @override
  ConsumerState<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends ConsumerState<VideoDetailScreen> {
  VideoPlayerController? _controller;
  GeneratedVideo? _video;
  bool _isLoadingEdit = false;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  void _loadVideo() {
    final box = Hive.box<GeneratedVideo>('videos');
    _video = box.get(widget.videoId);

    if (_video != null) {
      _controller = VideoPlayerController.file(File(_video!.videoPath))
        ..initialize().then((_) {
          setState(() {}); // Update UI once video is ready
          _controller!.play();
          _controller!.setLooping(true);
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Parses metadata JSON and sets the providers so user can "Edit Again"
  Future<void> _editAgain() async {
    if (_video == null) return;

    setState(() => _isLoadingEdit = true);

    try {
      final metadata = jsonDecode(_video!.metadataJson) as Map<String, dynamic>;

      // Attempt to resolve the background if we have an ID
      BackgroundItem? bg;
      if (metadata['backgroundId'] != null) {
        try {
          final isVideo = metadata['backgroundType'] == 'video';
          final durationVal = metadata['backgroundDuration'];
          int durationInt = 0;
          if (durationVal != null) {
            if (durationVal is String) {
              durationInt = int.tryParse(durationVal) ?? 0;
            } else if (durationVal is num) {
              durationInt = durationVal.toInt();
            }
          }

          if (metadata['backgroundFullUrl'] != null &&
              metadata['backgroundFullUrl'].toString().isNotEmpty) {
            bg = BackgroundItem(
              id: metadata['backgroundId'],
              type: isVideo ? BackgroundType.video : BackgroundType.image,
              previewUrl: metadata['backgroundPreviewUrl'] ?? '',
              fullUrl: metadata['backgroundFullUrl'],
              duration: durationInt,
            );
          } else {
            // Fallback for old reels saved without URLs (dummy urls)
            bg = BackgroundItem(
              id: metadata['backgroundId'],
              type: BackgroundType.image,
              previewUrl: '',
              fullUrl: '',
              duration: 0,
            );
          }
        } catch (_) {}
      }

      final slidesList =
          (metadata['slides'] as List?)
              ?.map((s) => ReelSlide.fromJson(s))
              .toList() ??
          [];

      FontOption fontToUse = kFontOptions.first;
      if (metadata['fontId'] != null) {
        fontToUse = kFontOptions.firstWhere(
          (f) => f.id == metadata['fontId'],
          orElse: () => kFontOptions.first,
        );
      }

      final oldState = ReelState(
        surahNumber: metadata['surahNumber'] as int?,
        surahName: metadata['surahName'] as String? ?? '',
        fromAyah: metadata['fromAyah'] as int?,
        toAyah: metadata['toAyah'] as int?,
        slides: slidesList,
        reciter: metadata['reciter'] != null
            ? Reciter.fromJson(metadata['reciter'])
            : kReciters.first,
        translation: kTranslations
            .first, // Translation logic not fully serialized yet, fallback to first
        background: bg,
        exportOptions: metadata['exportOptions'] != null
            ? ExportOptions.fromJson(metadata['exportOptions'])
            : const ExportOptions(),
        font: fontToUse,
        textColor: metadata['textColor'] as String? ?? '#FFFFFF',
        textPosition: (metadata['textPosition'] as num?)?.toDouble() ?? 0.5,
        fontSize: (metadata['fontSize'] as num?)?.toDouble() ?? 28.0,
        dimOpacity: (metadata['dimOpacity'] as num?)?.toDouble() ?? 0.4,
        showTranslation: metadata['showTranslation'] as bool? ?? true,
        showArabicShadow: metadata['showArabicShadow'] as bool? ?? true,
        includeBismillah: metadata['includeBismillah'] as bool? ?? false,
        showAyahNumber: metadata['showAyahNumber'] as bool? ?? true,
        watermarkText: metadata['watermarkText'] as String? ?? 'TaqwaReels',
      );

      // Inject the old state into provider
      ref.read(reelProvider.notifier).restore(oldState);

      // Pause the video before leaving the screen
      _controller?.pause();

      // Navigate to customization
      if (mounted) {
        context.push('/customize');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error restoring state: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoadingEdit = false);
    }
  }

  void _shareVideo() {
    if (_video != null) {
      SharePlus.instance.share(
        ShareParams(
          files: [XFile(_video!.videoPath)],
          text: 'Check out my TaqwaReel!',
        ),
      );
    }
  }

  void _deleteVideo() async {
    if (_video == null) return;

    final box = Hive.box<GeneratedVideo>('videos');

    // Delete physical files
    try {
      final vFile = File(_video!.videoPath);
      if (await vFile.exists()) await vFile.delete();

      final tFile = File(_video!.thumbnailPath);
      if (await tFile.exists()) await tFile.delete();
    } catch (_) {}

    // Delete db entry
    await box.delete(widget.videoId);

    if (mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video deleted successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_video == null) {
      return const Scaffold(body: Center(child: Text('Video not found.')));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Center(
        child: _controller != null && _controller!.value.isInitialized
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    if (_controller!.value.isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                    if (!_controller!.value.isPlaying)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(16),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                  ],
                ),
              )
            : const CircularProgressIndicator(color: AppColors.primary),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _isLoadingEdit
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    )
                  : _ActionButton(
                      icon: Icons.edit_note_rounded,
                      label: 'Edit Again',
                      onTap: _editAgain,
                    ),
              _ActionButton(
                icon: Icons.share_rounded,
                label: 'Share',
                onTap: _shareVideo,
              ),
              _ActionButton(
                icon: Icons.delete_outline_rounded,
                label: 'Delete',
                color: Colors.redAccent,
                onTap: _deleteVideo,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
