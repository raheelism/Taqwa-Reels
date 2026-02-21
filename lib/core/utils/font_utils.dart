import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Copies a font asset from the bundle to the device filesystem.
/// FFmpeg's `drawtext` filter requires a local file path — it cannot
/// read Flutter assets directly.
Future<String> getFontPath(String fontFileName) async {
  final dir = await getApplicationSupportDirectory();
  final fontFile = File('${dir.path}/fonts/$fontFileName');
  if (!await fontFile.exists()) {
    await fontFile.parent.create(recursive: true);
    final bytes = await rootBundle.load('assets/fonts/$fontFileName');
    await fontFile.writeAsBytes(bytes.buffer.asUint8List());
  }
  return fontFile.path;
}
