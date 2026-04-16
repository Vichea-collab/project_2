import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/repositories/ride_repository.dart';
import '../../models/bike_station.dart';
import '../../models/bike_slot.dart';
import '../../models/pass_type.dart';
import '../../models/ride_pass.dart';
import '../state/ride_app_state.dart';

class RideAppViewModel extends ChangeNotifier {
  RideAppViewModel({required RideRepository repository})
    : _repository = repository;

  final RideRepository _repository;
  StreamSubscription<List<BikeStation>>? _stationsSubscription;
  RideAppState _state = const RideAppState();

  RideAppState get state => _state;
  bool get isLoading => _state.isLoading;
  String? get errorMessage => _state.errorMessage;
  int get currentTabIndex => _state.currentTabIndex;
  List<PassType> get passTypes => _state.passTypes;
  List<BikeStation> get stations => _state.stations;
  RidePass? get activePass => _state.activePass;
  bool get hasSingleTicket => _state.hasSingleTicket;
  BikeStation? get selectedStation => _state.selectedStation;

  int get totalAvailableBikes =>
      stations.fold(0, (total, station) => total + station.availableBikes);

  int get stationsWithBikes =>
      stations.where((station) => station.availableBikes > 0).length;

  BikeStation? get highlightedStation {
    if (selectedStation != null) {
      return selectedStation;
    }
    if (stations.isEmpty) {
      return null;
    }
    return stations.reduce(
      (best, current) =>
          current.availableBikes > best.availableBikes ? current : best,
    );
  }

  bool get hasActivePass =>
      activePass != null && activePass!.expirationDate.isAfter(DateTime.now());

  String get accessLabel {
    if (hasActivePass) {
      return '${activePass!.type.title} active';
    }
    if (hasSingleTicket) {
      return 'Single ticket ready';
    }
    return 'No active access';
  }

  Future<void> initialize() async {
    await _stationsSubscription?.cancel();

    try {
      _setState(_state.copyWith(isLoading: true, errorMessage: null));
      notifyListeners();

      final loadedPassTypes = await _repository.fetchPassTypes();
      var loadedActivePass = await _repository.loadActivePass();
      final loadedSingleTicket = await _repository.loadSingleTicket();

      if (loadedActivePass != null &&
          !loadedActivePass.expirationDate.isAfter(DateTime.now())) {
        loadedActivePass = null;
        await _repository.saveActivePass(null);
      }

      _setState(
        _state.copyWith(
          passTypes: loadedPassTypes,
          activePass: loadedActivePass,
          hasSingleTicket: loadedSingleTicket,
        ),
      );

      final initialLoad = Completer<void>();
      _stationsSubscription = _repository.watchStations().listen(
        (updatedStations) {
          _applyStations(updatedStations);
          if (!initialLoad.isCompleted) {
            initialLoad.complete();
          }
        },
        onError: (Object error) {
          _setState(
            _state.copyWith(
              errorMessage: 'Unable to load station data.',
              isLoading: false,
            ),
          );
          if (!initialLoad.isCompleted) {
            initialLoad.complete();
          }
          notifyListeners();
        },
      );

      await initialLoad.future;
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
    try {
      final nextPass = RidePass(type: type, purchasedAt: DateTime.now());
      _setState(
        _state.copyWith(
          errorMessage: null,
          activePass: nextPass,
          hasSingleTicket: false,
        ),
      );
      await _repository.saveActivePass(nextPass);
      await _repository.saveSingleTicket(false);
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

  Future<bool> purchaseSingleTicket() async {
    try {
      _setState(_state.copyWith(errorMessage: null, hasSingleTicket: true));
      await _repository.saveSingleTicket(true);
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
        selectedStation: stations.firstWhere(
          (station) => station.id == stationId,
        ),
      ),
    );
    notifyListeners();
  }

  Future<bool> confirmBooking(BikeSlot slot) async {
    final station = selectedStation;
    if (station == null) {
      return false;
    }

    if (!hasActivePass && !hasSingleTicket) {
      return false;
    }

    try {
      _setState(_state.copyWith(errorMessage: null));
      await _repository.bookBike(stationId: station.id, slotId: slot.id);

      if (!hasActivePass) {
        _setState(_state.copyWith(hasSingleTicket: false));
        await _repository.saveSingleTicket(false);
      }

      notifyListeners();
      return true;
    } catch (_) {
      _setState(
        _state.copyWith(errorMessage: 'Unable to confirm the booking.'),
      );
      notifyListeners();
      return false;
    }
  }

  void _applyStations(List<BikeStation> updatedStations) {
    BikeStation? nextSelectedStation = selectedStation;

    final selectedStationId = selectedStation?.id;
    if (selectedStationId != null) {
      for (final station in updatedStations) {
        if (station.id == selectedStationId) {
          nextSelectedStation = station;
          break;
        }
      }
    }

    nextSelectedStation ??= updatedStations.isEmpty
        ? null
        : updatedStations.first;
    _setState(
      _state.copyWith(
        stations: updatedStations,
        selectedStation: nextSelectedStation,
        isLoading: false,
      ),
    );
    notifyListeners();
  }

  void _setState(RideAppState nextState) {
    _state = nextState;
  }

  @override
  void dispose() {
    _stationsSubscription?.cancel();
    super.dispose();
  }
}
