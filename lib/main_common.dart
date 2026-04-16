import 'package:flutter/material.dart';

import 'app.dart';
import 'data/repositories/ride_repository.dart';

Future<void> mainCommon({
  required Future<RideRepository> Function() createRepository,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = await createRepository();
  runApp(RideRentalApp(repository: repository));
}
