// Copyright (c) 2022 Bruno Nova - MIT License
import 'package:flutter/material.dart';

/// Add some useful things to [Locale].
extension LocaleTr on Locale {
  /// Returns the name of the locale in it's native language, if available.
  String get name =>
      _localeNames[toString()] ?? _localeNames[languageCode] ?? languageCode;
}

/// Map of locale names (in their native languages).
const _localeNames = {
  "en": "English",
  "pt": "Português",
  "pt_PT": "Português (Portugal)",
  "pt_BR": "Português (Brasil)",
};
