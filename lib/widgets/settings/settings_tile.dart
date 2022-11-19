// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';

import '../../extensions/build_context.dart';
import 'abstract_settings_tile.dart';
import 'settings_theme.dart';

/// A tile for a setting in a section.
class SettingsTile extends AbstractSettingsTile {
  /// Creates a normal settings tile.
  const SettingsTile({
    super.key,
    required this.title,
    this.value,
    this.leading,
    this.trailing,
    this.onPressed,
  });

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
    final theme = SettingsTheme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            if (leading != null || (theme?.padLeft ?? false))
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
