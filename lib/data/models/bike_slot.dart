class BikeSlot {
  const BikeSlot({
    required this.id,
    required this.label,
    required this.isAvailable,
  });

  final String id;
  final String label;
  final bool isAvailable;

  BikeSlot copyWith({String? id, String? label, bool? isAvailable}) {
    return BikeSlot(
      id: id ?? this.id,
      label: label ?? this.label,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
