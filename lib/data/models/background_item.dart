enum BackgroundType { image, video, solidColor }

class BackgroundItem {
  final int id;
  final BackgroundType type;
  final String previewUrl;
  final String fullUrl; // High-res image or medium video
  final int duration; // Duration in seconds (for videos)
  String? localPath; // Set after download for export
  final String? solidColorHex; // e.g. '#1A2040' — only for solidColor type

  BackgroundItem({
    required this.id,
    required this.type,
    required this.previewUrl,
    required this.fullUrl,
    this.duration = 0,
    this.localPath,
    this.solidColorHex,
  });

  /// Create a solid-color background item.
  factory BackgroundItem.solidColor(String hex) => BackgroundItem(
    id: hex.hashCode,
    type: BackgroundType.solidColor,
    previewUrl: '',
    fullUrl: '',
    solidColorHex: hex,
  );
}
