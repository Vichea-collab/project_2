import '../models/bike_station.dart';
import '../models/pass_type.dart';

abstract class RideRepository {
  Future<List<PassType>> fetchPassTypes();
  Future<List<BikeStation>> fetchStations();
}
