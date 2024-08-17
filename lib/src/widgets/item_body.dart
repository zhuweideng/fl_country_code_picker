import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

/// {@template country_name_display}
/// The display configuration for the name of the country.
/// {@endtemplate}
enum CountryNameDisplay {
  /// Full name of the country. e.g. "Philippines"
  full,

  /// The 2-character code of the country. e.g. "PH"
  code,
}

/// {@template item_body_params}
/// An object that contains the parameters needed for
/// customizing the list item's *body* widget.
///
/// Contains the country name and dial code.
///
/// See also:
///
/// * [DefaultItemBodyParams], the default design params for the
/// body widget.
/// * [CustomItemBodyParams], the customizeable params for
/// the body widget.
/// {@endtemplate}
sealed class ItemBodyParams {
  /// {@macro item_body_params}
  const ItemBodyParams({
    this.nameDisplay = CountryNameDisplay.full,
    this.nameStyle,
    this.showDialCode = true,
    this.dialCodeStyle,
    this.localize = true,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  /// The display name of the country.
  final CountryNameDisplay nameDisplay;

  /// The text style for the country name.
  ///
  /// Defaults to `Theme.of(context).textTheme.labelLarge`.
  final TextStyle? nameStyle;

  /// {@macro localize}
  final bool localize;

  /// Whether to show the country's dial code.
  final bool showDialCode;

  /// The text style for the country's dial code, if shown.
  ///
  /// Defaults to `Theme.of(context).textTheme.labelLarge`.
  final TextStyle? dialCodeStyle;

  /// The alignment of country name and country dial code.
  final MainAxisAlignment mainAxisAlignment;
}

/// {@template default_item_body_params}
/// Contains the default design params for the body widget.
///
/// {@macro item_body_params}
/// {@endtemplate}
class DefaultItemBodyParams extends ItemBodyParams {
  /// {@macro default_item_body_params}
  const DefaultItemBodyParams();
}

/// {@template custom_item_body_params}
/// Customizeable params for the body widget.
///
/// {@macro item_body_params}
/// {@endtemplate}
class CustomItemBodyParams extends ItemBodyParams {
  /// {@macro custom_item_body_params}
  const CustomItemBodyParams({
    super.nameDisplay,
    super.nameStyle,
    super.dialCodeStyle,
    super.showDialCode,
    super.localize,
  });
}

/// {@template item_body}
/// Widget for list item's body.
/// {@endtemplate}
class ItemBody extends StatelessWidget {
  /// {@macro item_body}
  const ItemBody({
    required this.code,
    this.params = const DefaultItemBodyParams(),
    super.key,
  });

  /// {@macro code}
  final CountryCode code;

  /// {@macro item_body_params}
  final ItemBodyParams params;

  @override
  Widget build(BuildContext context) {
    final name = switch (params.nameDisplay) {
      CountryNameDisplay.full =>
        params.localize ? code.localize(context).name : code.name,
      CountryNameDisplay.code => code.code,
    };

    final textTheme = Theme.of(context).textTheme;
    final nameStyle = params.nameStyle ?? textTheme.labelLarge;
    final dialCodeStyle = params.dialCodeStyle ?? textTheme.labelLarge;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: nameStyle),
        Text(code.dialCode, style: dialCodeStyle),
      ],
    );
  }
}
