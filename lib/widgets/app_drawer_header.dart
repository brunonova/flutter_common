import 'package:flutter/material.dart';

import '../extensions/build_context.dart';

/// A [DrawerHeader] that shows the application name over a gradient as
/// background with colors from the current color scheme.
class AppDrawerHeader extends StatelessWidget {
  const AppDrawerHeader({
    super.key,
    required this.title,
    this.height,
    this.gradientBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget header = DrawerHeader(
      decoration: gradientBackground
          ? BoxDecoration(
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
            )
          : null,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );

    if (height != null) {
      header = SizedBox(
        height: height,
        child: header,
      );
    }

    return header;
  }

  /// Title of the header.
  final String title;

  /// Optional height of the header.
  final double? height;

  /// Whether to show a gradient with the primary colors of the color scheme
  /// as background.
  final bool gradientBackground;
}
