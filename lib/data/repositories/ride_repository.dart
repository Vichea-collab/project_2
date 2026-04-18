import '../../models/app_user.dart';
import '../../models/bike_station.dart';
import '../../models/pass_type.dart';

abstract class RideRepository {
  Future<List<PassType>> fetchPassTypes();
  Future<List<BikeStation>> fetchStations();
  Future<AppUser> fetchCurrentUser();
  Future<void> saveCurrentUser(AppUser user);
  Future<void> bookBike({required String stationId, required String slotId});
}
