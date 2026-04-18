import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:project_2/core/theme/app_theme.dart';
import 'package:project_2/data/repositories/mock_ride_repository.dart';
import 'package:project_2/ui/viewmodels/ride_app_view_model.dart';
import 'package:project_2/ui/views/screens/app_shell_screen.dart';

void main() {
  testWidgets('renders the station app shell', (tester) async {
    final repository = MockRideRepository();
    final viewModel = RideAppViewModel(repository: repository);

    await viewModel.initialize();

    await tester.pumpWidget(
      ChangeNotifierProvider<RideAppViewModel>.value(
        value: viewModel,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const AppShellScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Stations'), findsAtLeastNWidgets(1));
    expect(find.text('Search nearby stations'), findsOneWidget);
    expect(find.text('Passes'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('View bikes'), findsOneWidget);
  });
}
