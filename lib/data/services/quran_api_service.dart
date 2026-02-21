import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/surah.dart';
import '../models/ayah.dart';

class QuranApiService {
  static const _base = 'https://api.alquran.cloud/v1';
  final _dio = Dio(BaseOptions(
    baseUrl: _base,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));
  List<Surah>? _cache;

  /// Fetch all 114 surahs (cached after first call).
  Future<List<Surah>> fetchSurahs() async {
    if (_cache != null) return _cache!;
    final r = await _dio.get('/surah');
    _cache = (r.data['data'] as List)
        .map((e) => Surah.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cache!;
  }

  /// Fetch a single ayah with Arabic + translation.
  Future<AyahWithTranslation> fetchAyah(
    int surah,
    int ayah,
    String edition,
  ) async {
    final ref = '$surah:$ayah';
    final results = await Future.wait([
      _dio.get('/ayah/$ref'),
      _dio.get('/ayah/$ref/$edition'),
    ]);
    final ar = results[0].data['data'];
    final tr = results[1].data['data'];
    return AyahWithTranslation(
      arabic: ar['text'] as String,
      translation: tr['text'] as String,
      surahNumber: ar['surah']['number'] as int,
      ayahNumber: ar['numberInSurah'] as int,
      surahName: ar['surah']['name'] as String,
      surahEnglishName: ar['surah']['englishName'] as String,
    );
  }

  /// Fetch a range of ayahs (inclusive).
  Future<List<AyahWithTranslation>> fetchRange(
    int surah,
    int from,
    int to,
    String edition,
  ) =>
      Future.wait([
        for (int i = from; i <= to; i++) fetchAyah(surah, i, edition),
      ]);
}

final quranApiProvider = Provider((_) => QuranApiService());
