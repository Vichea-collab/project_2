# Firebase Realtime Database And Local Storage

This project uses Firebase Realtime Database for shared station availability and SharedPreferences for device-local rider state.

## Firebase Realtime Database Design

Top-level node:

```json
{
  "stations": {
    "{stationId}": {
      "name": "Riverfront Hub",
      "address": "Sisowath Quay",
      "mapX": 0.18,
      "mapY": 0.28,
      "slots": {
        "{slotId}": {
          "id": "s1-1",
          "label": "A1",
          "isAvailable": true
        }
      }
    }
  }
}
```

Rationale:
- `stations` is the shared realtime source for US2 and US3.
- each station document/node includes map position and nested slots.
- each slot keeps a minimal reservation state with `isAvailable`.
- booking uses a Firebase transaction on `stations/{stationId}/slots/{slotId}` so two users cannot reserve the same bike at the same time.

Seed data for import is provided in:
- [realtime_database_seed.json](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/firebase/realtime_database_seed.json)

## Model Mapping

Domain models:
- [bike_station.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/models/bike_station.dart)
- [bike_slot.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/models/bike_slot.dart)
- [ride_pass.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/models/ride_pass.dart)
- [current_booking.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/models/current_booking.dart)

Firebase DTOs:
- [bike_station_dto.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/data/dtos/bike_station_dto.dart)
- [bike_slot_dto.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/data/dtos/bike_slot_dto.dart)

Local-storage DTOs:
- [ride_pass_dto.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/data/dtos/ride_pass_dto.dart)
- [current_booking_dto.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/data/dtos/current_booking_dto.dart)

Shared schema constants:
- [ride_database_schema.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/data/firebase/ride_database_schema.dart)

## Local Storage Design

Stored in SharedPreferences:
- `ride_active_pass`
- `ride_single_ticket`
- `ride_current_booking`

Implementation:
- [ride_local_storage.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/data/local/ride_local_storage.dart)
- [shared_prefs_ride_local_storage.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/data/local/shared_prefs_ride_local_storage.dart)

Rationale:
- Firebase keeps shared station/slot availability.
- SharedPreferences keeps per-device rider state for pass/ticket/booking continuity.

## Current Integration Status

Already implemented:
- Firebase Realtime Database repository:
  [firebase_realtime_ride_repository.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/data/repositories/firebase_realtime_ride_repository.dart)
- repository factory with Firebase fallback to mock:
  [ride_repository_factory.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/data/repositories/ride_repository_factory.dart)
- SharedPreferences local storage:
  [shared_prefs_ride_local_storage.dart](/Users/luchtithvichea/Desktop/Advanced_Mobile/project_2/lib/data/local/shared_prefs_ride_local_storage.dart)

Still required for full runtime connection on device:
- `google-services.json` for Android
- `GoogleService-Info.plist` for iOS if needed
- optional `firebase_options.dart` if you generate config with FlutterFire CLI

Without native Firebase app config, the repository factory falls back to the mock repository.
