import 'package:flutter/foundation.dart';

import '../../../../viewmodels/ride_app_view_model.dart';
import '../../../../../models/pass_type.dart';

class PassSelectionViewModel extends ChangeNotifier {
  PassSelectionViewModel({
    required RideAppViewModel appViewModel,
    required this.selectionMode,
  }) : _appViewModel = appViewModel {
    _appViewModel.addListener(_handleAppStateChanged);
  }

  final RideAppViewModel _appViewModel;
  final bool selectionMode;

  RideAppViewModel get appViewModel => _appViewModel;
  List<PassType> get passTypes => _appViewModel.state.passTypes;
  PassType? get activePassType => _appViewModel.state.activePass?.type;
  bool get hasActivePass => _appViewModel.state.activePass != null;
  String? get errorMessage => _appViewModel.state.errorMessage;
  String? get activePassExpirationLabel {
    final activePass = _appViewModel.state.activePass;
    if (activePass == null) {
      return null;
    }
    return _formatDate(activePass.expirationDate);
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
        ? '${activePass.type.title} is active until ${_formatDate(activePass.expirationDate)}. You can keep it or replace it for this booking.'
        : '${activePass.type.title} is active until ${_formatDate(activePass.expirationDate)}.';
  }

  Future<bool> activatePass(PassType passType) {
    return _appViewModel.activatePass(passType);
  }

  Future<bool> cancelActivePass() {
    return _appViewModel.cancelActivePass();
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

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
