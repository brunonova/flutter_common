// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';

import 'settings_section.dart';
import 'settings_theme.dart';

/// Displays a list of settings.
class SettingsList extends StatelessWidget {
  const SettingsList({
    super.key,
    required this.sections,
    this.showDividers = true,
    this.padLeft = false,
    this.scrollController,
  });

  /// The sections of settings.
  final List<SettingsSection> sections;

  /// Show dividers between sections?
  final bool showDividers;

  /// Whether to pad section titles and tiles that don't have a leading widget,
  /// to align them with the Scaffold's title (on small screens.)
  final bool padLeft;

  /// Optional [ScrollController] for the [ListView].
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return SettingsTheme(
      padLeft: padLeft,
      child: ListView.builder(
        controller: scrollController,
        itemCount: sections.length,
        itemBuilder: (context, index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Additional top padding on the first item
            if (index == 0) const SizedBox(height: 14),
            // Divider between items
            if (showDividers && index > 0) const Divider(),
            // The item itself
            sections[index],
          ],
        ),
      ),
    );
  }
}
