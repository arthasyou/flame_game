import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('zh'),
    const Locale('zh', 'TW'),
  ];

  static String getFlag(Locale locale) {
    final code = locale.toString();
    switch (code) {
      case 'zh':
        return '🇨🇳';
      case 'zh_TW':
        return '🇭🇰';
      default:
        return '🇺🇸';
    }
  }
}
