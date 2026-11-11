import 'package:fleetzen/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dispatch opens the sample route', (tester) async {
    await tester.pumpWidget(const FleetZenApp());
    await tester.tap(find.text('Open dispatch'));
    await tester.pumpAndSettle();
    expect(find.text('Load van-12 sample'), findsOneWidget);
  });
}
