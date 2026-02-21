/// A Quran reciter. The [folder] is the EveryAyah CDN subfolder name.
class Reciter {
  final String id;
  final String name;
  final String folder;    // EveryAyah CDN folder, e.g. 'Alafasy_128kbps'

  const Reciter({
    required this.id,
    required this.name,
    required this.folder,
  });
}
