import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/ride_repository.dart';
import 'ui/viewmodels/ride_app_view_model.dart';
import 'ui/views/screens/app_shell_screen.dart';

class RideRentalApp extends StatefulWidget {
  const RideRentalApp({super.key, required this.repository});

  final RideRepository repository;

  @override
  State<RideRentalApp> createState() => _RideRentalAppState();
}

class _RideRentalAppState extends State<RideRentalApp> {
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
