import 'package:flutter/foundation.dart';

import '../../../../../models/app_user.dart';
import '../../../../../models/bike_slot.dart';
import '../../../../../models/booking_history_item.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../../utils/async_value.dart';
import '../../../../viewmodels/ride_app_view_model.dart';

class BookingViewModel extends ChangeNotifier {
  BookingViewModel({required RideAppViewModel appViewModel, required this.slot})
    : _appViewModel = appViewModel {
    _appViewModel.addListener(_handleAppStateChanged);
  }

  final RideAppViewModel _appViewModel;
  final BikeSlot slot;
  AsyncValue<void> _state = const AsyncValue.success(null);

  AsyncValue<void> get state => _state;
  bool get isBusy => _state.isLoading;
  String? get actionError => _state.errorMessage;

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
      return '${pass.type.title} active until ${formatDateLong(pass.expirationDate)}.';
    }
    if (hasSingleTicket) {
      return 'Your \$2.00 ticket is ready for this booking.';
    }
    return 'Buy one single ticket or choose a pass before confirming this bike.';
  }

  void clearActionError() {
    if (!_state.hasError) {
      return;
    }
    _setState(const AsyncValue.success(null));
  }

  Future<bool> purchaseSingleTicket() async {
    final currentUser = _appViewModel.state.currentUser;
    if (currentUser == null) {
      return false;
    }

    _setState(const AsyncValue.loading());

    try {
      final updatedUser = currentUser.copyWith(hasSingleTicket: true);
      await _appViewModel.saveUser(updatedUser);
      _setState(const AsyncValue.success(null));
      return true;
    } catch (_) {
      const message = 'Unable to continue this booking.';
      _appViewModel.setErrorMessage(message);
      _setState(AsyncValue.error(message));
      return false;
    }
  }

  Future<bool> confirmBooking() async {
    final station = _appViewModel.state.selectedStation;
    final currentUser = _appViewModel.state.currentUser;
    if (station == null || currentUser == null || !canConfirm) {
      return false;
    }

    _setState(const AsyncValue.loading());

    try {
      _appViewModel.setErrorMessage(null);
      final updatedUser = _updatedUserAfterBooking(currentUser, station.name);
      await _appViewModel.bookBike(
        stationId: station.id,
        slotId: slot.id,
        updatedUser: updatedUser,
      );
      _setState(const AsyncValue.success(null));
      return true;
    } catch (_) {
      const message = 'Unable to confirm the booking.';
      _appViewModel.setErrorMessage(message);
      _setState(AsyncValue.error(message));
      return false;
    }
  }

  AppUser _updatedUserAfterBooking(AppUser currentUser, String stationName) {
    final booking = BookingHistoryItem(
      stationName: stationName,
      slotLabel: slot.label,
      bookedAt: DateTime.now(),
    );

    return currentUser.copyWith(
      hasSingleTicket: hasActivePass ? currentUser.hasSingleTicket : false,
      bookingHistory: [booking, ...currentUser.bookingHistory],
    );
  }

  void _setState(AsyncValue<void> nextState) {
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
