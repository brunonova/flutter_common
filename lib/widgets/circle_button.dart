// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';

/// A circular button with an icon.
class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    this.onPressed,
    required this.icon,
    this.padding = 20.0,
    this.tooltip,
    this.color,
    this.backgroundColor,
  });

  /// Called when the button is pressed.
  final Function()? onPressed;

  /// The icon inside the button.
  final IconData icon;

  /// Padding of the icon.
  final double padding;

  /// Tooltip to show when hovering the mouse cursor over the button.
  final String? tooltip;

  /// Color of the icon.
  final Color? color;

  /// Background color of the button.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    var btn = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(padding),
        backgroundColor: backgroundColor,
      ),
      child: Icon(icon, color: color),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip,
        child: btn,
      );
    } else {
      return btn;
    }
  }
}
