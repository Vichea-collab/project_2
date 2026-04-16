import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../local/shared_prefs_ride_local_storage.dart';
import 'firebase_realtime_ride_repository.dart';
import 'mock_ride_repository.dart';
import 'ride_repository.dart';

class RideRepositoryFactory {
  static const _databaseUrl =
      'https://bikerental-255c4-default-rtdb.asia-southeast1.firebasedatabase.app/';

  static Future<RideRepository> create() async {
    final preferences = await SharedPreferences.getInstance();
    final localStorage = SharedPrefsRideLocalStorage(preferences: preferences);

    try {
      final app = await Firebase.initializeApp();
      return FirebaseRealtimeRideRepository(
        database: FirebaseDatabase.instanceFor(
          app: app,
          databaseURL: _databaseUrl,
        ),
        localStorage: localStorage,
      );
    } catch (error, stackTrace) {
      debugPrint('Firebase unavailable, falling back to mock repository.');
      debugPrint('$error');
      debugPrintStack(stackTrace: stackTrace);
      return MockRideRepository(localStorage: localStorage);
    }
  }
}
