import 'ride_pass.dart';

class AppUser {
  const AppUser({required this.id, required this.name, this.activePass});

  final String id;
  final String name;
  final RidePass? activePass;

  AppUser copyWith({String? id, String? name, Object? activePass = _sentinel}) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      activePass: identical(activePass, _sentinel)
          ? this.activePass
          : activePass as RidePass?,
    );
  }
}

const _sentinel = Object();
