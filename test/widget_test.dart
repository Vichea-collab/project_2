import 'package:flutter_test/flutter_test.dart';
import 'package:project_2/app.dart';

void main() {
  testWidgets('renders ride management app shell', (tester) async {
    await tester.pumpWidget(const RideRentalApp());
    await tester.pumpAndSettle();

    expect(find.text('Stations'), findsAtLeastNWidgets(1));
    expect(find.text('Search nearby stations'), findsOneWidget);
    expect(find.text('Passes'), findsOneWidget);
    expect(find.text('Account'), findsOneWidget);
  });
}
