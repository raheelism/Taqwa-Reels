enum BackgroundType { image, video }

class BackgroundItem {
  final int id;
  final BackgroundType type;
  final String previewUrl;
  final String fullUrl; // High-res image or medium video
  final int duration; // Duration in seconds (for videos)
  String? localPath; // Set after download for export

  BackgroundItem({
    required this.id,
    required this.type,
    required this.previewUrl,
    required this.fullUrl,
    this.duration = 0,
    this.localPath,
  });
}
