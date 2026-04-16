import 'package:flutter/material.dart';

import 'view_model/booking_view_model.dart';
import 'widgets/booking_success_content.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key, required this.viewModel});

  final BookingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      appBar: AppBar(title: const Text('Booking Successful')),
      body: BookingSuccessContent(
        viewModel: viewModel,
        onOpenStations: () {
          viewModel.appViewModel.changeTab(0);
          Navigator.of(context).pop(true);
        },
        onOpenPasses: () {
          viewModel.appViewModel.changeTab(1);
          Navigator.of(context).pop(true);
        },
      ),
    );
  }
}
