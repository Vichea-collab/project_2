import '../models/app_user.dart';
import '../models/bike_slot.dart';
import '../models/bike_station.dart';

class MockRideStore {
  MockRideStore() : stations = _seedStations();

  List<BikeStation> stations;
  AppUser currentUser = const AppUser(id: 'u-001', name: 'Sok Dara');

  static List<BikeStation> _seedStations() {
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
      BikeStation(
        id: 'st-5',
        name: 'Wat Phnom',
        address: 'Street 94',
        mapX: 0.12,
        mapY: 0.12,
        slots: [
          BikeSlot(id: 's5-1', label: 'E1', isAvailable: true),
          BikeSlot(id: 's5-2', label: 'E2', isAvailable: false),
          BikeSlot(id: 's5-3', label: 'E3', isAvailable: true),
          BikeSlot(id: 's5-4', label: 'E4', isAvailable: true),
        ],
      ),
      BikeStation(
        id: 'st-6',
        name: 'Independence Monument',
        address: 'Norodom Blvd',
        mapX: 0.62,
        mapY: 0.34,
        slots: [
          BikeSlot(id: 's6-1', label: 'F1', isAvailable: true),
          BikeSlot(id: 's6-2', label: 'F2', isAvailable: true),
          BikeSlot(id: 's6-3', label: 'F3', isAvailable: false),
          BikeSlot(id: 's6-4', label: 'F4', isAvailable: false),
          BikeSlot(id: 's6-5', label: 'F5', isAvailable: true),
        ],
      ),
      BikeStation(
        id: 'st-7',
        name: 'Tuol Sleng',
        address: 'Street 113',
        mapX: 0.48,
        mapY: 0.58,
        slots: [
          BikeSlot(id: 's7-1', label: 'G1', isAvailable: false),
          BikeSlot(id: 's7-2', label: 'G2', isAvailable: true),
          BikeSlot(id: 's7-3', label: 'G3', isAvailable: true),
          BikeSlot(id: 's7-4', label: 'G4', isAvailable: true),
        ],
      ),
      BikeStation(
        id: 'st-8',
        name: 'Factory Phnom Penh',
        address: 'National Road 2',
        mapX: 0.78,
        mapY: 0.72,
        slots: [
          BikeSlot(id: 's8-1', label: 'H1', isAvailable: true),
          BikeSlot(id: 's8-2', label: 'H2', isAvailable: false),
          BikeSlot(id: 's8-3', label: 'H3', isAvailable: false),
          BikeSlot(id: 's8-4', label: 'H4', isAvailable: true),
          BikeSlot(id: 's8-5', label: 'H5', isAvailable: true),
        ],
      ),
      BikeStation(
        id: 'st-9',
        name: 'Bassac Lane',
        address: 'Street 308',
        mapX: 0.7,
        mapY: 0.24,
        slots: [
          BikeSlot(id: 's9-1', label: 'I1', isAvailable: true),
          BikeSlot(id: 's9-2', label: 'I2', isAvailable: true),
          BikeSlot(id: 's9-3', label: 'I3', isAvailable: false),
        ],
      ),
    ];
  }
}
