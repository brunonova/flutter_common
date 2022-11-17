// Copyright (c) 2022 Bruno Nova - MIT License
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';

import 'yaml_multi_asset_loader.dart';

/// Contains the [SharedPreferences] of the application and other global
/// properties.
/// Must call and await [App.init] in the main.
/// Must assign [App.navigatorKey] to the MaterialApp's navigatorKey.
class App {
  App._(); // no instantiation of this class

  /// Global key to be assigned to the MaterialApp's or GoRouter's navigatorKey,
  /// to allow accessing the context globally.
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// Shared preferences instance.
  static late final SharedPreferences prefs;

  /// Contains metadata about the application, like the version of the application.
  static late final PackageInfo packageInfo;

  /// Returns the global [BuildContext].
  static BuildContext? get context => navigatorKey.currentContext;

  /// Runs the application.
  ///
  /// The [builder] function should construct and return the application.
  ///
  /// The [supportedLocales] argument should contain the codes of the supported
  /// locales for EasyLocalization.
  ///
  /// The [fallbackLocale] argument can be used to set the fallback locale, if
  /// the user locale isn't supported.
  ///
  /// The [stringsPath] argument should be de path to the folder in the project
  /// that contains the translated strings.
  /// If you want to load the strings from multiple folders, pass the extra
  /// folders into [extraStringsPath] (defaults to the "assets/strings" folder
  /// in flutter_common).
  ///
  /// Set [useOnlyLangCode] to true to only use language codes (without country
  /// codes) in the locales.
  ///
  /// Set [saveLocale] to save the locale to the shared preferences when it's
  /// changed.
  ///
  /// Set [assetLoader] to change the asset loader for the translation files.
  /// Defaults to [YamlAssetLoader].
  ///
  /// You can also pass in [providers] providers for [MultiProvider].
  ///
  /// You can also pass a function in [extraInitialization] to run additional
  /// initialization code before running the application.
  static run({
    required Widget Function() builder,
    List<String> supportedLocales = const ["en"],
    String fallbackLocale = "en",
    String stringsPath = "assets/strings",
    List<String>? extraStringsPath = const [
      "packages/flutter_common/assets/strings"
    ],
    bool useOnlyLangCode = false,
    bool saveLocale = false,
    Size? minWindowSize = const Size(400, 400),
    Size? maxWindowSize,
    AssetLoader? assetLoader,
    void Function()? extraInitialization,
    List<SingleChildWidget>? providers,
  }) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Tamanho mínimo e máximo da janela no desktop, se fornecidos
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      if (minWindowSize != null) setWindowMinSize(minWindowSize);
      if (maxWindowSize != null) setWindowMaxSize(maxWindowSize);
    }

    final easyLocalizationFuture = EasyLocalization.ensureInitialized();
    final sharedPreferencesFuture = SharedPreferences.getInstance();
    final packageInfoFuture = PackageInfo.fromPlatform();

    await easyLocalizationFuture;
    packageInfo = await packageInfoFuture;
    prefs = await sharedPreferencesFuture;

    extraInitialization?.call();

    runApp(EasyLocalization(
      supportedLocales: [
        for (String locale in supportedLocales) locale.toLocale()
      ],
      useOnlyLangCode: useOnlyLangCode,
      saveLocale: saveLocale,
      path: stringsPath,
      fallbackLocale: fallbackLocale.toLocale(),
      assetLoader: assetLoader ??
          ((extraStringsPath != null && extraStringsPath.isNotEmpty)
              ? YamlMultiAssetLoader(extraStringsPath)
              : YamlAssetLoader()),
      child: (providers != null && providers.isNotEmpty)
          ? MultiProvider(
              providers: providers,
              builder: (_, __) => builder(),
            )
          : builder(),
    ));
  }
}
