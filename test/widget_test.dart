import 'package:flutter_test/flutter_test.dart';
import 'package:project_2/data/repositories/mock_ride_repository.dart';
import 'package:project_2/ui/viewmodels/ride_app_view_model.dart';

void main() {
  test('initializes app state from the mock repository', () async {
    final repository = MockRideRepository();
    final viewModel = RideAppViewModel(repository: repository);

    await viewModel.initialize();

    expect(viewModel.state.isLoading, isFalse);
    expect(viewModel.state.errorMessage, isNull);
    expect(viewModel.state.stations, isNotEmpty);
    expect(viewModel.state.passTypes, isNotEmpty);
    expect(viewModel.state.currentUser?.name, equals('Sok Dara'));

    viewModel.dispose();
  });
}
