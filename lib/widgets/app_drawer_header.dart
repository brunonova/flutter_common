import 'package:flutter/material.dart';

import '../extensions/build_context.dart';

/// A [DrawerHeader] that shows the application name over a gradient as
/// background with colors from the current color scheme.
class AppDrawerHeader extends StatelessWidget {
  const AppDrawerHeader({super.key, required this.appName});

  final String appName;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            // Always from darker to lighter color
            if (context.theme.brightness == Brightness.dark)
              context.colorScheme.primaryContainer,
            context.colorScheme.primary,
            if (context.theme.brightness == Brightness.light)
              context.colorScheme.primaryContainer,
          ],
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          appName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
