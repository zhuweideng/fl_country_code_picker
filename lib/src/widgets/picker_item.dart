import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

/// Signature for country code item custom widget builder.
typedef CountryCodeWidgetBuilder = Widget Function(
  BuildContext context,
  CountryCode code,
);

/// {@template picker_item_params}
/// Picker params that are related to each item of the list.
///
/// See also:
///
/// * [DefaultPickerItemParams], the default design params for the
/// picker item.
/// * [CustomPickerItemParams], the customizeable params for the
/// picker item.
/// {@endtemplate}
sealed class PickerItemParams {
  /// {@macro picker_item_params}
  const PickerItemParams({
    this.leadingParams = const DefaultItemLeadingParams(),
    this.bodyParams = const DefaultItemBodyParams(),
    this.trailingParams = const DefaultItemTrailingParams(),
    this.horizontalTitleGap,
    this.localize = true,
    this.builder,
    this.onTap,
  });

  /// Space between leading (flag), body (country name and dial code),
  /// and trailing (favorite icon).
  ///
  /// Defaults to 16.
  final double? horizontalTitleGap;

  /// {@template localize}
  /// An optional argument for localizing the country names based on
  /// device's current selected Language (country/region).
  ///
  /// Defaults to `true`.
  /// {@endtemplate}
  final bool localize;

  /// Overrides the provided widgets by the package and
  /// creates your own customized item widget display.
  final CountryCodeWidgetBuilder? builder;

  /// {@macro item_leading_params}
  final ItemLeadingParams leadingParams;

  /// {@macro item_body_params}
  final ItemBodyParams bodyParams;

  /// {@macro item_trailing_params}
  final ItemTrailingParams trailingParams;

  /// Callback when the item was tapped.
  ///
  /// Returns the [CountryCode] that was selected.
  final ValueChanged<CountryCode>? onTap;
}

/// {@template default_picker_item_params}
/// Contains the default design params for the picker's items.
///
/// {@macro picker_item_params}
/// {@endtemplate}
class DefaultPickerItemParams extends PickerItemParams {
  /// {@macro default_picker_item_params}
  const DefaultPickerItemParams();
}

/// {@template custom_picker_item_params}
/// Customizeable params for the picker's search bar.
///
/// {@macro picker_item_params}
/// {@endtemplate}
class CustomPickerItemParams extends PickerItemParams {
  /// {@macro custom_picker_item_params}
  const CustomPickerItemParams({
    super.bodyParams,
    super.builder,
    super.horizontalTitleGap,
    super.leadingParams,
    super.localize,
    super.onTap,
    super.trailingParams,
  });
}

/// {@template picker_item}
/// Widget for picker's items.
/// {@endtemplate}
class PickerItem extends StatelessWidget {
  /// {@macro picker_item}
  const PickerItem({
    required this.code,
    required this.favorites,
    this.params = const DefaultPickerItemParams(),
    super.key,
  });

  /// {@macro picker_item_params}
  final PickerItemParams params;

  /// {@macro favorite_countries}
  final List<String> favorites;

  /// {@macro code}
  final CountryCode code;

  @override
  Widget build(BuildContext context) {
    if (params.builder != null) return params.builder!(context, code);

    return ListTile(
      onTap: () {
        params.onTap?.call(code);
        Navigator.pop(context, code);
      },
      horizontalTitleGap: params.horizontalTitleGap,
      leading: ItemLeading(code: code, params: params.leadingParams),
      title: ItemBody(code: code, params: params.bodyParams),
      trailing: ItemTrailing(
        code: code,
        favorites: favorites,
        params: params.trailingParams,
      ),
    );
  }
}
