import '../../models/bike_slot.dart';
import '../firebase/ride_database_schema.dart';

class BikeSlotDto {
  const BikeSlotDto({
    required this.id,
    required this.label,
    required this.isAvailable,
  });

  final String id;
  final String label;
  final bool isAvailable;

  factory BikeSlotDto.fromMap(String id, Map<Object?, Object?> map) {
    return BikeSlotDto(
      id: id,
      label: (map[RideDatabaseSchema.slotLabel] ?? id).toString(),
      isAvailable: map[RideDatabaseSchema.slotIsAvailable] == true,
    );
  }

  factory BikeSlotDto.fromDomain(BikeSlot slot) {
    return BikeSlotDto(
      id: slot.id,
      label: slot.label,
      isAvailable: slot.isAvailable,
    );
  }

  BikeSlot toDomain() {
    return BikeSlot(id: id, label: label, isAvailable: isAvailable);
  }

  Map<String, Object?> toMap() {
    return {
      RideDatabaseSchema.slotId: id,
      RideDatabaseSchema.slotLabel: label,
      RideDatabaseSchema.slotIsAvailable: isAvailable,
    };
  }
}
