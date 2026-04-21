import 'package:flutter/foundation.dart';

import '../../../../viewmodels/ride_app_view_model.dart';
import '../../../../../models/pass_type.dart';
import '../../../../../models/ride_pass.dart';
import '../../../../utils/date_time_utils.dart';

class PassSelectionViewModel extends ChangeNotifier {
  PassSelectionViewModel({
    required RideAppViewModel appViewModel,
    required this.selectionMode,
  }) : _appViewModel = appViewModel {
    _appViewModel.addListener(_handleAppStateChanged);
  }

  final RideAppViewModel _appViewModel;
  final bool selectionMode;

  List<PassType> get passTypes => _appViewModel.state.passTypes;
  PassType? get activePassType => _appViewModel.state.activePass?.type;
  bool get hasActivePass => _appViewModel.state.activePass != null;
  String? get errorMessage => _appViewModel.state.status.errorMessage;
  String? get activePassExpirationLabel {
    final activePass = _appViewModel.state.activePass;
    if (activePass == null) {
      return null;
    }
    return formatDateLong(activePass.expirationDate);
  }

  String get heroTitle =>
      selectionMode ? 'Choose pass access' : 'Choose the pass that fits you';

  String get heroSubtitle {
    final activePass = _appViewModel.state.activePass;
    if (activePass == null) {
      return selectionMode
          ? 'Pick one pass to continue this reservation. Buying a new pass replaces the current one.'
          : 'Pick one active pass. Buying a new pass replaces the current one.';
    }

    return selectionMode
        ? '${activePass.type.title} is active until ${formatDateLong(activePass.expirationDate)}. You can keep it or replace it for this booking.'
        : '${activePass.type.title} is active until ${formatDateLong(activePass.expirationDate)}.';
  }

  Future<bool> activatePass(PassType passType) async {
    final currentUser = _appViewModel.state.currentUser;
    if (currentUser == null) return false;

    try {
      final nextPass = RidePass(type: passType, purchasedAt: DateTime.now());
      final updatedUser = currentUser.copyWith(activePass: nextPass);
      await _appViewModel.saveUser(updatedUser);
      return true;
    } catch (_) {
      _appViewModel.setErrorMessage('Unable to activate the selected pass.');
      return false;
    }
  }

  Future<bool> cancelActivePass() async {
    final currentUser = _appViewModel.state.currentUser;
    if (currentUser == null) return false;

    try {
      final updatedUser = currentUser.copyWith(activePass: null);
      await _appViewModel.saveUser(updatedUser);
      return true;
    } catch (_) {
      _appViewModel.setErrorMessage('Unable to cancel the active pass.');
      return false;
    }
  }

  void _handleAppStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _appViewModel.removeListener(_handleAppStateChanged);
    super.dispose();
  }
}
