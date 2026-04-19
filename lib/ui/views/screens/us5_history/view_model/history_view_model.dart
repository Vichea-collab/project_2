import 'package:flutter/foundation.dart';

import '../../../../viewmodels/ride_app_view_model.dart';
import '../../../../../models/app_user.dart';
import '../../../../../models/booking_history_item.dart';

class HistoryViewModel extends ChangeNotifier {
  HistoryViewModel({required RideAppViewModel appViewModel})
    : _appViewModel = appViewModel {
    _appViewModel.addListener(_handleAppStateChanged);
  }

  final RideAppViewModel _appViewModel;

  AppUser? get currentUser => _appViewModel.state.currentUser;
  List<BookingHistoryItem> get bookingHistory =>
      _appViewModel.state.bookingHistory;

  void _handleAppStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _appViewModel.removeListener(_handleAppStateChanged);
    super.dispose();
  }
}
