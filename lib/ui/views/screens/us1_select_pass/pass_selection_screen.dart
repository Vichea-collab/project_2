import 'package:flutter/material.dart';

import '../../../viewmodels/ride_app_view_model.dart';
import 'view_model/pass_selection_view_model.dart';
import 'widgets/pass_selection_content.dart';

class PassSelectionScreen extends StatefulWidget {
  const PassSelectionScreen({
    super.key,
    required this.viewModel,
    this.selectionMode = false,
  });

  final RideAppViewModel viewModel;
  final bool selectionMode;

  @override
  State<PassSelectionScreen> createState() => _PassSelectionScreenState();
}

class _PassSelectionScreenState extends State<PassSelectionScreen> {
  late final PassSelectionViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PassSelectionViewModel(
      appViewModel: widget.viewModel,
      selectionMode: widget.selectionMode,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return PassSelectionContent(
          viewModel: _viewModel,
          onSelectPass: (index) => _selectPass(context, index),
        );
      },
    );
  }

  Future<void> _selectPass(BuildContext context, int index) async {
    final messenger = ScaffoldMessenger.of(context);
    final passType = _viewModel.passTypes[index];
    final activated = await _viewModel.activatePass(passType);

    if (!context.mounted) {
      return;
    }

    if (!activated) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            _viewModel.errorMessage ?? 'Unable to activate the selected pass.',
          ),
        ),
      );
      return;
    }

    if (widget.selectionMode) {
      Navigator.of(context).pop(passType);
      return;
    }

    messenger.showSnackBar(
      SnackBar(content: Text('${passType.title} activated.')),
    );
  }
}
