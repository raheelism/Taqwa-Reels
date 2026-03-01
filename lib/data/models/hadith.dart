/// Safely convert a JSON number (int or double) to int.
int _safeInt(dynamic v, [int fallback = 0]) {
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? fallback;
  return fallback;
}

int? _safeIntOrNull(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

/// Represents a hadith book collection (e.g. Bukhari, Muslim).
class HadithBook {
  final String id; // e.g. 'bukhari'
  final String name; // e.g. 'Sahih al Bukhari'
  final String arabicEdition; // e.g. 'ara-bukhari'
  final String englishEdition; // e.g. 'eng-bukhari'
  final String? urduEdition; // e.g. 'urd-bukhari'
  final IconLabel icon;
  final int estimatedHadithCount; // for display before download
  final String coverAsset; // path to cover image asset

  const HadithBook({
    required this.id,
    required this.name,
    required this.arabicEdition,
    required this.englishEdition,
    this.urduEdition,
    this.icon = IconLabel.book,
    this.estimatedHadithCount = 0,
    this.coverAsset = '',
  });

  /// Languages available for this book.
  List<String> get availableLanguages => [
    'English',
    if (urduEdition != null) 'Urdu',
  ];

  /// Gets the edition name for a language.
  String editionForLanguage(String language) {
    if (language == 'Urdu' && urduEdition != null) return urduEdition!;
    return englishEdition;
  }
}

/// Simple icon identifier for books.
enum IconLabel { book, star, scroll }

/// Section (chapter) within a hadith book.
class HadithSection {
  final int sectionNumber;
  final String sectionName;
  final int hadithFirst;
  final int hadithLast;

  const HadithSection({
    required this.sectionNumber,
    required this.sectionName,
    required this.hadithFirst,
    required this.hadithLast,
  });

  int get hadithCount => hadithLast - hadithFirst + 1;
}

/// A single hadith with Arabic + translation text.
class Hadith {
  final int hadithNumber;
  final int? arabicNumber;
  final String arabicText;
  final String translationText; // English or Urdu depending on user choice
  final String translationLang; // 'English' or 'Urdu'
  final String bookName;
  final String bookId;
  final int bookRef;
  final int hadithRef;
  final List<HadithGradeEntry> grades;
  final String? sectionName;
  final int sectionNumber;

  const Hadith({
    required this.hadithNumber,
    this.arabicNumber,
    required this.arabicText,
    required this.translationText,
    this.translationLang = 'English',
    required this.bookName,
    required this.bookId,
    required this.bookRef,
    required this.hadithRef,
    this.grades = const [],
    this.sectionName,
    this.sectionNumber = 0,
  });

  /// Reference string e.g. "Sahih al Bukhari 1:1"
  String get reference => '$bookName $bookRef:$hadithRef';

  /// Convert to JSON for local storage.
  Map<String, dynamic> toJson() => {
    'hn': hadithNumber,
    'an': arabicNumber,
    'ar': arabicText,
    'tr': translationText,
    'tl': translationLang,
    'bn': bookName,
    'bi': bookId,
    'br': bookRef,
    'hr': hadithRef,
    'g': grades.map((g) => {'n': g.name, 'g': g.grade}).toList(),
    'sn': sectionName,
    'sec': sectionNumber,
  };

  /// Create from stored JSON.
  factory Hadith.fromJson(Map<String, dynamic> j) {
    final grades = <HadithGradeEntry>[];
    if (j['g'] is List) {
      for (final g in j['g'] as List) {
        if (g is Map<String, dynamic>) {
          grades.add(
            HadithGradeEntry(
              name: g['n']?.toString() ?? '',
              grade: g['g']?.toString() ?? '',
            ),
          );
        }
      }
    }
    return Hadith(
      hadithNumber: _safeInt(j['hn']),
      arabicNumber: _safeIntOrNull(j['an']),
      arabicText: j['ar']?.toString() ?? '',
      translationText: j['tr']?.toString() ?? '',
      translationLang: j['tl']?.toString() ?? 'English',
      bookName: j['bn']?.toString() ?? '',
      bookId: j['bi']?.toString() ?? '',
      bookRef: _safeInt(j['br']),
      hadithRef: _safeInt(j['hr']),
      grades: grades,
      sectionName: j['sn']?.toString(),
      sectionNumber: _safeInt(j['sec']),
    );
  }
}

/// Grade entry from the API (name + grade).
class HadithGradeEntry {
  final String name;
  final String grade;

  const HadithGradeEntry({required this.name, required this.grade});

  factory HadithGradeEntry.fromApiJson(Map<String, dynamic> json) {
    return HadithGradeEntry(
      name: json['name']?.toString() ?? '',
      grade: json['grade']?.toString() ?? '',
    );
  }
}

/// Tracks download state of a book.
class DownloadedBookInfo {
  final String bookId;
  final List<String> languages;
  final int hadithCount;
  final DateTime downloadedAt;

  const DownloadedBookInfo({
    required this.bookId,
    required this.languages,
    required this.hadithCount,
    required this.downloadedAt,
  });

  Map<String, dynamic> toJson() => {
    'bookId': bookId,
    'languages': languages,
    'hadithCount': hadithCount,
    'downloadedAt': downloadedAt.toIso8601String(),
  };

  factory DownloadedBookInfo.fromJson(Map<String, dynamic> j) {
    List<String> langs = [];
    if (j['languages'] is List) {
      langs = (j['languages'] as List).map((e) => e.toString()).toList();
    } else if (j['language'] is String) {
      langs = [j['language'].toString()];
    }
    if (langs.isEmpty) langs = ['English'];

    return DownloadedBookInfo(
      bookId: j['bookId']?.toString() ?? '',
      languages: langs,
      hadithCount: _safeInt(j['hadithCount']),
      downloadedAt:
          DateTime.tryParse(j['downloadedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
