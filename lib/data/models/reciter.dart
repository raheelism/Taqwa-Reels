/// A Quran reciter. The [folder] is the EveryAyah CDN subfolder name.
class Reciter {
  final String id;
  final String name;
  final String folder; // EveryAyah CDN folder, e.g. 'Alafasy_128kbps'

  const Reciter({required this.id, required this.name, required this.folder});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'folder': folder};

  factory Reciter.fromJson(Map<String, dynamic> json) {
    return Reciter(
      id: json['id'] as String,
      name: json['name'] as String,
      folder: json['folder'] as String,
    );
  }
}
