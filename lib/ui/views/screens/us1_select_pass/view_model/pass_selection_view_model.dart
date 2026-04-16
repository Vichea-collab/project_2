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
  List<PassType> get passTypes => _appViewModel.passTypes;
  PassType? get activePassType => _appViewModel.activePass?.type;
  bool get hasActivePass => _appViewModel.activePass != null;
  String? get errorMessage => _appViewModel.errorMessage;

  String get heroTitle =>
      selectionMode ? 'Select a pass' : 'Choose the pass that fits you';

  String get heroSubtitle {
    final activePass = _appViewModel.activePass;
    if (activePass == null) {
      return 'Pick one active pass. Buying a new pass replaces the current one.';
    }

    return '${activePass.type.title} is active until ${_formatDate(activePass.expirationDate)}.';
  }

  Future<bool> activatePass(PassType passType) {
    return _appViewModel.activatePass(passType);
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
