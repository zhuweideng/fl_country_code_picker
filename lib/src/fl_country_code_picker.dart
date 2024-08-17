import 'dart:io';
import 'dart:ui' as ui;

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// {@template fl_country_code_picker}
/// A Flutter package for showing a modal that contains country dial code.
///
/// The user can also search for the available codes and
/// select right from the modal.
/// {@endtemplate}
class FlCountryCodePicker {
  /// {@macro fl_country_code_picker}
  // const FlCountryCodePicker({
  //   this.filteredCountries = const [],
  // });
  const FlCountryCodePicker._();

  /// Gets the current instance of the class.
  ///
  /// Creates new instance if `null`.
  factory FlCountryCodePicker.getInstance() {
    if (_instance != null) return _instance!;
    _instance = const FlCountryCodePicker._();
    return _instance!;
  }

  /// Initializes the configs for the picker.
  static void initalize({
    PickerParams pickerParams = const DefaultPickerParams(),
    PickerItemParams pickerItemParams = const DefaultPickerItemParams(),
    PickerSearchParams pickerSearchParams = const DefaultPickerSearchParams(),
    PickerTitleParams pickerTitleParams = const DefaultPickerTitleParams(),
  }) {
    _instance = const FlCountryCodePicker._();
    _pickerParams = pickerParams;
    _pickerItemParams = pickerItemParams;
    _pickerSearchParams = pickerSearchParams;
    _pickerTitleParams = pickerTitleParams;
  }

  static FlCountryCodePicker? _instance;

  /// Convenient getter for all of the available country codes.
  static List<CountryCode> get countryCodes => List<CountryCode>.from(
        codes.map<CountryCode>(CountryCode.fromMap),
      );

  static PickerParams _pickerParams = const DefaultPickerParams();
  static PickerItemParams _pickerItemParams = const DefaultPickerItemParams();
  static PickerSearchParams _pickerSearchParams =
      const DefaultPickerSearchParams();
  static PickerTitleParams _pickerTitleParams =
      const DefaultPickerTitleParams();

  /// {@template filtered_countries}
  /// Filters all of the [CountryCode]s available and only show the codes that
  /// are existing in this list.
  /// {@endtemplate}
  static List<String>? _filtered;

  /// Sets the list of filtered countries.
  static set filteredCountries(List<String> countries) {
    _filtered = countries;
  }

  /// Gets all of the filtered countries.
  ///
  /// {@macro filtered_countries}
  static List<String> get filteredCountries => _filtered ?? const [];

  /// {@template favorite_countries}
  /// Marks all of the supported countries as favorite that can be
  /// found from this list. To show the favorite indicator, provide the value of
  /// [ItemBodyParams] from [PickerItemParams].
  /// {@endtemplate}
  static List<String>? _favorites;

  /// Sets the list of favorite countries.
  static set favoriteCountries(List<String> countries) {
    _favorites = countries;
  }

  /// Gets all of the favorite countries.
  ///
  /// {@macro favorite_countries}
  static List<String> get favoriteCountries => _favorites ?? const [];

  /// Shows the [CountryCodePickerModal] bottom sheet for mobile and
  /// modal for web and desktop.
  ///
  /// Returns the selected [CountryCode].
  static Future<CountryCode?> showPicker({
    required BuildContext context,
  }) async {
    final fullScreenHeight = MediaQuery.of(context).size.height;
    final allowance = MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    // Dynamic modal height computation.
    final maxHeight = _pickerParams.fullScreen
        ? fullScreenHeight - allowance
        : _pickerParams.maxHeight;

    final constraints = BoxConstraints(
      maxHeight: maxHeight,
      minHeight: _pickerParams.minHeight,
    );

    // For automatic scrolling.
    final deviceLocale = ui.PlatformDispatcher.instance.locale.countryCode;

    String? focusedCountry;
    if (_pickerParams.scrollToDeviceCurrentLocale) {
      if (_codeIsSupported(deviceLocale)) {
        focusedCountry = deviceLocale;
      }
    } else {
      if (_codeIsSupported(_pickerParams.initialSelectedCountry)) {
        focusedCountry = _pickerParams.initialSelectedCountry;
      }
    }

    if (Platform.isAndroid || Platform.isIOS) {
      return showModalBottomSheet<CountryCode?>(
        elevation: 0,
        shape: _pickerParams.shape,
        context: context,
        useSafeArea: true,
        constraints: constraints,
        barrierColor: _pickerParams.barrierColor,
        backgroundColor: _pickerParams.backgroundColor,
        isScrollControlled: true,
        builder: (_) => CountryCodePickerModal(
          filteredCountries: filteredCountries,
          favoriteCountries: favoriteCountries,
          focusedCountry: focusedCountry,
          localized: _pickerParams.localized,
          pickerParams: _pickerParams,
          pickerItemParams: _pickerItemParams,
          pickerSearchParams: _pickerSearchParams,
          pickerTitleParams: _pickerTitleParams,
        ),
      );
    }

    return showDialog(
      context: context,
      barrierColor: _pickerParams.barrierColor,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (_) => Dialog(
        elevation: 1,
        shape: _pickerParams.shape,
        alignment: Alignment.center,
        child: SizedBox(
          width: _pickerParams.width,
          height: _pickerParams.maxHeight,
          child: CountryCodePickerModal(
            filteredCountries: filteredCountries,
            favoriteCountries: favoriteCountries,
            focusedCountry: focusedCountry,
            localized: _pickerParams.localized,
            pickerParams: _pickerParams,
            pickerItemParams: _pickerItemParams,
            pickerSearchParams: _pickerSearchParams,
            pickerTitleParams: _pickerTitleParams,
          ),
        ),
      ),
    );
  }

  static bool _codeIsSupported(String? code) {
    if (code == null) return false;
    final allCountryCodes = codes.map(CountryCode.fromMap).toList();
    final index = allCountryCodes.indexWhere((c) => c.code == code);
    if (index == -1) return false;
    return true;
  }
}
