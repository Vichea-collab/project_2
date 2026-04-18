import 'package:flutter/foundation.dart';

import '../../data/repositories/ride_repository.dart';
import '../../models/app_user.dart';
import '../../models/bike_station.dart';
import '../../models/bike_slot.dart';
import '../../models/current_booking.dart';
import '../../models/pass_type.dart';
import '../../models/ride_pass.dart';
import '../state/ride_app_state.dart';

class RideAppViewModel extends ChangeNotifier {
  RideAppViewModel({required RideRepository repository})
    : _repository = repository;

  final RideRepository _repository;
  RideAppState _state = const RideAppState();

  RideAppState get state => _state;

  Future<void> initialize() async {
    try {
      _setState(_state.copyWith(isLoading: true, errorMessage: null));
      notifyListeners();

      final loadedPassTypes = await _repository.fetchPassTypes();
      final loadedStations = await _repository.fetchStations();
      var currentUser = await _repository.fetchCurrentUser();

      if (currentUser.activePass != null &&
          !currentUser.activePass!.expirationDate.isAfter(DateTime.now())) {
        currentUser = currentUser.copyWith(activePass: null);
        await _repository.saveCurrentUser(currentUser);
      }

      _setState(
        _state.copyWith(
          passTypes: loadedPassTypes,
          stations: loadedStations,
          currentUser: currentUser,
          selectedStation: null,
          isLoading: false,
        ),
      );
      notifyListeners();
    } catch (_) {
      _setState(
        _state.copyWith(
          errorMessage: 'Unable to load ride data.',
          isLoading: false,
        ),
      );
      notifyListeners();
    }
  }

  void changeTab(int index) {
    _setState(_state.copyWith(currentTabIndex: index));
    notifyListeners();
  }

  Future<bool> activatePass(PassType type) async {
    final currentUser = _state.currentUser;
    if (currentUser == null) {
      return false;
    }

    try {
      final nextPass = RidePass(type: type, purchasedAt: DateTime.now());
      final updatedUser = currentUser.copyWith(
        activePass: nextPass,
        hasSingleTicket: false,
      );
      _setState(_state.copyWith(errorMessage: null, currentUser: updatedUser));
      await _repository.saveCurrentUser(updatedUser);
      notifyListeners();
      return true;
    } catch (_) {
      _setState(
        _state.copyWith(errorMessage: 'Unable to activate the selected pass.'),
      );
      notifyListeners();
      return false;
    }
  }

  Future<bool> cancelActivePass() async {
    final currentUser = _state.currentUser;
    if (currentUser == null) {
      return false;
    }

    try {
      final updatedUser = currentUser.copyWith(activePass: null);
      _setState(_state.copyWith(errorMessage: null, currentUser: updatedUser));
      await _repository.saveCurrentUser(updatedUser);
      notifyListeners();
      return true;
    } catch (_) {
      _setState(
        _state.copyWith(errorMessage: 'Unable to cancel the active pass.'),
      );
      notifyListeners();
      return false;
    }
  }

  Future<bool> purchaseSingleTicket() async {
    final currentUser = _state.currentUser;
    if (currentUser == null) {
      return false;
    }

    try {
      final updatedUser = currentUser.copyWith(hasSingleTicket: true);
      _setState(_state.copyWith(errorMessage: null, currentUser: updatedUser));
      await _repository.saveCurrentUser(updatedUser);
      notifyListeners();
      return true;
    } catch (_) {
      _setState(
        _state.copyWith(errorMessage: 'Unable to purchase a single ticket.'),
      );
      notifyListeners();
      return false;
    }
  }

  void selectStation(String stationId) {
    _setState(
      _state.copyWith(
        selectedStation: _state.stations.firstWhere(
          (station) => station.id == stationId,
        ),
      ),
    );
    notifyListeners();
  }

  void clearSelectedStation() {
    _setState(_state.copyWith(selectedStation: null));
    notifyListeners();
  }

  Future<bool> confirmBooking(BikeSlot slot) async {
    final station = _state.selectedStation;
    if (station == null) {
      return false;
    }

    if (!_state.hasActivePass && !_state.hasSingleTicket) {
      return false;
    }

    final currentUser = _state.currentUser;
    if (currentUser == null) {
      return false;
    }

    try {
      _setState(_state.copyWith(errorMessage: null));
      await _repository.bookBike(stationId: station.id, slotId: slot.id);
      final updatedUser = updatedUserAfterBooking(
        currentUser: currentUser,
        station: station,
        slot: slot,
      );
      await _repository.saveCurrentUser(updatedUser);
      final refreshedStations = await _repository.fetchStations();
      applyStations(refreshedStations, updatedUser: updatedUser);
      return true;
    } catch (_) {
      _setState(
        _state.copyWith(errorMessage: 'Unable to confirm the booking.'),
      );
      notifyListeners();
      return false;
    }
  }

  AppUser updatedUserAfterBooking({
    required AppUser currentUser,
    required BikeStation station,
    required BikeSlot slot,
  }) {
    final booking = CurrentBooking(
      stationName: station.name,
      slotLabel: slot.label,
      bookedAt: DateTime.now(),
    );

    return currentUser.copyWith(
      hasSingleTicket: _state.hasActivePass
          ? currentUser.hasSingleTicket
          : false,
      bookingHistory: [booking, ...currentUser.bookingHistory],
    );
  }

  void applyStations(
    List<BikeStation> updatedStations, {
    AppUser? updatedUser,
  }) {
    final nextSelectedStation = resolveSelectedStation(updatedStations);
    _setState(
      _state.copyWith(
        stations: updatedStations,
        currentUser: updatedUser ?? _state.currentUser,
        selectedStation: nextSelectedStation,
        isLoading: false,
      ),
    );
    notifyListeners();
  }

  BikeStation? resolveSelectedStation(List<BikeStation> updatedStations) {
    final selectedStationId = _state.selectedStation?.id;
    if (selectedStationId == null) {
      return null;
    }

    for (final station in updatedStations) {
      if (station.id == selectedStationId) {
        return station;
      }
    }

    return updatedStations.isEmpty ? null : updatedStations.first;
  }

  void _setState(RideAppState nextState) {
    _state = nextState;
  }
}
