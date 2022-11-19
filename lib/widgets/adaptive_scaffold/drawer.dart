// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../extensions/build_context.dart';
import 'adaptive_scaffold.dart';

/// The drawer used by the [AdaptiveScaffold].
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    this.drawerHeader,
    required this.destinations,
  });

  /// Header of the drawer.
  final Widget? drawerHeader;

  /// Navigation destinations.
  final List<RouteDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        primary: false,
        padding: EdgeInsets.zero,
        children: [
          if (drawerHeader != null) drawerHeader!,
          for (var destination in destinations)
            ListTile(
              leading: Icon(destination.icon),
              title: Text(destination.text),
              selected: context.currentLocation == destination.path,
              onTap: () {
                context.navigator.pop();
                if (context.currentLocation != destination.path) {
                  context.go(destination.path);
                }
              },
            ),
        ],
      ),
    );
  }
}
