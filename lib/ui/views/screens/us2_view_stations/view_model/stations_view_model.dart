import 'package:flutter/widgets.dart';

import '../../../../viewmodels/ride_app_view_model.dart';
import '../../../../../models/bike_slot.dart';
import '../../../../../models/bike_station.dart';

class StationsViewModel extends ChangeNotifier {
  StationsViewModel({required RideAppViewModel appViewModel})
    : _appViewModel = appViewModel,
      searchController = TextEditingController() {
    _appViewModel.addListener(_handleAppStateChanged);
  }

  final RideAppViewModel _appViewModel;
  final TextEditingController searchController;
  String _searchQuery = '';

  List<BikeStation> get stations => _appViewModel.state.stations;
  List<BikeStation> get filteredStations {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return stations;
    }

    return stations.where((station) {
      return station.name.toLowerCase().contains(query) ||
          station.address.toLowerCase().contains(query);
    }).toList();
  }

  BikeStation? get selectedStation {
    final selected = _appViewModel.state.selectedStation;
    if (selected == null) {
      return null;
    }

    for (final station in filteredStations) {
      if (station.id == selected.id) {
        return station;
      }
    }

    return null;
  }

  String get searchQuery => _searchQuery;
  bool get hasSearchQuery => _searchQuery.trim().isNotEmpty;
  String get accessLabel => _appViewModel.state.accessLabel;
  bool get hasActivePass => _appViewModel.state.hasActivePass;

  void selectStation(String stationId) {
    _appViewModel.selectStation(stationId);
  }

  void clearSelectedStation() {
    _appViewModel.clearSelectedStation();
  }

  List<BikeSlot> get slots => selectedStation?.slots ?? const [];

  void updateSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void clearSearch() {
    if (_searchQuery.isEmpty) {
      return;
    }
    _searchQuery = '';
    searchController.clear();
    notifyListeners();
  }

  void _handleAppStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    _appViewModel.removeListener(_handleAppStateChanged);
    super.dispose();
  }
}
