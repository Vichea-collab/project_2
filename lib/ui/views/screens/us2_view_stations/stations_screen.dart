import 'package:flutter/material.dart';

import '../../../../models/bike_slot.dart';
import '../../../viewmodels/ride_app_view_model.dart';
import 'view_model/stations_view_model.dart';
import 'widgets/stations_content.dart';

class StationsScreen extends StatefulWidget {
  const StationsScreen({
    super.key,
    required this.viewModel,
    required this.onBookBike,
  });

  final RideAppViewModel viewModel;
  final ValueChanged<BikeSlot> onBookBike;

  @override
  State<StationsScreen> createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  late final StationsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = StationsViewModel(appViewModel: widget.viewModel);
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
        return StationsContent(
          viewModel: _viewModel,
          onBookBike: widget.onBookBike,
        );
      },
    );
  }
}
