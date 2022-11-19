// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';

import 'abstract_settings_tile.dart';
import 'settings_theme.dart';
import 'settings_tile.dart';
import '../../extensions/build_context.dart';

/// A settings tile that shows a dialog with several options for the user to
/// choose.
///
/// The T type parameter is the type of the values that the choices return.
class ChoiceSettingsTile<T> extends AbstractSettingsTile {
  const ChoiceSettingsTile({
    super.key,
    required this.title,
    this.value,
    this.leading,
    this.trailing,
    required this.dialogTitle,
    required this.buildChoices,
    required this.onChosen,
  });

  /// Title of the title.
  final Widget title;

  /// Value or description shown below the title.
  final Widget? value;

  /// Widget to show on the left side of the tile, usually an icon.
  final Widget? leading;

  /// Widget to show on the right side of the tile.
  final Widget? trailing;

  /// The title of the dialog.
  final String dialogTitle;

  /// Function that returns the choices.
  ///
  /// It should return a map where the key is the display name of the choice and
  /// the value is the value that this choice returns.
  final Map<String, T> Function() buildChoices;

  /// Called when the user selects a choice.
  final void Function(T choice) onChosen;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      key: key,
      title: title,
      value: value,
      leading: leading,
      trailing: trailing,
      onPressed: () async {
        final theme = SettingsTheme.of(context);
        final choice = await context.showOptionsDialog(
            dialogTitle, buildChoices(),
            showCloseButton: theme?.showCloseButtonOnDialogs ?? false);
        if (choice != null) {
          onChosen(choice);
        }
      },
    );
  }
}
