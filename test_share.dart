import 'package:share_plus/share_plus.dart';

void main() {
  ShareParams params = ShareParams(text: 'text', files: [XFile('path')]);
  SharePlus.instance.share(params);
}
