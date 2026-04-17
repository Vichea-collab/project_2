import 'package:firebase_database/firebase_database.dart';

import '../../models/bike_station.dart';
import '../../models/current_booking.dart';
import '../../models/pass_type.dart';
import '../../models/ride_pass.dart';
import '../dtos/bike_station_dto.dart';
import '../firebase/ride_database_schema.dart';
import '../local/ride_local_storage.dart';
import 'ride_repository.dart';

class FirebaseRealtimeRideRepository implements RideRepository {
  FirebaseRealtimeRideRepository({
    required FirebaseDatabase database,
    required RideLocalStorage localStorage,
  }) : _database = database,
       _localStorage = localStorage;

  final FirebaseDatabase _database;
  final RideLocalStorage _localStorage;

  DatabaseReference get _stationsRef =>
      _database.ref(RideDatabaseSchema.stations);

  @override
  Future<List<PassType>> fetchPassTypes() async {
    return PassType.values;
  }

  @override
  Stream<List<BikeStation>> watchStations() {
    return _stationsRef.onValue.map((event) {
      final value = event.snapshot.value;
      if (value is! Map) {
        return <BikeStation>[];
      }

      final stations = <BikeStation>[];
      for (final entry in value.entries) {
        final data = entry.value;
        if (data is Map<Object?, Object?>) {
          stations.add(
            BikeStationDto.fromMap(entry.key.toString(), data).toDomain(),
          );
        }
      }

      stations.sort((a, b) => a.name.compareTo(b.name));
      return stations;
    });
  }

  @override
  Future<RidePass?> loadActivePass() => _localStorage.loadActivePass();

  @override
  Future<void> saveActivePass(RidePass? pass) =>
      _localStorage.saveActivePass(pass);

  @override
  Future<bool> loadSingleTicket() => _localStorage.loadSingleTicket();

  @override
  Future<void> saveSingleTicket(bool value) =>
      _localStorage.saveSingleTicket(value);

  @override
  Future<CurrentBooking?> loadCurrentBooking() =>
      _localStorage.loadCurrentBooking();

  @override
  Future<void> saveCurrentBooking(CurrentBooking? booking) =>
      _localStorage.saveCurrentBooking(booking);

  @override
  Future<void> bookBike({
    required String stationId,
    required String slotId,
  }) async {
    final slotRef = _stationsRef.child(
      '$stationId/${RideDatabaseSchema.stationSlots}/$slotId',
    );

    final result = await slotRef.runTransaction((currentData) {
      if (currentData is Map) {
        final isAvailable =
            currentData[RideDatabaseSchema.slotIsAvailable] == true;
        if (!isAvailable) {
          return Transaction.abort();
        }

        return Transaction.success({
          ...currentData,
          RideDatabaseSchema.slotIsAvailable: false,
        });
      }

      return Transaction.abort();
    });

    if (!result.committed) {
      throw Exception('Bike is no longer available.');
    }
  }
}
