import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

/// Map of font family → known direct TTF URLs from Google Fonts.
/// These are stable gstatic CDN URLs that don't change.
const _kFontUrls = <String, String>{
  'Amiri': 'https://fonts.gstatic.com/s/amiri/v27/J7aRnpd8CGxBHpUrtLMA7w.ttf',
  'Scheherazade New':
      'https://fonts.gstatic.com/s/scheherazadenew/v16/4UaZrFhTvxVnHDvUkUiHg8qMBCursapBeg.ttf',
  'Noto Naskh Arabic':
      'https://fonts.gstatic.com/s/notonaskharabic/v35/RrQ5bpV-9Dd1b1OAGA6M9PkyDuVBPai-.ttf',
  'Cinzel':
      'https://fonts.gstatic.com/s/cinzel/v23/8vIU7ww63mVu7gtR-kwKxNvkNOjw-tbnfY3lCA.ttf',
  'Cormorant Garamond':
      'https://fonts.gstatic.com/s/cormorantgaramond/v16/co3bmX5slCNuHLi8bLeY9MK7whWMhyjQAllvuQWJ5heb_w.ttf',
};

final _dio = Dio();

/// Gets the local filesystem path for a Google Font's TTF file.
///
/// Downloads the font from gstatic CDN if not already cached locally.
/// This ensures the font is always available for FFmpeg's `drawtext` filter.
Future<String> getFontPath(String fontFamily) async {
  final tmpDir = await getTemporaryDirectory();
  final fontsDir = Directory('${tmpDir.path}/taqwareels_fonts');
  await fontsDir.create(recursive: true);

  final safeName = fontFamily.replaceAll(' ', '_').toLowerCase();
  final fontPath = '${fontsDir.path}/$safeName.ttf';
  final fontFile = File(fontPath);

  // Return cached font if already downloaded
  if (await fontFile.exists() && (await fontFile.length()) > 1000) {
    return fontPath;
  }

  // Download from known URL
  final url = _kFontUrls[fontFamily];
  if (url != null) {
    try {
      await _dio.download(url, fontPath);
      if (await fontFile.exists() && (await fontFile.length()) > 1000) {
        return fontPath;
      }
    } catch (_) {
      // Fall through to fallback
    }
  }

  // Fallback: try to fetch URL from Google Fonts CSS API
  try {
    final cssResp = await _dio.get(
      'https://fonts.googleapis.com/css2',
      queryParameters: {'family': fontFamily},
      options: Options(
        headers: {
          // Request TTF format (default user-agent gets woff2)
          'User-Agent': 'Mozilla/5.0',
        },
      ),
    );
    final css = cssResp.data as String;
    final urlMatch = RegExp(
      r"url\((https://fonts\.gstatic\.com/[^)]+\.ttf)\)",
    ).firstMatch(css);
    if (urlMatch != null) {
      await _dio.download(urlMatch.group(1)!, fontPath);
      if (await fontFile.exists() && (await fontFile.length()) > 1000) {
        return fontPath;
      }
    }
  } catch (_) {
    // Fall through to fallback
  }

  // Last resort: use Amiri as default Arabic font
  if (fontFamily != 'Amiri' && _kFontUrls.containsKey('Amiri')) {
    try {
      await _dio.download(_kFontUrls['Amiri']!, fontPath);
    } catch (_) {}
  }

  return fontPath;
}
