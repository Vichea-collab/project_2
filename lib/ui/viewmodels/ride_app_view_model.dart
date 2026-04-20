import 'package:flutter/foundation.dart';

import '../../data/repositories/ride_repository.dart';
import '../../models/app_user.dart';
import '../../models/bike_station.dart';
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
    } catch (_) {
      _setState(
        _state.copyWith(
          errorMessage: 'Unable to load ride data.',
          isLoading: false,
        ),
      );
    }
  }

  void changeTab(int index) {
    _setState(_state.copyWith(currentTabIndex: index));
  }

  void selectStation(String stationId) {
    BikeStation? selectedStation;
    for (final station in _state.stations) {
      if (station.id == stationId) {
        selectedStation = station;
        break;
      }
    }

    if (selectedStation == null) {
      return;
    }

    _setState(
      _state.copyWith(
        selectedStation: selectedStation,
      ),
    );
  }

  void clearSelectedStation() {
    _setState(_state.copyWith(selectedStation: null));
  }

  void replaceCurrentUser(AppUser? user, {String? errorMessage}) {
    _setState(
      _state.copyWith(
        currentUser: user,
        errorMessage: errorMessage,
      ),
    );
  }

  void setErrorMessage(String? errorMessage) {
    _setState(_state.copyWith(errorMessage: errorMessage));
  }

  Future<void> saveUser(AppUser user) async {
    await _repository.saveCurrentUser(user);
    replaceCurrentUser(user, errorMessage: null);
  }

  Future<void> bookBike({
    required String stationId,
    required String slotId,
    required AppUser updatedUser,
  }) async {
    await _repository.bookBike(stationId: stationId, slotId: slotId);
    await _repository.saveCurrentUser(updatedUser);
    final refreshedStations = await _repository.fetchStations();
    applyStations(refreshedStations, updatedUser: updatedUser);
  }

  Future<List<BikeStation>> refreshStations() async {
    return _repository.fetchStations();
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
    notifyListeners();
  }
}
