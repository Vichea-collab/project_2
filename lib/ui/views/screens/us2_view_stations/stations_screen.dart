import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/bike_slot.dart';
import '../../../../../models/bike_station.dart';
import '../../../viewmodels/ride_app_view_model.dart';
import 'view_model/stations_view_model.dart';
import 'widgets/stations_content.dart';

class StationsScreen extends StatefulWidget {
  const StationsScreen({
    super.key,
    required this.onOpenBikes,
    required this.onBookBike,
  });

  final ValueChanged<BikeStation> onOpenBikes;
  final ValueChanged<BikeSlot> onBookBike;

  @override
  State<StationsScreen> createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  late final StationsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = StationsViewModel(
      appViewModel: context.read<RideAppViewModel>(),
    );
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
          onOpenBikes: widget.onOpenBikes,
          onBookBike: widget.onBookBike,
        );
      },
    );
  }
}
