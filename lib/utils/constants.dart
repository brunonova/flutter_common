import 'package:flutter/material.dart';

/// Common constants.
class CommonConstants {
  CommonConstants._(); // no instantiation of this class

  /// Inset padding of dialogs.
  static const dialogInsetPadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 10,
  );

  /// Padding around the title of dialogs.
  static const dialogTitlePadding = EdgeInsets.fromLTRB(24, 12, 24, 0);

  /// Padding around the title of dialogs (with close button).
  static const dialogTitlePaddingWithCloseButton =
      EdgeInsets.fromLTRB(24, 12, 12, 0);

  /// Padding around the actions of dialogs.
  static const dialogActionsPadding = EdgeInsets.fromLTRB(24, 0, 24, 4);

  /// Padding around the content of dialogs.
  static const dialogContentPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 12);

  /// Padding around the content of dialogs (when inside a scroll view).
  static const dialogContentPaddingWithScroll =
      EdgeInsets.fromLTRB(24, 12, 0, 12);

  /// Padding around the scroll view of content of dialogs.
  static const dialogContentScrollPadding = EdgeInsets.only(right: 24);

  /// Padding around the content of simple dialogs.
  static const simpleDialogContentPadding =
      EdgeInsets.symmetric(horizontal: 0, vertical: 12);
}
