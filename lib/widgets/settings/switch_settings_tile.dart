// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';

import 'abstract_settings_tile.dart';
import 'settings_tile.dart';

/// A settings tile with an on/off switch.
class SwitchSettingsTile extends AbstractSettingsTile {
  const SwitchSettingsTile({
    super.key,
    required this.title,
    this.value,
    this.leading,
    required this.toggled,
    required this.onToggled,
  });

  /// Title of the title.
  final Widget title;

  /// Value or description shown below the title.
  final Widget? value;

  /// Widget to show on the left side of the tile, usually an icon.
  final Widget? leading;

  /// Whether the switch is on or off.
  ///
  /// Pressing the tile or the switch does not automatically change this value!
  /// That should be handled by [onToggled].
  final bool toggled;

  /// Callend when the tile or switch is pressed.
  final void Function() onToggled;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
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
  }
}
