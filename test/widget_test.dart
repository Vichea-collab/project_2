import 'package:flutter_test/flutter_test.dart';
import 'package:project_2/app.dart';
import 'package:project_2/data/local/shared_prefs_ride_local_storage.dart';
import 'package:project_2/data/repositories/mock_ride_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('renders ride management app shell', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final repository = MockRideRepository(
      localStorage: SharedPrefsRideLocalStorage(preferences: preferences),
    );

    await tester.pumpWidget(RideRentalApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Stations'), findsAtLeastNWidgets(1));
    expect(find.text('Search nearby stations'), findsOneWidget);
    expect(find.text('Passes'), findsOneWidget);
    expect(find.text('Account'), findsNothing);
    expect(find.text('History'), findsNothing);
  });
}
