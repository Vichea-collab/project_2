import 'package:flutter/foundation.dart';

import '../../../../viewmodels/ride_app_view_model.dart';
import '../../../../../models/bike_slot.dart';
import '../../../../../models/bike_station.dart';

class StationsViewModel extends ChangeNotifier {
  StationsViewModel({required RideAppViewModel appViewModel})
    : _appViewModel = appViewModel {
    _appViewModel.addListener(_handleAppStateChanged);
  }

  final RideAppViewModel _appViewModel;

  List<BikeStation> get stations => _appViewModel.state.stations;
  BikeStation? get selectedStation => _appViewModel.state.selectedStation;
  String get accessLabel => _appViewModel.state.accessLabel;
  bool get hasActivePass => _appViewModel.state.hasActivePass;

  void selectStation(String stationId) {
    _appViewModel.selectStation(stationId);
  }

  void clearSelectedStation() {
    _appViewModel.clearSelectedStation();
  }

  List<BikeSlot> get slots => selectedStation?.slots ?? const [];

  void _handleAppStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _appViewModel.removeListener(_handleAppStateChanged);
    super.dispose();
  }
}
