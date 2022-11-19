// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../extensions/build_context.dart';
import '../../utils/constants.dart';
import '../dialog_title_close_button.dart';
import 'abstract_settings_tile.dart';
import 'settings_theme.dart';
import 'settings_tile.dart';

/// A settings tile that shows a dialog allowing the user to choose between
/// several color schemes.
class ColorSchemeChoiceSettingsTile extends AbstractSettingsTile {
  const ColorSchemeChoiceSettingsTile({
    super.key,
    required this.title,
    this.value,
    this.leading,
    this.trailing,
    required this.dialogTitle,
    required this.buildChoices,
    required this.onChosen,
    this.displayColorNames = true,
    this.translationStringPrefix = "color",
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

  /// A function that returns the possible color choices.
  ///
  /// It should return a map where the key is the key of the color (to be saved
  /// in preferences and to serve as translation key alongside
  /// [translationStringPrefix]) and the value is the color that this choice
  /// returns to serve as the seed of a color scheme.
  final Map<String, MaterialColor> Function() buildChoices;

  /// Called when the user chooses a color scheme from the dialog.
  final void Function(String choice) onChosen;

  /// If true (the default), the names of the colors will be displayed in the
  /// choices.
  /// Each color will be translated using
  /// "&lt;translationStringPrefix&gt;.&lt;map key&gt;" as translation key.
  final bool displayColorNames;

  /// The prefix (without the final dot) for the translation keys of the
  /// colors. The flutter_common project has translations for several colors
  /// for a limited number of languages, with the prefix "color".
  final String translationStringPrefix;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      key: key,
      title: title,
      value: value,
      leading: leading,
      trailing: trailing,
      onPressed: () async {
        // Get the color schemes for all color choices
        final schemesMap = buildChoices().map((key, value) => MapEntry(
            key,
            ColorScheme.fromSeed(
              seedColor: value,
              brightness: context.theme.brightness,
            )));

        final theme = SettingsTheme.of(context);
        bool showCloseButton = theme?.showCloseButtonOnDialogs ?? false;

        // Show the color picker dialog
        final choice = await showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: DialogTitleWithCloseButton(
              title: Text(dialogTitle),
              showCloseButton: showCloseButton,
            ),
            insetPadding: CommonConstants.dialogInsetPadding,
            titlePadding: showCloseButton
                ? CommonConstants.dialogTitlePaddingWithCloseButton
                : CommonConstants.dialogTitlePadding,
            contentPadding: CommonConstants.simpleDialogContentPadding,
            children: [
              for (var entry in schemesMap.entries)
                SimpleDialogOption(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 24),
                  onPressed: () => context.navigator.pop(entry.key),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: entry.value.primaryContainer,
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Text(
                      displayColorNames
                          ? "$translationStringPrefix.${entry.key}".tr()
                          : "",
                      style: TextStyle(color: entry.value.primary),
                    ),
                  ),
                ),
            ],
          ),
        );
        if (choice != null) {
          onChosen(choice);
        }
      },
    );
  }
}
