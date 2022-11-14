// Copyright (c) 2022 Bruno Nova - MIT License
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Some useful platform methods.
class PlatformUtils {
  PlatformUtils._(); // no instantiation of this class

  /// Returns whether the current platform is a desktop platform.
  /// Returns false on the web.
  static bool get isDesktop =>
      !isWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

  /// Returns whether the current platform is a mobile platform.
  /// Returns false on the web.
  static bool get isMobile =>
      !isWeb && (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia);

  /// Returns true if running on the web.
  static bool get isWeb => kIsWeb;
}
