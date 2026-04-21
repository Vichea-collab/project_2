import '../../models/app_user.dart';
import '../../models/bike_station.dart';
import '../../models/pass_type.dart';
import '../../models/ride_pass.dart';
import '../utils/async_value.dart';

class RideAppState {
  const RideAppState({
    this.status = const AsyncValue.loading(),
    this.currentTabIndex = 0,
    this.passTypes = const [],
    this.stations = const [],
    this.currentUser,
    this.selectedStation,
  });

  final AsyncValue<void> status;
  final int currentTabIndex;
  final List<PassType> passTypes;
  final List<BikeStation> stations;
  final AppUser? currentUser;
  final BikeStation? selectedStation;

  bool get isLoading => status.isLoading;
  String? get errorMessage => status.errorMessage;

  RidePass? get activePass => currentUser?.activePass;

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
    return 'No active access';
  }

  RideAppState copyWith({
    AsyncValue<void>? status,
    int? currentTabIndex,
    List<PassType>? passTypes,
    List<BikeStation>? stations,
    Object? currentUser = _unset,
    Object? selectedStation = _unset,
  }) {
    return RideAppState(
      status: status ?? this.status,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      passTypes: passTypes ?? this.passTypes,
      stations: stations ?? this.stations,
      currentUser: identical(currentUser, _unset)
          ? this.currentUser
          : currentUser as AppUser?,
      selectedStation: identical(selectedStation, _unset)
          ? this.selectedStation
          : selectedStation as BikeStation?,
    );
  }
}

const _unset = Object();
