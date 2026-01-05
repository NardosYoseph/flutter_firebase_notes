import 'package:flutter/material.dart';
import 'constants.dart';
import 'text_theme.dart'; // Your Constants file

class BButton {
  static ElevatedButtonThemeData theme(ColorScheme scheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        padding: Constants.paddingHorizontalMedium
            .add(Constants.paddingVerticalSmall),
        shape: const RoundedRectangleBorder(
          borderRadius: Constants.borderRadiusFull,
        ),
        textStyle: TextStyles.bodyMedium,
        elevation: Elevation.small,
      ),
    );
  }
}
