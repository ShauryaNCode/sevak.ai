// lib/core/localization/app_localizations.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Placeholder localization delegate until generated ARB localizations are added.
class AppLocalizationsDelegate extends LocalizationsDelegate<Object> {
  /// Creates the placeholder localization delegate.
  const AppLocalizationsDelegate();

  /// Determines whether the locale is currently supported by the app shell.
  @override
  bool isSupported(Locale locale) {
    return _supportedLanguageCodes.contains(locale.languageCode);
  }

  /// Loads placeholder localization resources for the requested locale.
  @override
  Future<Object> load(Locale locale) {
    return SynchronousFuture<Object>(_PlaceholderAppLocalizations(locale));
  }

  /// Determines whether a reload is required when the delegate changes.
  @override
  bool shouldReload(covariant LocalizationsDelegate<Object> old) {
    return false;
  }

  static const Set<String> _supportedLanguageCodes = <String>{
    'en',
    'hi',
    'ta',
    'te',
    'bn',
    'mr',
  };
}

/// Placeholder localization object used until generated translations exist.
class _PlaceholderAppLocalizations {
  /// Creates the placeholder localization object.
  const _PlaceholderAppLocalizations(this.locale);

  /// Active locale associated with this placeholder localization.
  final Locale locale;
}
