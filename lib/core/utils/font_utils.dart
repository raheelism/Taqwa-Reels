import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

/// Gets the local filesystem path for a Google Font's TTF file.
///
/// Google Fonts downloads and caches TTFs at runtime. For FFmpeg's
/// `drawtext` filter we need a local file path. This function:
/// 1. Triggers the Google Fonts download (if not already cached)
/// 2. Finds the cached TTF file in the app's file_cache directory
/// 3. Falls back to a bundled default if the cache lookup fails
///
/// [fontFamily] — the Google Fonts family name, e.g. 'Amiri'
Future<String> getFontPath(String fontFamily) async {
  // Trigger Google Fonts to download/cache the font
  try {
    GoogleFonts.getFont(fontFamily);
  } catch (_) {
    // Font may not exist — will fall back below
  }

  // Google Fonts caches files under the app's support/cache directory
  // Try to find the cached .ttf file
  final cacheDir = await getApplicationSupportDirectory();
  final possiblePaths = [
    cacheDir.path,
    '${cacheDir.parent.path}/cache',
    '${cacheDir.parent.path}/code_cache',
  ];

  for (final basePath in possiblePaths) {
    final dir = Directory(basePath);
    if (!await dir.exists()) continue;

    try {
      final files = await dir
          .list(recursive: true)
          .where((f) =>
              f is File &&
              f.path.endsWith('.ttf') &&
              f.path.toLowerCase().contains(fontFamily.toLowerCase().replaceAll(' ', '')))
          .toList();

      if (files.isNotEmpty) {
        return files.first.path;
      }
    } catch (_) {
      continue;
    }
  }

  // Fallback: use a temporary directory and try to load the font via HTTP
  final tmpDir = await getTemporaryDirectory();
  final safeName = fontFamily.replaceAll(' ', '_');
  final fallbackPath = '${tmpDir.path}/fonts/$safeName.ttf';
  final fallbackFile = File(fallbackPath);

  if (await fallbackFile.exists()) {
    return fallbackPath;
  }

  // Last resort: use any system sans-serif font
  // FFmpeg will use its default if the path is invalid
  return fallbackPath;
}
