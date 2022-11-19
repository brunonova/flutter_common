// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/build_context.dart';

/// Some utilities to build the application theme (when using Material design 3
/// and color schemes from seeds).
class CommonTheme {
  CommonTheme._(); // no instantiation of this class

  /// Build a [ThemeData] from the given color scheme.
  ///
  /// [appBarTheme], [scrollbarTheme], [snackBarTheme] and [switchTheme] will
  /// set default values based on the given color scheme if null.
  static ThemeData themeData({
    required BuildContext context,
    required ColorScheme colorScheme,
    AppBarTheme? appBarTheme,
    CardTheme? cardTheme,
    ScrollbarThemeData? scrollbarTheme,
    SnackBarThemeData? snackBarTheme,
    SwitchThemeData? switchTheme,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      appBarTheme: appBarTheme ?? CommonTheme.appBarTheme(colorScheme),
      scrollbarTheme: scrollbarTheme ?? CommonTheme.scrollbarTheme(context),
      snackBarTheme: snackBarTheme ?? CommonTheme.snackBarTheme(colorScheme),
      switchTheme: switchTheme ?? CommonTheme.switchTheme(colorScheme),
      cardTheme: cardTheme,
    );
  }

  /// Returns an [AppBar] theme with colors from the given color scheme.
  static AppBarTheme appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: (colorScheme.brightness == Brightness.light)
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
    );
  }

  /// Returns a scrollbar theme that always shows the scrollbars (if necessary).
  /// On mobile they are thin an non-interactive.
  static ScrollbarThemeData scrollbarTheme(BuildContext context) {
    if (context.isDesktopTargetPlatform) {
      // Always show scrollbars on desktop, if necessary
      return ScrollbarThemeData(
        thumbVisibility: MaterialStateProperty.all(true),
        trackVisibility: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.hovered)),
        interactive: true,
      );
    } else {
      // Always show scrollbars on mobile (but narrow and non-interactive),
      // if necessary
      return ScrollbarThemeData(
        thumbVisibility: MaterialStateProperty.all(true),
        thickness: MaterialStateProperty.all(4),
        radius: const Radius.circular(4),
        interactive: false,
      );
    }
  }

  /// Returns a [SnackBar] theme with colors from the given color scheme.
  static SnackBarThemeData snackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(actionTextColor: colorScheme.primaryContainer);
  }

  /// Returns a [Switch] theme with colors from the given color scheme.
  static SwitchThemeData switchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) =>
          states.contains(MaterialState.selected) ? colorScheme.primary : null),
      trackColor: MaterialStateProperty.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? colorScheme.inversePrimary
              : null),
    );
  }
}
