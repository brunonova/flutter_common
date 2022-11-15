// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../extensions/build_context.dart';
import 'drawer.dart';
import 'navigation_rail.dart';

/// A [Scaffold] that shows a [Drawer] on small screens and a [NavigationRail]
/// on larger screens.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    this.title,
    this.titleColor = Colors.white,
    required this.body,
    this.breakpoint = 700,
    this.appBar,
    this.drawerHeader,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.minExtendedWidth = 256.0,
    this.buildNavigationRail,
    this.buildDrawer,
    required this.destinations,
  });

  /// Title of the window (for the web). If given, a [Title] widget will
  /// be used.
  final String? title;

  /// Color for the [Title] widget, if the [title] argument is given.
  final Color titleColor;

  /// Body of the page.
  final Widget body;

  /// Minimum window width to switch from a [Drawer] to a [NavigationRail].
  final double breakpoint;

  /// [AppBar] for the [Scaffold].
  final PreferredSizeWidget? appBar;

  /// Optional [DrawerHeader] to show at the top of the [Drawer].
  final Widget? drawerHeader;

  /// Optional [FloatingActionButton] for the [Scaffold].
  final Widget? floatingActionButton;

  /// Position of the [FloatingActionButton] on the [Scaffold].
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Minimum width of the [NavigationRail] when extended.
  final double minExtendedWidth;

  /// Optional function to build the [NavigationRail]. If not provided, the
  /// default one will be built.
  final Widget Function(
          BuildContext context, List<RouteDestination> destinations)?
      buildNavigationRail;

  /// Optional function to build the [Drawer]. If not provided, the
  /// default one will be built.
  final Widget Function(
      BuildContext context, List<RouteDestination> destinations)? buildDrawer;

  /// Navigation destinations for the [Drawer] and the [NavigationRail].
  final List<RouteDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final wide = context.mediaQuery.size.width >= breakpoint;

    final tree = Row(
      children: [
        // Navigation rail only on wide screens
        if (wide)
          buildNavigationRail?.call(context, destinations) ??
              AppNavigationRail(
                destinations: destinations,
                minExtendedWidth: minExtendedWidth,
              ),
        Expanded(
          child: Scaffold(
            appBar: appBar,
            body: body,
            // Drawer only on small screens
            drawer: wide
                ? null
                : buildDrawer?.call(context, destinations) ??
                    AppDrawer(
                      destinations: destinations,
                      drawerHeader: drawerHeader,
                    ),
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
          ),
        ),
      ],
    );

    if (title != null && kIsWeb) {
      // Add the title
      return Title(
        title: title!,
        color: titleColor,
        child: tree,
      );
    } else {
      return tree;
    }
  }
}

/// A navigation destination for the [Drawer] or [NavigationRail] of the
/// [AdaptiveScaffold].
class RouteDestination {
  /// Path to the destination page.
  final String path;

  /// Icon of the navigation button.
  final IconData icon;

  /// Text of the navigation button.
  final String text;

  const RouteDestination({
    required this.path,
    required this.icon,
    required this.text,
  });
}
