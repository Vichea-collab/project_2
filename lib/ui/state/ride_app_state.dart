import '../../models/bike_station.dart';
import '../../models/pass_type.dart';
import '../../models/ride_pass.dart';

class RideAppState {
  const RideAppState({
    this.isLoading = true,
    this.errorMessage,
    this.currentTabIndex = 0,
    this.passTypes = const [],
    this.stations = const [],
    this.activePass,
    this.hasSingleTicket = false,
    this.selectedStation,
  });

  final bool isLoading;
  final String? errorMessage;
  final int currentTabIndex;
  final List<PassType> passTypes;
  final List<BikeStation> stations;
  final RidePass? activePass;
  final bool hasSingleTicket;
  final BikeStation? selectedStation;

  RideAppState copyWith({
    bool? isLoading,
    Object? errorMessage = _sentinel,
    int? currentTabIndex,
    List<PassType>? passTypes,
    List<BikeStation>? stations,
    Object? activePass = _sentinel,
    bool? hasSingleTicket,
    Object? selectedStation = _sentinel,
  }) {
    return RideAppState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: identical(errorMessage, _sentinel)
          ? this.errorMessage
          : errorMessage as String?,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      passTypes: passTypes ?? this.passTypes,
      stations: stations ?? this.stations,
      activePass: identical(activePass, _sentinel)
          ? this.activePass
          : activePass as RidePass?,
      hasSingleTicket: hasSingleTicket ?? this.hasSingleTicket,
      selectedStation: identical(selectedStation, _sentinel)
          ? this.selectedStation
          : selectedStation as BikeStation?,
    );
  }
}

const _sentinel = Object();
