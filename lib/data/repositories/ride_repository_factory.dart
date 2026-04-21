import 'package:flutter/foundation.dart';

import '../mockup_data.dart';
import 'bike/bike_repository.dart';
import 'pass/pass_repository.dart';
import 'station/station_repository.dart';
import 'user/user_repository.dart';

class RideRepositories {
  const RideRepositories({
    required this.bikeRepository,
    required this.passRepository,
    required this.stationRepository,
    required this.userRepository,
  });

  final BikeRepository bikeRepository;
  final PassRepository passRepository;
  final StationRepository stationRepository;
  final UserRepository userRepository;
}

class RideRepositoryFactory {
  static const databaseUrl =
      'https://bikerental-255c4-default-rtdb.asia-southeast1.firebasedatabase.app/';

  static Future<RideRepositories> create() async {
    try {
      return RideRepositories(
        bikeRepository: BikeRestRepository(databaseUrl: databaseUrl),
        passRepository: const PassRestRepository(),
        stationRepository: StationRestRepository(databaseUrl: databaseUrl),
        userRepository: UserRestRepository(databaseUrl: databaseUrl),
      );
    } catch (error, stackTrace) {
      final store = MockRideStore();
      debugPrint('REST repository unavailable, falling back to mock data.');
      debugPrint('$error');
      debugPrintStack(stackTrace: stackTrace);
      return RideRepositories(
        bikeRepository: BikeMockRepository(store: store),
        passRepository: const PassMockRepository(),
        stationRepository: StationMockRepository(store: store),
        userRepository: UserMockRepository(store: store),
      );
    }
  }
}
