import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/ride_repository.dart';
import 'ui/viewmodels/ride_app_view_model.dart';
import 'ui/views/screens/app_shell_screen.dart';

Future<void> mainCommon({
  required Future<RideRepository> Function() createRepository,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = await createRepository();
  runApp(_RideRentalApp(repository: repository));
}

class _RideRentalApp extends StatefulWidget {
  const _RideRentalApp({required this.repository});

  final RideRepository repository;

  @override
  State<_RideRentalApp> createState() => _RideRentalAppState();
}

class _RideRentalAppState extends State<_RideRentalApp> {
  late final RideAppViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = RideAppViewModel(repository: widget.repository);
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'RideFlow',
          theme: AppTheme.light(),
          home: AppShellScreen(viewModel: _viewModel),
        );
      },
    );
  }
}
