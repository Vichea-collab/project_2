import 'dart:async';

import '../../models/bike_slot.dart';
import '../../models/bike_station.dart';
import '../../models/current_booking.dart';
import '../../models/pass_type.dart';
import '../../models/ride_pass.dart';
import '../local/ride_local_storage.dart';
import 'ride_repository.dart';

class MockRideRepository implements RideRepository {
  MockRideRepository({required RideLocalStorage localStorage})
    : _localStorage = localStorage {
    _stations = _seedStations();
    _controller = StreamController<List<BikeStation>>.broadcast(
      onListen: () => _controller.add(List<BikeStation>.from(_stations)),
    );
  }

  final RideLocalStorage _localStorage;
  late final StreamController<List<BikeStation>> _controller;
  late List<BikeStation> _stations;

  @override
  Future<List<PassType>> fetchPassTypes() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return PassType.values;
  }

  @override
  Stream<List<BikeStation>> watchStations() async* {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    yield List<BikeStation>.from(_stations);
    yield* _controller.stream;
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
    await Future<void>.delayed(const Duration(milliseconds: 300));

    _stations = _stations.map((station) {
      if (station.id != stationId) {
        return station;
      }

      final slots = station.slots
          .map(
            (slot) =>
                slot.id == slotId ? slot.copyWith(isAvailable: false) : slot,
          )
          .toList();

      return station.copyWith(slots: slots);
    }).toList();

    _controller.add(List<BikeStation>.from(_stations));
  }

  List<BikeStation> _seedStations() {
    return const [
      BikeStation(
        id: 'st-1',
        name: 'Riverfront Hub',
        address: 'Sisowath Quay',
        mapX: 0.18,
        mapY: 0.28,
        slots: [
          BikeSlot(id: 's1-1', label: 'A1', isAvailable: true),
          BikeSlot(id: 's1-2', label: 'A2', isAvailable: true),
          BikeSlot(id: 's1-3', label: 'A3', isAvailable: false),
          BikeSlot(id: 's1-4', label: 'A4', isAvailable: true),
          BikeSlot(id: 's1-5', label: 'A5', isAvailable: false),
        ],
      ),
      BikeStation(
        id: 'st-2',
        name: 'Central Market',
        address: 'Street 126',
        mapX: 0.52,
        mapY: 0.18,
        slots: [
          BikeSlot(id: 's2-1', label: 'B1', isAvailable: true),
          BikeSlot(id: 's2-2', label: 'B2', isAvailable: true),
          BikeSlot(id: 's2-3', label: 'B3', isAvailable: true),
          BikeSlot(id: 's2-4', label: 'B4', isAvailable: false),
        ],
      ),
      BikeStation(
        id: 'st-3',
        name: 'Olympic Park',
        address: 'Street 286',
        mapX: 0.76,
        mapY: 0.46,
        slots: [
          BikeSlot(id: 's3-1', label: 'C1', isAvailable: false),
          BikeSlot(id: 's3-2', label: 'C2', isAvailable: true),
          BikeSlot(id: 's3-3', label: 'C3', isAvailable: false),
          BikeSlot(id: 's3-4', label: 'C4', isAvailable: true),
          BikeSlot(id: 's3-5', label: 'C5', isAvailable: true),
        ],
      ),
      BikeStation(
        id: 'st-4',
        name: 'University Gate',
        address: 'Russian Blvd',
        mapX: 0.35,
        mapY: 0.72,
        slots: [
          BikeSlot(id: 's4-1', label: 'D1', isAvailable: true),
          BikeSlot(id: 's4-2', label: 'D2', isAvailable: false),
          BikeSlot(id: 's4-3', label: 'D3', isAvailable: false),
          BikeSlot(id: 's4-4', label: 'D4', isAvailable: true),
        ],
      ),
    ];
  }
}
