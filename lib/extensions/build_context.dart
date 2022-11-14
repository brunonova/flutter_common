// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Adds some useful things to [BuildContext].
extension ContextExtension on BuildContext {
  /// Returns the theme of this context.
  ThemeData get theme => Theme.of(this);

  /// Returns the theme's color scheme of this context.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns the navigator of this context.
  NavigatorState get navigator => Navigator.of(this);

  /// Returns the [GoRouter] of this context.
  GoRouter get router => GoRouter.of(this);

  /// Returns the scaffold messenger of this context.
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  /// Returns the MediaQuery of this context.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the [MaterialLocalizations] of this context.
  MaterialLocalizations get materialLocalizations =>
      MaterialLocalizations.of(this);

  /// Returns the current target platform.
  TargetPlatform get targetPlatform => Theme.of(this).platform;

  /// Returns the default asset bundle of this context.
  AssetBundle get assetBundle => DefaultAssetBundle.of(this);

  /// Returns whether the current target platform is a desktop platform.
  /// It can detect the OS even when running on the web.
  bool get isDesktopTargetPlatform {
    final platform = theme.platform;
    return platform == TargetPlatform.windows ||
        platform == TargetPlatform.linux ||
        platform == TargetPlatform.macOS;
  }

  /// Returns whether the current target platform is a mobile platform.
  /// It can detect the OS even when running on the web.
  bool get isMobileTargetPlatform {
    final platform = theme.platform;
    return platform == TargetPlatform.android ||
        platform == TargetPlatform.iOS ||
        platform == TargetPlatform.fuchsia;
  }

  /// Returns the path of the current page.
  String get currentLocation => router.location;

  /// Shows the given [snackBar].
  void showSnackBar(SnackBar snackBar) {
    scaffoldMessenger
        .hideCurrentSnackBar(); // dismiss the current snackbar, if any
    scaffoldMessenger.showSnackBar(snackBar);
  }

  /// Shows a snack bar with the given [message] and, optionally, with the
  /// given action button and during [duration] seconds.
  void showSnackBarMessage(
    String message, {
    String? actionLabel,
    void Function()? actionOnPressed,
    int duration = 4,
  }) {
    scaffoldMessenger
        .hideCurrentSnackBar(); // dismiss the current snackbar, if any
    SnackBarAction? action;
    if (actionLabel != null && actionOnPressed != null) {
      action = SnackBarAction(
        label: actionLabel,
        onPressed: actionOnPressed,
      );
    }

    showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
      action: action,
    ));
  }

  /// Shows a simple message dialog with a [message] and an optional [title],
  /// with a single OK button.
  Future<void> showMessageDialog(String message, {String? title}) async {
    await showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: (title != null) ? Text(title) : null,
        content: SingleChildScrollView(
          child: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: navigator.pop,
            child: const Text("ok").tr(),
          ),
        ],
      ),
    );
  }

  /// Shows a confirmation dialog with a [message] and an optional [title],
  /// with OK and Cancel buttons.
  ///
  /// Returns a [Future] with true value if the user accepted, or false if the
  /// user canceled.
  Future<bool> showConfirmDialog(String message, [String? title]) async {
    bool? result = await showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: (title != null) ? Text(title) : null,
        content: SingleChildScrollView(
          child: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () => navigator.pop(false),
            child: const Text("cancel").tr(),
          ),
          TextButton(
            onPressed: () => navigator.pop(true),
            child: const Text("ok").tr(),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Shows a dialog that allows the user to pick one of the given [options].
  /// Each entry in the map of [options] has a display name (the key) and a
  /// value.
  Future<T?> showOptionsDialog<T>(String title, Map<String, T> options) async {
    return await showDialog(
      context: this,
      builder: (context) => SimpleDialog(
        title: Text(title),
        children: [
          for (var entry in options.entries)
            SimpleDialogOption(
              onPressed: () => navigator.pop(entry.value),
              child: Text(entry.key),
            ),
        ],
      ),
    );
  }

  /// Shows a simple dialog that allows the user to pick one of the colors
  /// given in [options]. Eacth entry in the map of [options] has a value to
  /// return when selected (the key) and the respective color (the value).
  Future<T?> showSimpleColorPickerDialog<T>(
    String title,
    Map<T, Color> options,
  ) async {
    return await showDialog(
      context: this,
      builder: (context) => SimpleDialog(
        title: Text(title),
        children: [
          for (var entry in options.entries)
            SimpleDialogOption(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 24),
              onPressed: () => context.navigator.pop(entry.key),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: entry.value,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
