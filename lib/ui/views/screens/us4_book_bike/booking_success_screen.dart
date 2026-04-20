import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../viewmodels/ride_app_view_model.dart';
import 'view_model/booking_view_model.dart';
import 'widgets/booking_flow_shared.dart';
import 'widgets/booking_success_content.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key, required this.viewModel});

  final BookingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(viewModel.hasActivePass ? 'Step 2 of 2' : 'Step 3 of 3'),
      ),
      body: BookingFlowBackground(
        child: BookingSuccessContent(
          viewModel: viewModel,
          onOpenHistory: () {
            context.read<RideAppViewModel>().changeTab(2);
            Navigator.of(context).pop(true);
          },
          onOpenStations: () {
            context.read<RideAppViewModel>().changeTab(0);
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
  }
}
