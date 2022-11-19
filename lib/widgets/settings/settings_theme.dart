// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';

/// Constains parameters to be used by all settings widget.
class SettingsTheme extends InheritedWidget {
  const SettingsTheme({
    super.key,
    required super.child,
    this.padLeft = false,
    this.showCloseButtonOnDialogs = false,
  });

  /// Whether to pad section titles and tiles that don't have a leading widget,
  /// to align them with the Scaffold's title (on small screens.)
  final bool padLeft;

  /// Whether to show a close button on dialogs.
  final bool showCloseButtonOnDialogs;

  /// Returns the [SettingsTheme] of the given context.
  static SettingsTheme? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SettingsTheme>();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
