// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';
import '../extensions/build_context.dart';

/// Builds a [ReorderableDragStartListener] on desktop platforms or a
/// [ReorderableDelayedDragStartListener] on mobile platforms.
class PlatformReorderableDragStartListener extends StatelessWidget {
  const PlatformReorderableDragStartListener({
    super.key,
    this.enabled = true,
    required this.index,
    required this.child,
  });

  /// Whether dragging is enabled.
  final bool enabled;

  /// The index of the associated item.
  final int index;

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktopTargetPlatform) {
      return ReorderableDragStartListener(
        key: key,
        enabled: enabled,
        index: index,
        child: child,
      );
    } else {
      return ReorderableDelayedDragStartListener(
        key: key,
        enabled: enabled,
        index: index,
        child: child,
      );
    }
  }
}
