// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:fl_country_code_picker/src/constants.dart';
import 'package:flutter/material.dart';

/// {@template item_trailing_params}
/// An object that contains the parameters needed for
/// customizing the list item's *trailing* widget.
///
/// Most likely to be used for showing favorite icons.
///
/// See also:
///
/// * [DefaultItemTrailingParams], the default design params for the
/// trailing widget.
/// * [CustomItemTrailingParams], the customizeable params for
/// the trailing widget.
/// {@endtemplate}
sealed class ItemTrailingParams {
  const ItemTrailingParams({
    this.alignment = Alignment.center,
    this.clearance = 24,
    this.icon = kFavoritesIcon,
    this.showDialCode = true,
    this.dialCodeStyle,
  });

  /// Icon of list item's trailing widget. <i class="material-icons md-36">favorite</i> &#x2014;
  /// - `IconData` defaults to `Icons.favorite`.
  /// - Width defaults to 24 for accessibility.
  /// - Color defaults to red.
  ///
  /// https://m3.material.io/styles/icons/applying-icons#c6fb36c3-0e79-41f2-8682-82aa55baee5e
  final Icon icon;

  /// Clearance is the spacing allowed for the icon.
  ///
  /// Defaults to 24.
  ///
  /// https://m3.material.io/styles/icons/applying-icons#c6fb36c3-0e79-41f2-8682-82aa55baee5e
  final double clearance;

  /// Custom alignment of the icon inside the trailing's clearance.
  final AlignmentGeometry alignment;

  /// Whether to show the country's dial code.
  final bool showDialCode;

  /// The text style for the country's dial code, if shown.
  final TextStyle? dialCodeStyle;
}

/// Contains the default design params for the trailing widget.
///
/// {@macro item_trailing_params}
class DefaultItemTrailingParams extends ItemTrailingParams {
  const DefaultItemTrailingParams();
}

/// Customizeable params for the trailing widget.
///
/// {@macro item_trailing_params}
class CustomItemTrailingParams extends ItemTrailingParams {
  const CustomItemTrailingParams({
    super.icon,
    super.clearance,
    super.alignment,
    super.showDialCode,
    super.dialCodeStyle,
  });
}

class ItemTrailing extends StatelessWidget {
  const ItemTrailing({
    required this.code,
    required this.favorites,
    this.params = const DefaultItemTrailingParams(),
    super.key,
  });

  /// {@macro code}
  final CountryCode code;

  /// {@macro item_trailing_params}
  final ItemTrailingParams params;

  /// Item trailing widget depends on this list of `favorites`.
  ///
  /// If the list is empty, it will not render or consume any space
  /// for the icon.
  ///
  /// {@macro favorite_countries}
  final List<String> favorites;

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const SizedBox();
    }

    final index = favorites.indexWhere(
      (f) => f.toLowerCase() == code.code.toLowerCase(),
    );

    return Container(
      alignment: params.alignment,
      width: params.clearance,
      child: index != -1 ? params.icon : null,
    );
  }
}
