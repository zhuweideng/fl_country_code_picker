import 'package:fl_country_code_picker/src/constants.dart';
import 'package:flutter/material.dart';

const _minHeight = 200.0;
const _maxHeight = 600.0;
const _maxWidth = 300.0;

/// {@template picker_params}
/// Picker params that are related to the picker itself.
///
/// See also:
///
/// * [DefaultPickerParams], the default design params for the
/// picker.
/// * [CustomPickerParams], the customizeable params for the
/// picker.
/// {@endtemplate}
sealed class PickerParams {
  /// {@macro picker_params}
  const PickerParams({
    this.fullScreen = false,
    this.localized = true,
    this.shape = kShape,
    this.minHeight = _minHeight,
    this.maxHeight = _maxHeight,
    this.width = _maxWidth,
    this.initialSelectedCountry,
    this.scrollToDeviceCurrentLocale = false,
    this.barrierColor = kBarrierColor,
    this.backgroundColor,
  });

  /// Whether the modal is shown in full screen.
  ///
  /// Defaults to `false`.
  final bool fullScreen;

  /// Whether the picker will show a localized version of countries' name.
  ///
  /// Defaults to `true`.
  final bool localized;

  /// Shape of the modal to be shown.
  ///
  /// Defaults to a `RoundedRectangleBorder`.
  final ShapeBorder shape;

  /// Minimum allowed height of the picker.
  ///
  /// Defaults to `200` for accessibility.
  final double minHeight;

  /// Maximum allowed height of the picker.
  ///
  /// Defaults to `600`.
  final double maxHeight;

  /// Width of the picker to be shown if the platform is web or desktop.
  ///
  /// Defaults to `300`.
  final double width;

  /// An optional initial selected country where the picker
  /// will scroll to.
  ///
  /// This takes precedence to `scrollToDeviceCurrentLocale` if given.
  final String? initialSelectedCountry;

  /// Whether the picker should automatically scroll to device's
  /// current locale.
  ///
  /// To properly implement this feature in terms of *ux*,
  /// always check if the user has already selected a country.
  /// If present, set it to `false`. If not already, meaning no country
  /// is currently selected or this is the first time the user is opening
  /// the picker, set it to `true`.
  final bool scrollToDeviceCurrentLocale;

  /// Barrier or simply the color of the picker's back-drop. This is different
  /// from the background, which contains the actual contents of the picker.
  ///
  /// Defaults to `Color(0x50000000)`.
  final Color barrierColor;

  /// The background color of the picker.
  ///
  /// To adapt to system's theme, we encourage you to use your context's color.
  ///
  /// Example: `Theme.of(context).scaffoldBackgroundColor`.
  final Color? backgroundColor;
}

/// {@template default_picker_params}
/// Contains the default design params for the picker.
///
/// {@macro picker_params}
/// {@endtemplate}
class DefaultPickerParams extends PickerParams {
  /// {@macro default_picker_params}
  const DefaultPickerParams();
}

/// {@template custom_picker_params}
/// Customizeable params for the picker.
///
/// {@macro picker_params}
/// {@endtemplate}
class CustomPickerParams extends PickerParams {
  /// {@macro custom_picker_params}
  const CustomPickerParams({
    super.backgroundColor,
    super.barrierColor,
    super.fullScreen,
    super.initialSelectedCountry,
    super.localized,
    super.maxHeight,
    super.minHeight,
    super.scrollToDeviceCurrentLocale,
    super.shape,
    super.width,
  });
}
