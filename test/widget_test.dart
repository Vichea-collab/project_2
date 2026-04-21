import 'package:flutter_test/flutter_test.dart';
import 'package:project_2/data/mockup_data.dart';
import 'package:project_2/data/repositories/bike/bike_repository.dart';
import 'package:project_2/data/repositories/pass/pass_repository.dart';
import 'package:project_2/data/repositories/station/station_repository.dart';
import 'package:project_2/data/repositories/user/user_repository.dart';
import 'package:project_2/ui/viewmodels/ride_app_view_model.dart';

void main() {
  test('initializes app state from the mock repository', () async {
    final store = MockRideStore();
    final viewModel = RideAppViewModel(
      bikeRepository: BikeMockRepository(store: store),
      passRepository: const PassMockRepository(),
      stationRepository: StationMockRepository(store: store),
      userRepository: UserMockRepository(store: store),
    );

    await viewModel.initialize();

    expect(viewModel.state.isLoading, isFalse);
    expect(viewModel.state.errorMessage, isNull);
    expect(viewModel.state.stations, isNotEmpty);
    expect(viewModel.state.passTypes, isNotEmpty);
    expect(viewModel.state.currentUser?.name, equals('Sok Dara'));

    viewModel.dispose();
  });
}
