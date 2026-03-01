import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hadith.dart';

// ═══════════════════════════════════════════════════════════════════════════
//  BOOK CATALOG
// ═══════════════════════════════════════════════════════════════════════════

/// All available hadith books.
const kHadithBooks = <HadithBook>[
  HadithBook(
    id: 'bukhari',
    name: 'Sahih al-Bukhari',
    arabicEdition: 'ara-bukhari',
    englishEdition: 'eng-bukhari',
    urduEdition: 'urd-bukhari',
    icon: IconLabel.star,
    estimatedHadithCount: 7563,
    coverAsset: 'assets/images/hadith/bukhari.png',
  ),
  HadithBook(
    id: 'muslim',
    name: 'Sahih Muslim',
    arabicEdition: 'ara-muslim',
    englishEdition: 'eng-muslim',
    urduEdition: 'urd-muslim',
    icon: IconLabel.star,
    estimatedHadithCount: 7563,
    coverAsset: 'assets/images/hadith/muslim.png',
  ),
  HadithBook(
    id: 'tirmidhi',
    name: "Jami' at-Tirmidhi",
    arabicEdition: 'ara-tirmidhi',
    englishEdition: 'eng-tirmidhi',
    urduEdition: 'urd-tirmidhi',
    estimatedHadithCount: 3956,
    coverAsset: 'assets/images/hadith/tirmidhi.png',
  ),
  HadithBook(
    id: 'abudawud',
    name: 'Sunan Abu Dawud',
    arabicEdition: 'ara-abudawud',
    englishEdition: 'eng-abudawud',
    urduEdition: 'urd-abudawud',
    estimatedHadithCount: 5274,
    coverAsset: 'assets/images/hadith/abudawud.png',
  ),
  HadithBook(
    id: 'nasai',
    name: "Sunan an-Nasa'i",
    arabicEdition: 'ara-nasai',
    englishEdition: 'eng-nasai',
    urduEdition: 'urd-nasai',
    estimatedHadithCount: 5758,
    coverAsset: 'assets/images/hadith/nasai.png',
  ),
  HadithBook(
    id: 'ibnmajah',
    name: 'Sunan Ibn Majah',
    arabicEdition: 'ara-ibnmajah',
    englishEdition: 'eng-ibnmajah',
    urduEdition: 'urd-ibnmajah',
    estimatedHadithCount: 4341,
    coverAsset: 'assets/images/hadith/ibnmajah.png',
  ),
  HadithBook(
    id: 'malik',
    name: 'Muwatta Malik',
    arabicEdition: 'ara-malik',
    englishEdition: 'eng-malik',
    urduEdition: 'urd-malik',
    estimatedHadithCount: 1594,
    coverAsset: 'assets/images/hadith/malik.png',
  ),
  HadithBook(
    id: 'nawawi',
    name: 'Forty Hadith an-Nawawi',
    arabicEdition: 'ara-nawawi',
    englishEdition: 'eng-nawawi',
    icon: IconLabel.scroll,
    estimatedHadithCount: 42,
    coverAsset: 'assets/images/hadith/nawawi.png',
  ),
  HadithBook(
    id: 'qudsi',
    name: 'Forty Hadith Qudsi',
    arabicEdition: 'ara-qudsi',
    englishEdition: 'eng-qudsi',
    icon: IconLabel.scroll,
    estimatedHadithCount: 40,
    coverAsset: 'assets/images/hadith/qudsi.png',
  ),
];

// ═══════════════════════════════════════════════════════════════════════════
//  SERVICE
// ═══════════════════════════════════════════════════════════════════════════

class HadithApiService {
  static const _base = 'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1';
  static const _prefKey = 'downloaded_hadiths';

  final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 120),
    ),
  );

  // ── In-memory caches ──
  final _sectionCache = <String, List<HadithSection>>{};
  final _hadithCache = <String, List<Hadith>>{};

  /// Safely convert a JSON number (int or double) to int.
  static int _toInt(dynamic v, [int fallback = 0]) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  DOWNLOAD STATE
  // ══════════════════════════════════════════════════════════════════════════

  /// Get list of downloaded book IDs with their info.
  Future<Map<String, DownloadedBookInfo>> getDownloadedBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefKey);
    if (raw == null) return {};

    final map = <String, DownloadedBookInfo>{};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    for (final entry in decoded.entries) {
      map[entry.key] = DownloadedBookInfo.fromJson(
        entry.value as Map<String, dynamic>,
      );
    }
    return map;
  }

  /// Check if a specific book is downloaded.
  Future<bool> isBookDownloaded(String bookId) async {
    final books = await getDownloadedBooks();
    return books.containsKey(bookId);
  }

  /// Get the languages a book was downloaded in.
  Future<List<String>> getBookLanguages(String bookId) async {
    final books = await getDownloadedBooks();
    return books[bookId]?.languages ?? [];
  }

  Future<void> _saveDownloadInfo(DownloadedBookInfo info) async {
    final prefs = await SharedPreferences.getInstance();
    final books = await getDownloadedBooks();
    books[info.bookId] = info;
    final encoded = books.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_prefKey, jsonEncode(encoded));
  }

  Future<void> _removeDownloadInfo(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final books = await getDownloadedBooks();
    books.remove(bookId);
    final encoded = books.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_prefKey, jsonEncode(encoded));
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  LOCAL FILE PATH
  // ══════════════════════════════════════════════════════════════════════════

  Future<Directory> get _hadithDir async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/hadith');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  Future<File> _bookFile(String bookId, String language) async {
    final dir = await _hadithDir;
    return File('${dir.path}/${bookId}_${language.toLowerCase()}.json');
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  DOWNLOAD BOOK
  // ══════════════════════════════════════════════════════════════════════════

  /// Downloads Arabic + translation edition, merges them, and saves locally.
  ///
  /// [onProgress] reports 0.0 → 1.0 progress.
  /// Returns the number of hadiths downloaded.
  Future<int> downloadBook(
    HadithBook book,
    String language, {
    void Function(double progress, String status)? onProgress,
  }) async {
    onProgress?.call(0.0, 'Downloading Arabic text...');

    // 1. Download Arabic edition
    final arData = await _fetchRaw(
      'editions/${book.arabicEdition}',
      onProgress: (p) => onProgress?.call(p * 0.4, 'Downloading Arabic...'),
    );

    onProgress?.call(0.4, 'Downloading $language translation...');

    // 2. Download translation edition
    final trEdition = book.editionForLanguage(language);
    final trData = await _fetchRaw(
      'editions/$trEdition',
      onProgress: (p) =>
          onProgress?.call(0.4 + p * 0.4, 'Downloading $language...'),
    );

    onProgress?.call(0.8, 'Processing hadiths...');

    // 3. Parse & merge
    final metadata = trData['metadata'] as Map<String, dynamic>? ?? {};
    final bookName = (metadata['name'] as String?) ?? book.name;

    // Extract section info
    final sectionsMap = <String, String>{};
    final sData = metadata['sections'] ?? metadata['section'];
    if (sData is Map) {
      sData.forEach((k, v) => sectionsMap[k.toString()] = v.toString());
    }
    final sDetailMap = <String, Map<String, dynamic>>{};
    final sdData = metadata['section_details'] ?? metadata['section_detail'];
    if (sdData is Map) {
      sdData.forEach((k, v) {
        if (v is Map<String, dynamic>) {
          sDetailMap[k.toString()] = v;
        }
      });
    }

    // Build section lookup for hadith → section mapping
    final hadithToSection = <int, int>{};
    final hadithToSectionName = <int, String>{};
    for (final se in sDetailMap.entries) {
      final secNum = int.tryParse(se.key) ?? 0;
      final secName = sectionsMap[se.key] ?? '';
      final first = _toInt(se.value['hadithnumber_first']);
      final last = _toInt(se.value['hadithnumber_last']);
      for (int i = first; i <= last; i++) {
        hadithToSection[i] = secNum;
        hadithToSectionName[i] = secName;
      }
    }

    final arHadiths = arData['hadiths'] as List<dynamic>? ?? [];
    final trHadiths = trData['hadiths'] as List<dynamic>? ?? [];

    // Translation map by hadith number
    final trMap = <int, Map<String, dynamic>>{};
    for (final h in trHadiths) {
      final m = h as Map<String, dynamic>;
      trMap[_toInt(m['hadithnumber'])] = m;
    }

    final hadiths = <Hadith>[];
    for (int i = 0; i < arHadiths.length; i++) {
      final ar = arHadiths[i] as Map<String, dynamic>;
      final num = _toInt(ar['hadithnumber']);
      final tr = trMap[num];

      final ref = ar['reference'] as Map<String, dynamic>?;
      final grades = <HadithGradeEntry>[];
      final gl = (tr?['grades'] ?? ar['grades']) as List<dynamic>? ?? [];
      for (final g in gl) {
        if (g is Map<String, dynamic>) {
          grades.add(HadithGradeEntry.fromApiJson(g));
        }
      }

      hadiths.add(
        Hadith(
          hadithNumber: num,
          arabicNumber: ar['arabicnumber'] != null
              ? _toInt(ar['arabicnumber'])
              : null,
          arabicText: ar['text']?.toString() ?? '',
          translationText: tr?['text']?.toString() ?? '',
          translationLang: language,
          bookName: bookName,
          bookId: book.id,
          bookRef: _toInt(ref?['book']),
          hadithRef: ref != null ? _toInt(ref['hadith'], num) : num,
          grades: grades,
          sectionName: hadithToSectionName[num],
          sectionNumber: hadithToSection[num] ?? 0,
        ),
      );

      // Progress for processing phase
      if (i % 500 == 0) {
        onProgress?.call(
          0.8 + (i / arHadiths.length) * 0.15,
          'Processing ${i + 1}/${arHadiths.length}...',
        );
      }
    }

    onProgress?.call(0.95, 'Saving to device...');

    // 4. Save sections metadata + hadiths to local file
    final saveData = {
      'sections': sectionsMap,
      'section_details': sDetailMap,
      'hadiths': hadiths.map((h) => h.toJson()).toList(),
    };

    final file = await _bookFile(book.id, language);
    await file.writeAsString(jsonEncode(saveData));

    // 5. Save download info
    final existingBooks = await getDownloadedBooks();
    final existingInfo = existingBooks[book.id];
    final langs = existingInfo != null
        ? {...existingInfo.languages, language}.toList()
        : [language];

    await _saveDownloadInfo(
      DownloadedBookInfo(
        bookId: book.id,
        languages: langs,
        hadithCount: hadiths.length,
        downloadedAt: existingInfo?.downloadedAt ?? DateTime.now(),
      ),
    );

    // 6. Populate caches
    _populateCaches(book.id, language, sectionsMap, sDetailMap, hadiths);

    onProgress?.call(1.0, 'Complete!');
    dev.log(
      '[HadithAPI] Downloaded ${hadiths.length} hadiths for ${book.id} ($language)',
    );

    return hadiths.length;
  }

  /// Delete a downloaded book entirely, or a specific language.
  Future<void> deleteBook(String bookId, [String? language]) async {
    final info = (await getDownloadedBooks())[bookId];
    if (info == null) return;

    if (language != null) {
      final file = await _bookFile(bookId, language);
      if (await file.exists()) await file.delete();

      final newLangs = info.languages.where((l) => l != language).toList();
      if (newLangs.isEmpty) {
        await _removeDownloadInfo(bookId);
      } else {
        await _saveDownloadInfo(
          DownloadedBookInfo(
            bookId: bookId,
            languages: newLangs,
            hadithCount: info.hadithCount,
            downloadedAt: info.downloadedAt,
          ),
        );
      }
      _sectionCache.remove('${bookId}_$language');
      _hadithCache.removeWhere(
        (k, _) => k.startsWith('${bookId}_${language}_'),
      );
      dev.log('[HadithAPI] Deleted $bookId ($language)');
    } else {
      for (final l in info.languages) {
        final file = await _bookFile(bookId, l);
        if (await file.exists()) await file.delete();
      }
      await _removeDownloadInfo(bookId);
      _sectionCache.removeWhere((k, _) => k.startsWith('${bookId}_'));
      _hadithCache.removeWhere((k, _) => k.startsWith('${bookId}_'));
      dev.log('[HadithAPI] Deleted all languages for: $bookId');
    }
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  READ FROM LOCAL STORAGE
  // ══════════════════════════════════════════════════════════════════════════

  /// Load book data from local file + populate caches.
  Future<bool> _ensureLoaded(String bookId, String language) async {
    final key = '${bookId}_$language';
    if (_sectionCache.containsKey(key)) return true;

    final file = await _bookFile(bookId, language);
    if (!await file.exists()) return false;

    try {
      final raw = await file.readAsString();
      final data = jsonDecode(raw) as Map<String, dynamic>;

      final sectionsMap = <String, String>{};
      if (data['sections'] is Map) {
        (data['sections'] as Map).forEach(
          (k, v) => sectionsMap[k.toString()] = v.toString(),
        );
      }

      final sDetailMap = <String, Map<String, dynamic>>{};
      if (data['section_details'] is Map) {
        (data['section_details'] as Map).forEach((k, v) {
          if (v is Map<String, dynamic>) {
            sDetailMap[k.toString()] = v;
          }
        });
      }

      final hadiths = <Hadith>[];
      if (data['hadiths'] is List) {
        for (final h in data['hadiths'] as List) {
          if (h is Map<String, dynamic>) {
            hadiths.add(Hadith.fromJson(h));
          }
        }
      }

      _populateCaches(bookId, language, sectionsMap, sDetailMap, hadiths);
      return true;
    } catch (e) {
      dev.log('[HadithAPI] Error loading $bookId ($language) from disk: $e');
      return false;
    }
  }

  void _populateCaches(
    String bookId,
    String language,
    Map<String, String> sectionsMap,
    Map<String, Map<String, dynamic>> sDetailMap,
    List<Hadith> hadiths,
  ) {
    // Build section list
    final sections = <HadithSection>[];
    for (final entry in sectionsMap.entries) {
      final detail = sDetailMap[entry.key];
      sections.add(
        HadithSection(
          sectionNumber: int.tryParse(entry.key) ?? 0,
          sectionName: entry.value,
          hadithFirst: _toInt(detail?['hadithnumber_first']),
          hadithLast: _toInt(detail?['hadithnumber_last']),
        ),
      );
    }
    sections.sort((a, b) => a.sectionNumber.compareTo(b.sectionNumber));
    _sectionCache['${bookId}_$language'] = sections;

    // Group hadiths by section
    final bySection = <int, List<Hadith>>{};
    for (final h in hadiths) {
      bySection.putIfAbsent(h.sectionNumber, () => []).add(h);
    }
    for (final entry in bySection.entries) {
      _hadithCache['${bookId}_${language}_s${entry.key}'] = entry.value;
    }
    // Also cache all hadiths
    _hadithCache['${bookId}_${language}_all'] = hadiths;
  }

  /// Get sections for a downloaded book in a specific language.
  Future<List<HadithSection>> getSections(
    String bookId,
    String language,
  ) async {
    await _ensureLoaded(bookId, language);
    return _sectionCache['${bookId}_$language'] ?? [];
  }

  /// Get hadiths for a section in a specific language.
  Future<List<Hadith>> getSectionHadiths(
    String bookId,
    int sectionNo,
    String language,
  ) async {
    await _ensureLoaded(bookId, language);
    return _hadithCache['${bookId}_${language}_s$sectionNo'] ?? [];
  }

  /// Get all hadiths for a downloaded book in a specific language.
  Future<List<Hadith>> getAllHadiths(String bookId, String language) async {
    await _ensureLoaded(bookId, language);
    return _hadithCache['${bookId}_${language}_all'] ?? [];
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  SEARCH
  // ══════════════════════════════════════════════════════════════════════════

  /// Search across all downloaded books (or a specific one).
  Future<List<Hadith>> search(String query, {String? bookId}) async {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();

    final results = <Hadith>[];
    final downloaded = await getDownloadedBooks();

    final idsToSearch = bookId != null ? [bookId] : downloaded.keys.toList();

    for (final id in idsToSearch) {
      if (!downloaded.containsKey(id)) continue;
      final info = downloaded[id]!;
      for (final lang in info.languages) {
        final hadiths = await getAllHadiths(id, lang);
        for (final h in hadiths) {
          if (h.arabicText.contains(q) ||
              h.translationText.toLowerCase().contains(q) ||
              (h.sectionName?.toLowerCase().contains(q) ?? false)) {
            results.add(h);
            if (results.length >= 50) return results; // Cap results
          }
        }
      }
    }
    return results;
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  RAW API FETCH (with progress)
  // ══════════════════════════════════════════════════════════════════════════

  Future<Map<String, dynamic>> _fetchRaw(
    String endpoint, {
    void Function(double)? onProgress,
  }) async {
    // Try .min.json first (smaller)
    try {
      final url = '$_base/$endpoint.min.json';
      dev.log('[HadithAPI] GET $url');
      final r = await _dio.get<String>(
        url,
        options: Options(responseType: ResponseType.plain),
        onReceiveProgress: (received, total) {
          if (total > 0) onProgress?.call(received / total);
        },
      );
      return jsonDecode(r.data!) as Map<String, dynamic>;
    } catch (e) {
      dev.log('[HadithAPI] .min.json failed, trying .json: $e');
    }

    // Fallback
    final url = '$_base/$endpoint.json';
    dev.log('[HadithAPI] GET $url (fallback)');
    final r = await _dio.get<String>(
      url,
      options: Options(responseType: ResponseType.plain),
      onReceiveProgress: (received, total) {
        if (total > 0) onProgress?.call(received / total);
      },
    );
    return jsonDecode(r.data!) as Map<String, dynamic>;
  }
}

final hadithApiProvider = Provider((_) => HadithApiService());
