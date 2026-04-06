import 'package:flutter/foundation.dart';

import '../data/models/bike_slot.dart';
import '../data/models/bike_station.dart';
import '../data/models/current_booking.dart';
import '../data/models/pass_type.dart';
import '../data/models/ride_pass.dart';
import '../data/repositories/ride_repository.dart';

class RideAppViewModel extends ChangeNotifier {
  RideAppViewModel({required RideRepository repository})
    : _repository = repository;

  final RideRepository _repository;

  bool isLoading = true;
  String? errorMessage;
  int currentTabIndex = 1;
  List<PassType> passTypes = [];
  List<BikeStation> stations = [];
  RidePass? activePass;
  bool hasSingleTicket = false;
  BikeStation? selectedStation;
  CurrentBooking? currentBooking;
  List<CurrentBooking> bookingHistory = [];

  int get totalAvailableBikes =>
      stations.fold(0, (total, station) => total + station.availableBikes);

  int get stationsWithBikes =>
      stations.where((station) => station.availableBikes > 0).length;

  bool get hasCurrentBooking => currentBooking != null;
  int get totalBookings => bookingHistory.length;

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
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      passTypes = await _repository.fetchPassTypes();
      stations = await _repository.fetchStations();
      if (stations.isNotEmpty) {
        selectedStation = stations.first;
      }
    } catch (_) {
      errorMessage = 'Unable to load mock ride data.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void changeTab(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  Future<void> activatePass(PassType type) async {
    activePass = RidePass(type: type, purchasedAt: DateTime.now());
    hasSingleTicket = false;
    notifyListeners();
  }

  Future<void> purchaseSingleTicket() async {
    hasSingleTicket = true;
    notifyListeners();
  }

  void selectStation(String stationId) {
    selectedStation = stations.firstWhere((station) => station.id == stationId);
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

    final updatedSlots = station.slots
        .map(
          (item) =>
              item.id == slot.id ? item.copyWith(isAvailable: false) : item,
        )
        .toList();

    stations = stations
        .map(
          (item) =>
              item.id == station.id ? item.copyWith(slots: updatedSlots) : item,
        )
        .toList();

    selectedStation = stations.firstWhere((item) => item.id == station.id);
    currentBooking = CurrentBooking(
      stationName: selectedStation!.name,
      slotLabel: slot.label,
      bookedAt: DateTime.now(),
    );
    bookingHistory = [currentBooking!, ...bookingHistory];

    if (!hasActivePass) {
      hasSingleTicket = false;
    }

    notifyListeners();
    return true;
  }

  void completeCurrentBooking() {
    if (currentBooking == null) {
      return;
    }

    currentBooking = null;
    notifyListeners();
  }
}
