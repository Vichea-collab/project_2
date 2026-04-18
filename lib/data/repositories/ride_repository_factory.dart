import 'package:flutter/foundation.dart';

import 'mock_ride_repository.dart';
import 'ride_repository.dart';
import 'ride_rest_repository.dart';

class RideRepositoryFactory {
  static const databaseUrl =
      'https://bikerental-255c4-default-rtdb.asia-southeast1.firebasedatabase.app/';

  static Future<RideRepository> create() async {
    try {
      return RideRestRepository(databaseUrl: databaseUrl);
    } catch (error, stackTrace) {
      debugPrint('REST API unavailable, falling back to mock repository.');
      debugPrint('$error');
      debugPrintStack(stackTrace: stackTrace);
      return MockRideRepository();
    }
  }
}
