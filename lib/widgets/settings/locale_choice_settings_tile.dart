// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../extensions/locale.dart';

import 'abstract_settings_tile.dart';
import 'choice_settings_tile.dart';

/// A settings tile that shows a dialog with all supported locales for the user
/// to choose.
class LocaleChoiceSettingsTile extends AbstractSettingsTile {
  const LocaleChoiceSettingsTile({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    required this.dialogTitle,
    required this.onChosen,
  });

  /// Title of the title.
  final Widget title;

  /// Widget to show on the left side of the tile, usually an icon.
  final Widget? leading;

  /// Widget to show on the right side of the tile.
  final Widget? trailing;

  /// The title of the dialog.
  final String dialogTitle;

  /// Called when the user choses a locale in the dialog.
  final void Function(Locale choice) onChosen;

  @override
  Widget build(BuildContext context) {
    return ChoiceSettingsTile<Locale>(
      key: key,
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
        var languages = localeMap.keys.toList()..sort((a, b) => a.compareTo(b));
        return {
          for (String language in languages) language: localeMap[language]!
        };
      },
      onChosen: onChosen,
    );
  }
}
