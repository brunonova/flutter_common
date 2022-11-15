// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';

/// This [ScrollBehavior] adds [Scrollbar] widgets to all scrollable widget
/// to all platforms, and not just for the desktop.
///
/// It should be assigned to the "scrollBehavior" of the [MaterialApp].
class CommonScrollBehavior extends MaterialScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    // Add Scrollbar widgets on all platforms
    if (axisDirectionToAxis(details.direction) == Axis.vertical) {
      child = Scrollbar(
        controller: details.controller,
        child: child,
      );
    }
    return child;
  }
}
