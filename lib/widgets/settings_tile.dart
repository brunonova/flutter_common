// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_common/utils/constants.dart';

import '../extensions/build_context.dart';
import '../extensions/locale.dart';
import 'settings_theme.dart';

/// A tile for a setting in a section.
class SettingsTile extends StatelessWidget {
  /// Creates a normal settings tile.
  // ignore: prefer_const_constructors_in_immutables
  const SettingsTile({
    super.key,
    required this.title,
    this.value,
    this.leading,
    this.trailing,
    this.onPressed,
  });

  /// Creates a settings tile with an on/off switch.
  ///
  /// [toggled] sets whether the switch is on or off.
  /// [onToggled] is called when the tile is pressed.
  factory SettingsTile.toggle({
    Key? key,
    required Widget title,
    Widget? value,
    Widget? leading,
    required bool toggled,
    required void Function() onToggled,
  }) =>
      SettingsTile(
        key: key,
        title: title,
        value: value,
        leading: leading,
        onPressed: onToggled,
        trailing: AbsorbPointer(
          child: Switch(
            value: toggled,
            onChanged: (_) {},
          ),
        ),
      );

  /// Creates a settings tile that shows a dialog with several options for the
  /// user to choose.
  ///
  /// Pass the title of the dialog in [dialogTitle], the possible choices as the
  /// return value of [buildChoices] function, and the callback to execute when
  /// the user selects a choice in [onChosen] (which receives the chosen
  /// option).
  ///
  /// The [buildChoices] function should return a map where the key is the
  /// display name of the choice and the value is the value that this choice
  /// returns.
  static SettingsTile choice<T>({
    Key? key,
    required BuildContext context,
    required Widget title,
    Widget? value,
    Widget? leading,
    Widget? trailing,
    required String dialogTitle,
    required Map<String, T> Function() buildChoices,
    required void Function(T choice) onChosen,
  }) =>
      SettingsTile(
        key: key,
        title: title,
        value: value,
        leading: leading,
        trailing: trailing,
        onPressed: () async {
          final choice =
              await context.showOptionsDialog(dialogTitle, buildChoices());
          if (choice != null) {
            onChosen(choice);
          }
        },
      );

  /// Creates a settings tile that shows a dialog with all supported locales for
  /// the user to choose.
  ///
  /// Pass the title of the dialog in [dialogTitle], and the callback to execute
  /// when the user selects a locale in [onChosen] (which receives the chosen
  /// locale).
  static SettingsTile localeChoice({
    Key? key,
    required BuildContext context,
    required Widget title,
    Widget? leading,
    Widget? trailing,
    required String dialogTitle,
    required void Function(Locale choice) onChosen,
  }) =>
      SettingsTile.choice<Locale>(
        key: key,
        context: context,
        title: title,
        value: Text(context.locale.name),
        leading: leading,
        trailing: trailing,
        dialogTitle: dialogTitle,
        buildChoices: () {
          var localeMap = {
            for (Locale locale in context.supportedLocales) locale.name: locale
          };

          // Sort the map
          var languages = localeMap.keys.toList()
            ..sort((a, b) => a.compareTo(b));
          return {
            for (String language in languages) language: localeMap[language]!
          };
        },
        onChosen: onChosen,
      );

  /// Creates a settings tile that shows a dialog allowing the user to choose
  /// between several color schemes.
  ///
  /// Pass the title of the dialog in [dialogTitle], the possible choices as the
  /// return value of [buildChoices] function, and the callback to execute
  /// when the user selects a color scheme in [onChosen] (which receives the
  /// chosen color).
  ///
  /// The [buildChoices] function should return a map where the key is the
  /// key of the color (to be saved in preferences and to serve as translation
  /// key alongside [translationStringPrefix]) and the value is the color that
  /// this choice returns to serve as the seed of a color scheme.
  ///
  /// To display the names of the colors in the choices set [displayColorNames]
  /// to true, and change [translationStringPrefix] if necessary (defaults to
  /// "color").
  /// Each color will be translated using
  /// "&lt;translationStringPrefix&gt;.&lt;map key&gt;" as translation key.
  static SettingsTile colorSchemeChoice({
    Key? key,
    required BuildContext context,
    required Widget title,
    Widget? value,
    Widget? leading,
    Widget? trailing,
    required String dialogTitle,
    required Map<String, MaterialColor> Function() buildChoices,
    required void Function(String choice) onChosen,
    bool displayColorNames = false,
    String translationStringPrefix = "color",
  }) =>
      SettingsTile(
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

          // Show the color picker dialog
          final choice = await showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: Text(dialogTitle),
              insetPadding: CommonConstants.dialogInsetPadding,
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
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

  /// Title of the title.
  final Widget title;

  /// Value or description shown below the title.
  final Widget? value;

  /// Widget to show on the left side of the tile, usually an icon.
  final Widget? leading;

  /// Widget to show on the right side of the tile.
  final Widget? trailing;

  /// Callback to execute when the tile is pressed.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = SettingsTheme.of(context)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            if (leading != null || theme.padLeft)
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: leading ?? const SizedBox(width: 24),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 19,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 18,
                        color: context.colorScheme.onSurface,
                      ),
                      child: title,
                    ),
                    if (value != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                          child: value!,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: trailing,
              ),
          ],
        ),
      ),
    );
  }
}
