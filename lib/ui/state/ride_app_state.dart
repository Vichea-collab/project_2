import '../../models/app_user.dart';
import '../../models/bike_station.dart';
import '../../models/booking_history_item.dart';
import '../../models/pass_type.dart';
import '../../models/ride_pass.dart';

class RideAppState {
  const RideAppState({
    this.isLoading = true,
    this.errorMessage,
    this.currentTabIndex = 0,
    this.passTypes = const [],
    this.stations = const [],
    this.currentUser,
    this.selectedStation,
  });

  final bool isLoading;
  final String? errorMessage;
  final int currentTabIndex;
  final List<PassType> passTypes;
  final List<BikeStation> stations;
  final AppUser? currentUser;
  final BikeStation? selectedStation;

  RidePass? get activePass => currentUser?.activePass;

  bool get hasSingleTicket => currentUser?.hasSingleTicket ?? false;

  List<BookingHistoryItem> get bookingHistory =>
      currentUser?.bookingHistory ?? const [];

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

  RideAppState copyWith({
    bool? isLoading,
    Object? errorMessage = _unset,
    int? currentTabIndex,
    List<PassType>? passTypes,
    List<BikeStation>? stations,
    Object? currentUser = _unset,
    Object? selectedStation = _unset,
  }) {
    return RideAppState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
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
