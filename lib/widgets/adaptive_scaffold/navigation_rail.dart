// Copyright (c) 2022 Bruno Nova - MIT License
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../extensions/build_context.dart';
import '../../utils/app.dart';
import 'adaptive_scaffold.dart';

/// Navigation rail for the [AdaptiveScaffold].
class AppNavigationRail extends StatefulWidget {
  const AppNavigationRail({
    super.key,
    this.minExtendedWidth = 256.0,
    required this.destinations,
  });

  /// Width of the rail when extended.
  final double minExtendedWidth;

  /// Navigation destinations.
  final List<RouteDestination> destinations;

  @override
  State<AppNavigationRail> createState() => _AppNavigationRailState();
}

class _AppNavigationRailState extends State<AppNavigationRail> {
  bool _extended = App.prefs.getBool("navigationRailExtended") ?? false;

  void toggleExtended() {
    setState(() {
      _extended = !_extended;
    });
    App.prefs.setBool("navigationRailExtended", _extended);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var selectedIndex = widget.destinations
          .indexWhere((element) => element.path == context.currentLocation);
      if (selectedIndex < 0) selectedIndex = 0;

      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              leading: _ExtendButton(
                toggleExtended: toggleExtended,
                extended: _extended,
                minExtendedWidth: widget.minExtendedWidth,
              ),
              minWidth: 56,
              minExtendedWidth: widget.minExtendedWidth,
              extended: _extended,
              onDestinationSelected: (index) =>
                  context.go(widget.destinations[index].path),
              destinations: [
                for (var destination in widget.destinations)
                  NavigationRailDestination(
                    icon: Icon(destination.icon),
                    label: Text(destination.text),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

/// Button to extend/collapse the NavigationRail
class _ExtendButton extends StatelessWidget {
  const _ExtendButton({
    required this.toggleExtended,
    required this.extended,
    required this.minExtendedWidth,
  });

  final void Function() toggleExtended;
  final bool extended;
  final double minExtendedWidth;

  @override
  Widget build(BuildContext context) {
    // Animation to keep the button aligned to the left
    final animation = NavigationRail.extendedAnimation(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) => Container(
        padding: EdgeInsets.only(
          right: lerpDouble(0, minExtendedWidth - 56.0, animation.value)!,
          top: 4,
        ),
        child: IconButton(
          onPressed: toggleExtended,
          icon: const Icon(Icons.menu),
        ),
      ),
    );
  }
}
