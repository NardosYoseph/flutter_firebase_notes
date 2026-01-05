import 'package:flutter/material.dart';

class TTabBar {
  static TabBarTheme theme(ColorScheme scheme) {
    return TabBarTheme(
      labelColor: scheme.primary,
      unselectedLabelColor: scheme.onSurfaceVariant,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: scheme.primary,
          width: 2,
        ),
      ),
      overlayColor: MaterialStatePropertyAll(
        scheme.primary.withOpacity(0.08),
      ),
      dividerColor: scheme.outlineVariant,
    );
  }
}
