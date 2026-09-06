import 'package:flutter/material.dart';

import 'pages/app_shell.dart';
import 'state/app_scope.dart';
import 'state/app_store.dart';
import 'theme/rainbow_theme.dart';

class ProjectRainbowApp extends StatelessWidget {
  const ProjectRainbowApp({
    super.key,
    required this.store,
  });

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      store: store,
      child: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Project Rainbow',
            theme: RainbowTheme.light,
            darkTheme: RainbowTheme.dark,
            themeMode: store.themeMode,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
