import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import '../utils/common_theme.dart';
import '../utils/platform_utils.dart';
import '../utils/scroll_behavior.dart';

/// Simplifies the creation of a [MaterialApp] with router, filling several
/// common properties.
class CommonMaterialApp extends StatelessWidget {
  const CommonMaterialApp(
      {super.key,
      required this.appNameStringKey,
      required this.seedColor,
      this.onGenerateTitle,
      this.themeMode,
      this.scrollBehavior,
      this.buildTheme,
      this.buildLightTheme,
      this.buildDarkTheme,
      required this.routerConfig});

  /// Key of the string with the application name, which will be translated by
  /// Easy Localization.
  final String appNameStringKey;

  /// Color that serves as the seed for the color scheme.
  final MaterialColor seedColor;

  /// Function that returns the application's title. By default returns the key
  /// [appNameStringKey] translated and also sets the window title on the
  /// desktop.
  final String Function(BuildContext context)? onGenerateTitle;

  /// Whether to use the light or dark theme. Defaults to the system mode.
  final ThemeMode? themeMode;

  /// The behavior of scrollable widgets. By default [CommonScrollBehavior] is
  /// used, which adds scrollbars to all scrollable widgets on platforms.
  final ScrollBehavior? scrollBehavior;

  /// Function to build the theme (light or dark).
  /// By default builds a theme based on the color scheme,
  ///
  /// When [lightTheme] is true the function should return the light theme.
  /// When false it should return the dark theme.
  ///
  /// This function is an alternative to setting both [buildLightTheme] and
  /// [buildDarkTheme] functions.
  final ThemeData Function(
          BuildContext context, ColorScheme colorScheme, bool lightTheme)?
      buildTheme;

  /// Function to build the light theme. By default builds a theme based on the
  /// color scheme.
  ///
  /// This function and [buildDarkTheme] are an alternative to setting the
  /// [buildTheme].
  final ThemeData Function(BuildContext context, ColorScheme colorScheme)?
      buildLightTheme;

  /// Function to build the dark theme. By default builds a theme based on the
  /// color scheme.
  ///
  /// This function and [buildLightTheme] are an alternative to setting the
  /// [buildTheme].
  final ThemeData Function(BuildContext context, ColorScheme colorScheme)?
      buildDarkTheme;

  /// Configuration of the router.
  ///
  /// It should be a final variable declared outside of widgets, so that a hot
  /// reload during development doesn't reset to the home page.
  /// Modifying the router will require a restart, however!
  final RouterConfig<Object> routerConfig;

  @override
  Widget build(BuildContext context) {
    // Light color scheme
    final lightColorScheme = ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: seedColor,
    );

    // Dark color scheme
    final darkColorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: seedColor,
    );

    return MaterialApp.router(
      onGenerateTitle: onGenerateTitle ??
          (context) {
            final title = appNameStringKey.tr();
            // Set window title on desktop platforms
            if (PlatformUtils.isDesktop) {
              setWindowTitle(title);
            }
            return title;
          },
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      themeMode: themeMode,
      scrollBehavior: scrollBehavior ?? CommonScrollBehavior(),
      theme: buildLightTheme?.call(context, lightColorScheme) ??
          buildTheme?.call(context, lightColorScheme, true) ??
          _buildTheme(context, lightColorScheme),
      darkTheme: buildDarkTheme?.call(context, darkColorScheme) ??
          buildTheme?.call(context, darkColorScheme, false) ??
          _buildTheme(context, darkColorScheme),
      routerConfig: routerConfig,
    );
  }

  /// Builds the default theme.
  ThemeData _buildTheme(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    return CommonTheme.themeData(
      context: context,
      colorScheme: colorScheme,
    );
  }
}
