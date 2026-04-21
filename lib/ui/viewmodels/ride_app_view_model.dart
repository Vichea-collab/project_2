import 'package:flutter/foundation.dart';

import '../../data/repositories/bike/bike_repository.dart';
import '../../data/repositories/pass/pass_repository.dart';
import '../../data/repositories/station/station_repository.dart';
import '../../data/repositories/user/user_repository.dart';
import '../../models/app_user.dart';
import '../../models/bike_station.dart';
import '../state/ride_app_state.dart';
import '../utils/async_value.dart';

class RideAppViewModel extends ChangeNotifier {
  RideAppViewModel({
    required BikeRepository bikeRepository,
    required PassRepository passRepository,
    required StationRepository stationRepository,
    required UserRepository userRepository,
  }) : _bikeRepository = bikeRepository,
       _passRepository = passRepository,
       _stationRepository = stationRepository,
       _userRepository = userRepository;

  final BikeRepository _bikeRepository;
  final PassRepository _passRepository;
  final StationRepository _stationRepository;
  final UserRepository _userRepository;
  RideAppState _state = const RideAppState();

  RideAppState get state => _state;

  Future<void> initialize() async {
    try {
      _setState(_state.copyWith(status: const AsyncValue.loading()));

      final loadedPassTypes = await _passRepository.fetchPassTypes();
      final loadedStations = await _stationRepository.fetchStations();
      var currentUser = await _userRepository.fetchCurrentUser();

      if (currentUser.activePass != null &&
          !currentUser.activePass!.expirationDate.isAfter(DateTime.now())) {
        currentUser = currentUser.copyWith(activePass: null);
        await _userRepository.saveCurrentUser(currentUser);
      }

      _setState(
        _state.copyWith(
          passTypes: loadedPassTypes,
          stations: loadedStations,
          currentUser: currentUser,
          selectedStation: null,
          status: const AsyncValue.success(null),
        ),
      );
    } catch (_) {
      _setState(
        _state.copyWith(
          status: const AsyncValue.error('Unable to load ride data.'),
        ),
      );
    }
  }

  void changeTab(int index) {
    _setState(_state.copyWith(currentTabIndex: index));
  }

  void selectStation(String stationId) {
    final match = _state.stations.where((s) => s.id == stationId);
    if (match.isEmpty) return;
    _setState(_state.copyWith(selectedStation: match.first));
  }

  void clearSelectedStation() {
    _setState(_state.copyWith(selectedStation: null));
  }

  void replaceCurrentUser(AppUser? user, {AsyncValue<void>? status}) {
    _setState(_state.copyWith(currentUser: user, status: status));
  }

  void setErrorMessage(String? errorMessage) {
    _setState(
      _state.copyWith(
        status: errorMessage == null
            ? const AsyncValue.success(null)
            : AsyncValue.error(errorMessage),
      ),
    );
  }

  Future<void> saveUser(AppUser user) async {
    await _userRepository.saveCurrentUser(user);
    replaceCurrentUser(user, status: const AsyncValue.success(null));
  }

  Future<void> bookBike({
    required String stationId,
    required String slotId,
    required AppUser updatedUser,
  }) async {
    await _bikeRepository.bookBike(stationId: stationId, slotId: slotId);
    await _userRepository.saveCurrentUser(updatedUser);
    final refreshedStations = await _stationRepository.fetchStations();
    applyStations(refreshedStations, updatedUser: updatedUser);
  }

  void applyStations(
    List<BikeStation> updatedStations, {
    AppUser? updatedUser,
  }) {
    final nextSelectedStation = _resolveSelectedStation(updatedStations);
    _setState(
      _state.copyWith(
        stations: updatedStations,
        currentUser: updatedUser ?? _state.currentUser,
        selectedStation: nextSelectedStation,
        status: const AsyncValue.success(null),
      ),
    );
  }

  BikeStation? _resolveSelectedStation(List<BikeStation> updatedStations) {
    final selectedStationId = _state.selectedStation?.id;
    if (selectedStationId == null) return null;

    final match = updatedStations.where((s) => s.id == selectedStationId);
    if (match.isNotEmpty) return match.first;
    return updatedStations.isEmpty ? null : updatedStations.first;
  }

  void _setState(RideAppState nextState) {
    _state = nextState;
    notifyListeners();
  }
}
