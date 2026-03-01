import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/models/generated_video.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only the bare minimum before runApp — everything else inits during splash
  await Hive.initFlutter();
  Hive.registerAdapter(GeneratedVideoAdapter());

  runApp(const ProviderScope(child: TaqwaReelsApp()));
}
