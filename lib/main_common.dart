import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/ride_repository.dart';
import 'ui/viewmodels/ride_app_view_model.dart';
import 'ui/views/screens/app_shell_screen.dart';

Future<void> mainCommon({
  required Future<RideRepository> Function() createRepository,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = await createRepository();
  runApp(RideRentalApp(repository: repository));
}

class RideRentalApp extends StatelessWidget {
  const RideRentalApp({super.key, required this.repository});

  final RideRepository repository;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RideAppViewModel>(
      create: (_) {
        final viewModel = RideAppViewModel(repository: repository);
        viewModel.initialize();
        return viewModel;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RideFlow',
        theme: AppTheme.light(),
        home: const AppShellScreen(),
      ),
    );
  }
}
