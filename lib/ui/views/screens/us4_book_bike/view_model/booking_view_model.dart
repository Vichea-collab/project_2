import 'package:flutter/foundation.dart';

import '../../../../../models/bike_slot.dart';
import '../../../../viewmodels/ride_app_view_model.dart';

class BookingViewModel extends ChangeNotifier {
  BookingViewModel({required RideAppViewModel appViewModel, required this.slot})
    : _appViewModel = appViewModel {
    _appViewModel.addListener(_handleAppStateChanged);
  }

  final RideAppViewModel _appViewModel;
  final BikeSlot slot;

  bool _isConfirming = false;
  bool _isPurchasingTicket = false;
  String? _actionError;

  RideAppViewModel get appViewModel => _appViewModel;
  bool get isBusy => _isConfirming || _isPurchasingTicket;
  bool get isConfirming => _isConfirming;
  bool get isPurchasingTicket => _isPurchasingTicket;
  String? get actionError => _actionError;

  String get bikeLabel => 'Bike #${slot.label}';

  String get stationName => _appViewModel.selectedStation?.name ?? '-';
  String get slotLabel => slot.label;
  bool get hasActivePass => _appViewModel.hasActivePass;
  bool get hasSingleTicket => _appViewModel.hasSingleTicket;
  bool get canConfirm => hasActivePass || hasSingleTicket;

  String get accessTitle {
    if (hasActivePass) {
      return 'Active pass';
    }
    if (hasSingleTicket) {
      return 'Single ticket ready';
    }
    return 'Choose access';
  }

  String get accessDescription {
    if (hasActivePass) {
      final pass = _appViewModel.activePass;
      if (pass == null) {
        return 'Ride access is active for this booking.';
      }
      return '${pass.type.title} active until ${_formatDate(pass.expirationDate)}.';
    }
    if (hasSingleTicket) {
      return 'Your \$2.00 ticket is ready for this booking.';
    }
    return 'Buy one single ticket or choose a pass before confirming this bike.';
  }

  void clearActionError() {
    if (_actionError == null) {
      return;
    }
    _actionError = null;
    notifyListeners();
  }

  Future<bool> purchaseSingleTicket() async {
    _actionError = null;
    _isPurchasingTicket = true;
    notifyListeners();

    final purchased = await _appViewModel.purchaseSingleTicket();

    _isPurchasingTicket = false;
    _actionError = purchased
        ? null
        : (_appViewModel.errorMessage ?? 'Unable to purchase the ticket.');
    notifyListeners();
    return purchased;
  }

  Future<bool> confirmBooking() async {
    _actionError = null;
    _isConfirming = true;
    notifyListeners();

    final booked = await _appViewModel.confirmBooking(slot);

    _isConfirming = false;
    _actionError = booked
        ? null
        : (_appViewModel.errorMessage ?? 'Unable to confirm the booking.');
    notifyListeners();
    return booked;
  }

  void _handleAppStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _appViewModel.removeListener(_handleAppStateChanged);
    super.dispose();
  }
}

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
