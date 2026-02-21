/// Builds the EveryAyah CDN URL for a specific ayah's recitation.
///
/// Example: `getAudioUrl('Alafasy_128kbps', 1, 2)`
/// → `https://everyayah.com/data/Alafasy_128kbps/001002.mp3`
String getAudioUrl(String folder, int surah, int ayah) {
  final s = surah.toString().padLeft(3, '0');
  final a = ayah.toString().padLeft(3, '0');
  return 'https://everyayah.com/data/$folder/$s$a.mp3';
}
