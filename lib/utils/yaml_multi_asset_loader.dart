// Copyright (c) 2022 Bruno Nova - MIT License
import 'dart:developer';

import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter_common/material.dart';

/// A YAML asset loaded that can load assets from multiple extra folders.
class YamlMultiAssetLoader extends AssetLoader {
  YamlMultiAssetLoader(this.extraPaths);

  /// Extra folders to load assets from.
  final List<String> extraPaths;

  /// The normal [YamlAssetLoader].
  final _loader = YamlAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    Map<String, dynamic> map = {};

    // Load the extra paths
    for (var extraPath in extraPaths) {
      try {
        map.addAll(await _loader.load(extraPath, locale));
      } catch (e) {
        log("Error loading asset $extraPath for locale ${locale.toString()}!",
            error: e);
      }
    }

    // Load the normal path (loaded last so that, in case of conflicts, this one
    // has the highest priority).
    map.addAll(await _loader.load(path, locale));

    return map;
  }
}
