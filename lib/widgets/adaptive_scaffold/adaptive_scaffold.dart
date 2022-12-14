// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../extensions/build_context.dart';
import 'drawer.dart';
import 'navigation_rail.dart';

/// A [Scaffold] that shows a [Drawer] on small screens and a [NavigationRail]
/// on larger screens.
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    this.title,
    this.titleColor,
    required this.body,
    this.breakpoint = 700,
    this.appBar,
    this.drawerHeader,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.minExtendedWidth = 256.0,
    this.backButtonOnlyQuitAtHomePage = true,
    this.buildNavigationRail,
    this.buildDrawer,
    required this.destinations,
  });

  /// Title of the window (for the web). If given, a [Title] widget will
  /// be used.
  final String? title;

  /// Color for the [Title] widget.
  final Color? titleColor;

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

  /// Whether pressing the back key will only quit the app if at the home page,
  /// using a [WillPopScope].
  final bool backButtonOnlyQuitAtHomePage;

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

    Widget tree = Row(
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

    if (backButtonOnlyQuitAtHomePage) {
      tree = WillPopScope(
        onWillPop: () async {
          if (context.canPop() || context.currentLocation == "/") {
            return true;
          } else {
            // Would quit the app but it's not at the home page, so go back
            // to the home page
            context.go("/");
            return false;
          }
        },
        child: tree,
      );
    }

    // Add the title widget
    tree = Title(
      // If on web and the title is given, use it. Else use the application name
      title: (kIsWeb && title != null) ? title! : "appName".tr(),
      // Title color if given, else use the background color
      color: titleColor ?? context.theme.scaffoldBackgroundColor,
      child: tree,
    );

    return tree;
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
