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

  /// Padding around the actions of dialogs.
  static const dialogActionsPadding = EdgeInsets.fromLTRB(24, 0, 24, 4);

  /// Padding around the content of dialogs.
  static const dialogContentPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 12);

  /// Padding around the content of simple dialogs.
  static const simpleDialogContentPadding =
      EdgeInsets.symmetric(horizontal: 0, vertical: 12);
}
