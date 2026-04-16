import '../../models/bike_slot.dart';

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
      label: (map['label'] ?? id).toString(),
      isAvailable: map['isAvailable'] == true,
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
    return {'id': id, 'label': label, 'isAvailable': isAvailable};
  }
}
