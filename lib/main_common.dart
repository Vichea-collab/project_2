import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/ride_repository_factory.dart';
import 'ui/theme/app_theme.dart';
import 'ui/viewmodels/ride_app_view_model.dart';
import 'ui/views/screens/app_shell_screen.dart';

Future<void> mainCommon({
  required Future<RideRepositories> Function() createRepositories,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final repositories = await createRepositories();
  runApp(RideRentalApp(repositories: repositories));
}

class RideRentalApp extends StatelessWidget {
  const RideRentalApp({super.key, required this.repositories});

  final RideRepositories repositories;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RideAppViewModel>(
      create: (_) {
        final viewModel = RideAppViewModel(
          bikeRepository: repositories.bikeRepository,
          passRepository: repositories.passRepository,
          stationRepository: repositories.stationRepository,
          userRepository: repositories.userRepository,
        );
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
