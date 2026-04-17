import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../local/shared_prefs_ride_local_storage.dart';
import 'mock_ride_repository.dart';
import 'ride_repository.dart';
import 'ride_rest_repository.dart';

class RideRepositoryFactory {
  static const _databaseUrl =
      'https://bikerental-255c4-default-rtdb.asia-southeast1.firebasedatabase.app/';

  static Future<RideRepository> create() async {
    final preferences = await SharedPreferences.getInstance();
    final localStorage = SharedPrefsRideLocalStorage(preferences: preferences);

    try {
      return RideRestRepository(
        databaseUrl: _databaseUrl,
        localStorage: localStorage,
      );
    } catch (error, stackTrace) {
      debugPrint('REST API unavailable, falling back to mock repository.');
      debugPrint('$error');
      debugPrintStack(stackTrace: stackTrace);
      return MockRideRepository(localStorage: localStorage);
    }
  }
}
