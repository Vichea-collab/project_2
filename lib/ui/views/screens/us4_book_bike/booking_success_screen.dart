import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text(viewModel.successStepLabel)),
      body: BookingFlowBackground(
        child: BookingSuccessContent(
          viewModel: viewModel,
          onOpenHistory: () {
            viewModel.openHistoryTab();
            Navigator.of(context).pop(true);
          },
          onOpenStations: () {
            viewModel.openStationsTab();
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
  }
}
