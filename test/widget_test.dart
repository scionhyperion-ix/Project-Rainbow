import 'package:flutter_test/flutter_test.dart';
import 'package:project_rainbow/app.dart';
import 'package:project_rainbow/state/app_store.dart';

void main() {
  testWidgets(
    'Project Rainbow renders the home screen',
    (tester) async {
      await tester.pumpWidget(
        ProjectRainbowApp(
          store: AppStore.seeded(),
        ),
      );

      expect(
        find.text('Home'),
        findsOneWidget,
      );
      expect(
        find.text('Quick front'),
        findsOneWidget,
      );
      expect(
        find.text('Members'),
        findsWidgets,
      );
      expect(
        find.text('Journal'),
        findsWidgets,
      );
      expect(
        find.text('Settings'),
        findsWidgets,
      );
    },
  );
}
