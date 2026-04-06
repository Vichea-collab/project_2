import 'bike_slot.dart';

class BikeStation {
  const BikeStation({
    required this.id,
    required this.name,
    required this.address,
    required this.mapX,
    required this.mapY,
    required this.slots,
  });

  final String id;
  final String name;
  final String address;
  final double mapX;
  final double mapY;
  final List<BikeSlot> slots;

  int get availableBikes => slots.where((slot) => slot.isAvailable).length;
  int get totalSlots => slots.length;

  BikeStation copyWith({
    String? id,
    String? name,
    String? address,
    double? mapX,
    double? mapY,
    List<BikeSlot>? slots,
  }) {
    return BikeStation(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      mapX: mapX ?? this.mapX,
      mapY: mapY ?? this.mapY,
      slots: slots ?? this.slots,
    );
  }
}
