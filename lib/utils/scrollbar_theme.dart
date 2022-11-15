// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';

import '../extensions/build_context.dart';

ScrollbarThemeData buildCommonScrollbarTheme(BuildContext context) {
  if (context.isDesktopTargetPlatform) {
    // Always show scrollbars on desktop, if necessary
    return ScrollbarThemeData(
      thumbVisibility: MaterialStateProperty.all(true),
      trackVisibility: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.hovered)),
      interactive: true,
    );
  } else {
    // Always show scrollbars on mobile (but narrow and not interactive),
    // if necessary
    return ScrollbarThemeData(
      thumbVisibility: MaterialStateProperty.all(true),
      thickness: MaterialStateProperty.all(4),
      radius: const Radius.circular(4),
      interactive: true,
    );
  }
}
