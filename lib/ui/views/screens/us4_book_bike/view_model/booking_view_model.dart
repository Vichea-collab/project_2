import 'package:flutter/foundation.dart';

import '../../../../../models/app_user.dart';
import '../../../../../models/bike_slot.dart';
import '../../../../../models/booking_history_item.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../../viewmodels/ride_app_view_model.dart';
import '../../../../utils/async_value.dart';
import '../state/booking_state.dart';

class BookingViewModel extends ChangeNotifier {
  BookingViewModel({required RideAppViewModel appViewModel, required this.slot})
    : _appViewModel = appViewModel {
    _appViewModel.addListener(_handleAppStateChanged);
  }

  final RideAppViewModel _appViewModel;
  final BikeSlot slot;
  BookingState _state = const BookingState();

  BookingState get state => _state;

  String get bikeLabel => 'Selected bike';

  String get stationName => _appViewModel.state.selectedStation?.name ?? '-';
  String get slotLabel => slot.label;
  bool get hasActivePass => _appViewModel.state.hasActivePass;
  bool get hasSingleTicket => _appViewModel.state.hasSingleTicket;
  bool get canConfirm => hasActivePass || hasSingleTicket;
  String get bookingStepLabel => hasActivePass ? 'Step 1 of 2' : 'Step 1 of 3';
  String get purchaseStepLabel => 'Step 2 of 3';
  String get successStepLabel => hasActivePass ? 'Step 2 of 2' : 'Step 3 of 3';

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
    if (_state.actionError == null) {
      return;
    }
    _setState(
      _state.copyWith(
        confirmValue: const AsyncValue.success(null),
        purchaseTicketValue: const AsyncValue.success(null),
      ),
    );
  }

  Future<bool> purchaseSingleTicket() async {
    final currentUser = _appViewModel.state.currentUser;
    if (currentUser == null) {
      return false;
    }

    _setState(
      _state.copyWith(
        confirmValue: const AsyncValue.success(null),
        purchaseTicketValue: const AsyncValue.loading(),
      ),
    );

    try {
      final updatedUser = currentUser.copyWith(hasSingleTicket: true);
      await _appViewModel.repository.saveCurrentUser(updatedUser);
      _appViewModel.replaceCurrentUser(updatedUser, errorMessage: null);
      _setState(
        _state.copyWith(
          purchaseTicketValue: const AsyncValue.success(null),
        ),
      );
      return true;
    } catch (_) {
      _appViewModel.setErrorMessage('Unable to purchase a single ticket.');
      _setState(
        _state.copyWith(
          purchaseTicketValue: AsyncValue.error(
            _appViewModel.state.errorMessage ??
                'Unable to purchase the ticket.',
          ),
        ),
      );
      return false;
    }
  }

  Future<bool> confirmBooking() async {
    final station = _appViewModel.state.selectedStation;
    final currentUser = _appViewModel.state.currentUser;
    if (station == null || currentUser == null || !canConfirm) {
      return false;
    }

    _setState(
      _state.copyWith(
        confirmValue: const AsyncValue.loading(),
        purchaseTicketValue: const AsyncValue.success(null),
      ),
    );

    try {
      _appViewModel.setErrorMessage(null);
      await _appViewModel.repository.bookBike(
        stationId: station.id,
        slotId: slot.id,
      );
      final updatedUser = _updatedUserAfterBooking(
        currentUser: currentUser,
        stationName: station.name,
      );
      await _appViewModel.repository.saveCurrentUser(updatedUser);
      final refreshedStations = await _appViewModel.repository.fetchStations();
      _appViewModel.applyStations(refreshedStations, updatedUser: updatedUser);
      _setState(
        _state.copyWith(confirmValue: const AsyncValue.success(null)),
      );
      return true;
    } catch (_) {
      _appViewModel.setErrorMessage('Unable to confirm the booking.');
      _setState(
        _state.copyWith(
          confirmValue: AsyncValue.error(
            _appViewModel.state.errorMessage ??
                'Unable to confirm the booking.',
          ),
        ),
      );
      return false;
    }
  }

  AppUser _updatedUserAfterBooking({
    required AppUser currentUser,
    required String stationName,
  }) {
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

  void openStationsTab() {
    _appViewModel.changeTab(0);
  }

  void openPassesTab() {
    _appViewModel.changeTab(1);
  }

  void openHistoryTab() {
    _appViewModel.changeTab(2);
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
