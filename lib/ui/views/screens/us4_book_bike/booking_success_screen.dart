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
      appBar: AppBar(title: const Text('Step 3 of 3')),
      body: BookingFlowBackground(
        child: BookingSuccessContent(
          viewModel: viewModel,
          onOpenStations: () {
            viewModel.openStationsTab();
            Navigator.of(context).pop(true);
          },
          onOpenPasses: () {
            viewModel.openPassesTab();
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
  }
}
