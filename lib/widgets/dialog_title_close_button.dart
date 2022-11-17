import 'package:flutter/material.dart';

import '../extensions/build_context.dart';

/// Title widget for dialogs that contains an optional close button.
class DialogTitleWithCloseButton extends StatelessWidget {
  const DialogTitleWithCloseButton({
    super.key,
    required this.title,
    this.showCloseButton = false,
  });

  /// The title widget.
  final Widget title;

  /// Enable [showCloseButton] to show a close button on the dialog.
  final bool showCloseButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child: title),
        if (showCloseButton)
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => context.navigator.pop(),
            icon: const Icon(Icons.close),
          ),
      ],
    );
  }
}
