import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/background_item.dart';

/// A grid tile showing a background image/video thumbnail with selection state.
class BackgroundGridItem extends StatefulWidget {
  final BackgroundItem item;
  final bool isSelected;
  final bool isVideo;
  final VoidCallback onTap;

  const BackgroundGridItem({
    super.key,
    required this.item,
    required this.isSelected,
    this.isVideo = false,
    required this.onTap,
  });

  @override
  State<BackgroundGridItem> createState() => _BackgroundGridItemState();
}

class _BackgroundGridItemState extends State<BackgroundGridItem> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _checkVideoState();
  }

  @override
  void didUpdateWidget(covariant BackgroundGridItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      _checkVideoState();
    }
  }

  void _checkVideoState() {
    if (widget.isVideo && widget.isSelected) {
      if (_controller == null) {
        _controller =
            VideoPlayerController.networkUrl(Uri.parse(widget.item.fullUrl))
              ..initialize().then((_) {
                _controller!.setLooping(true);
                _controller!.setVolume(0); // Mute preview
                if (mounted) {
                  setState(() => _isPlaying = true);
                  _controller!.play();
                }
              });
      } else {
        _controller!.play();
        setState(() => _isPlaying = true);
      }
    } else {
      if (_controller != null && _controller!.value.isInitialized) {
        _controller!.pause();
        setState(() => _isPlaying = false);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: widget.isSelected ? AppColors.primary : Colors.transparent,
            width: widget.isSelected ? 2.5 : 0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            widget.isSelected ? AppSpacing.radiusMd - 1 : AppSpacing.radiusMd,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: widget.item.previewUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.bgCard,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.bgCard,
                  child: const Icon(
                    Icons.broken_image,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              if (_isPlaying &&
                  _controller != null &&
                  _controller!.value.isInitialized)
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller!),
                    ),
                  ),
                ),
              if (widget.isVideo)
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.videocam_rounded,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          _formatDuration(widget.item.duration),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (widget.isSelected)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.bg,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
