import 'package:hive/hive.dart';

part 'generated_video.g.dart';

@HiveType(typeId: 0)
class GeneratedVideo extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String videoPath;

  @HiveField(2)
  final String thumbnailPath;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final String metadataJson; // Stores JSON representation of Ayah, Reciter, and ExportOptions

  GeneratedVideo({
    required this.id,
    required this.videoPath,
    required this.thumbnailPath,
    required this.createdAt,
    required this.metadataJson,
  });
}
