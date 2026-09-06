import 'package:flutter/material.dart';

import 'app.dart';
import 'state/app_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final store = AppStore.seeded();
  runApp(ProjectRainbowApp(store: store));
}
