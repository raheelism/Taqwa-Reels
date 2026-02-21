/// Parse a duration string from FFmpeg output.
///
/// FFmpeg prints duration in the format `HH:MM:SS.CC`, for example:
/// `Duration: 00:01:23.45` → returns `83.45` seconds.
double parseDuration(String ffmpegOutput) {
  final match = RegExp(r'Duration:\s*(\d+):(\d+):(\d+)\.(\d+)')
      .firstMatch(ffmpegOutput);
  if (match != null) {
    return int.parse(match.group(1)!) * 3600 +
        int.parse(match.group(2)!) * 60 +
        int.parse(match.group(3)!) +
        int.parse(match.group(4)!) / 100;
  }
  return 0.0;
}
