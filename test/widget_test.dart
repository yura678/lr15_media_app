import 'package:flutter_test/flutter_test.dart';
import 'package:lr15_media_app/main.dart';

void main() {
  testWidgets('Галерея стартує з порожнім станом', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('My Gallery'), findsOneWidget);
  });
}
