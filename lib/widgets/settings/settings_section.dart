// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';

import '../../extensions/build_context.dart';
import 'settings_theme.dart';
import 'settings_tile.dart';

/// A section in the settings list.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.options, this.title});

  /// Title of the section.
  final Widget? title;

  /// Options inside this section.
  final List<SettingsTile> options;

  @override
  Widget build(BuildContext context) {
    final theme = SettingsTheme.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 10,
              left: theme.padLeft ? 72 : 24,
              right: 24,
            ),
            child: DefaultTextStyle(
              style: TextStyle(color: context.colorScheme.primary),
              child: title!,
            ),
          ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length,
          itemBuilder: (context, index) => options[index],
        ),
      ],
    );
  }
}
