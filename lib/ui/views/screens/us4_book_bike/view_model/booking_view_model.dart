import 'package:flutter/foundation.dart';

import '../../../../../models/bike_slot.dart';
import '../state/booking_state.dart';
import '../../../../viewmodels/ride_app_view_model.dart';

class BookingViewModel extends ChangeNotifier {
  BookingViewModel({required RideAppViewModel appViewModel, required this.slot})
    : _appViewModel = appViewModel {
    _appViewModel.addListener(_handleAppStateChanged);
  }

  final RideAppViewModel _appViewModel;
  final BikeSlot slot;
  BookingState _state = const BookingState();

  RideAppViewModel get appViewModel => _appViewModel;
  BookingState get state => _state;

  String get bikeLabel => 'Selected bike';

  String get stationName => _appViewModel.state.selectedStation?.name ?? '-';
  String get slotLabel => slot.label;
  bool get hasActivePass => _appViewModel.state.hasActivePass;
  bool get hasSingleTicket => _appViewModel.state.hasSingleTicket;
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
      final pass = _appViewModel.state.activePass;
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
    if (_state.actionError == null) {
      return;
    }
    _setState(_state.copyWith(actionError: null));
  }

  Future<bool> purchaseSingleTicket() async {
    _setState(_state.copyWith(actionError: null, isPurchasingTicket: true));

    final purchased = await _appViewModel.purchaseSingleTicket();

    _setState(
      _state.copyWith(
        isPurchasingTicket: false,
        actionError: purchased
            ? null
            : (_appViewModel.state.errorMessage ??
                  'Unable to purchase the ticket.'),
      ),
    );
    return purchased;
  }

  Future<bool> confirmBooking() async {
    _setState(_state.copyWith(actionError: null, isConfirming: true));

    final booked = await _appViewModel.confirmBooking(slot);

    _setState(
      _state.copyWith(
        isConfirming: false,
        actionError: booked
            ? null
            : (_appViewModel.state.errorMessage ??
                  'Unable to confirm the booking.'),
      ),
    );
    return booked;
  }

  void _setState(BookingState nextState) {
    _state = nextState;
    notifyListeners();
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
