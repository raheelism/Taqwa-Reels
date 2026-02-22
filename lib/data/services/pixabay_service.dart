import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/background_item.dart';

/// Replace with your own Pixabay API key.
const _kKey = '54668314-f82f212a8c835c5547884c861';

class PixabayService {
  final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://pixabay.com/api',
      connectTimeout: const Duration(seconds: 12),
    ),
  );
  final _imgCache = <String, List<BackgroundItem>>{};
  final _vidCache = <String, List<BackgroundItem>>{};

  Future<List<BackgroundItem>> searchImages(String q, {int page = 1}) async {
    final key = '${q}_$page';
    if (_imgCache[key] != null) return _imgCache[key]!;
    final r = await _dio.get(
      '/',
      queryParameters: {
        'key': _kKey,
        'q': q,
        'image_type': 'photo',
        'orientation': 'vertical',
        'per_page': 15,
        'page': page,
        'safesearch': 'true',
        'min_width': 720,
      },
    );
    final items = (r.data['hits'] as List)
        .map(
          (h) => BackgroundItem(
            id: h['id'] as int,
            type: BackgroundType.image,
            previewUrl: h['previewURL'] as String,
            fullUrl: h['largeImageURL'] as String,
          ),
        )
        .toList();
    _imgCache[key] = items;
    return items;
  }

  Future<List<BackgroundItem>> searchVideos(String q, {int page = 1}) async {
    final key = '${q}_$page';
    if (_vidCache[key] != null) return _vidCache[key]!;
    final r = await _dio.get(
      '/videos/',
      queryParameters: {
        'key': _kKey,
        'q': q,
        'per_page': 10,
        'page': page,
        'safesearch': 'true',
      },
    );
    final items = (r.data['hits'] as List).map((h) {
      final v = h['videos'] as Map<String, dynamic>;
      // Construct a thumbnail URL from the video's picture_id
      // Pixabay stores video thumbnails at this CDN pattern
      final pictureId = h['picture_id'] as String? ?? '';
      final thumbUrl = pictureId.isNotEmpty
          ? 'https://i.vimeocdn.com/video/${pictureId}_640x360.jpg'
          : (h['userImageURL'] as String? ?? '');
      return BackgroundItem(
        id: h['id'] as int,
        type: BackgroundType.video,
        previewUrl: thumbUrl,
        fullUrl: (v['medium'] as Map<String, dynamic>)['url'] as String,
      );
    }).toList();
    _vidCache[key] = items;
    return items;
  }
}

final pixabayProvider = Provider((_) => PixabayService());
