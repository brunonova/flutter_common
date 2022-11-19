// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';

import '../../extensions/build_context.dart';
import 'settings_theme.dart';
import 'abstract_settings_tile.dart';

/// A section in the settings list.
class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.tiles, this.title});

  /// Title of the section.
  final Widget? title;

  /// Settings tiles inside this section.
  final List<AbstractSettingsTile> tiles;

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
          itemCount: tiles.length,
          itemBuilder: (context, index) => tiles[index],
        ),
      ],
    );
  }
}
