import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

const _expandedHeight = 100.0;

/// {@template picker_title_params}
/// Picker params that are related to the title.
///
/// See also:
///
/// * [DefaultPickerTitleParams], the default design params for the
/// picker title.
/// * [CustomPickerTitleParams], the customizeable params for the
/// picker title.
/// {@endtemplate}
sealed class PickerTitleParams {
  /// {@macro picker_title_params}
  const PickerTitleParams({
    this.showTitle = true,
    this.centerTitle = false,
    this.text,
    this.style,
    this.expandedHeight = _expandedHeight,
    this.customWidget,
    this.padding,
  }) : assert(
          (customWidget == null) != (text == null),
          'Only one of `customWidget` or `text` should be provided, '
          'for the PickerTitle widget, not both or neither.',
        );

  /// Whether to show the title.
  ///
  /// Defaults to `true`.
  final bool showTitle;

  /// The height of the title when expanded.
  ///
  /// Tip: If you're going to increase the size of the text,
  /// make sure to increase this property too to prevent overflow.
  ///
  /// Defaults to 100.
  final double expandedHeight;

  /// Whether the title is aligned at center.
  ///
  /// Defaults to `false`.
  final bool centerTitle;

  /// The text to be displayed in the title.
  final String? text;

  /// The text style of the title.
  ///
  /// Defaults to `Theme.of(context).textTheme.titleLarge`
  final TextStyle? style;

  /// By default the value of this property is:
  ///
  /// `EdgeInsetsDirectional.only(start: 55, bottom: 14)`
  ///
  /// if the title is not centered,
  ///
  /// `EdgeInsetsDirectional.only(start: 0, bottom: 16)` otherwise.
  final EdgeInsetsGeometry? padding;

  /// Overrides the widget provided by the package.
  final Widget? customWidget;
}

/// {@template default_picker_title_params}
/// Contains the default design params for the picker's items.
///
/// {@macro picker_title_params}
/// {@endtemplate}
class DefaultPickerTitleParams extends PickerTitleParams {
  /// {@macro default_picker_title_params}
  const DefaultPickerTitleParams({
    super.text = 'Select your country',
  });
}

/// {@template custom_picker_title_params}
/// Customizeable params for the picker's search bar.
///
/// {@macro picker_title_params}
/// {@endtemplate}
class CustomPickerTitleParams extends PickerTitleParams {
  /// {@macro custom_picker_title_params}
  const CustomPickerTitleParams({
    super.customWidget,
    super.centerTitle,
    super.showTitle,
    super.style,
    super.text,
    super.padding,
    super.expandedHeight,
  });
}

/// {@template picker_item}
/// Widget for picker's items.
/// {@endtemplate}
class PickerTitle extends StatelessWidget {
  /// {@macro picker_item}
  const PickerTitle({
    required this.pickerParams,
    this.params = const DefaultPickerTitleParams(),
    super.key,
  });

  /// {@macro picker_title_params}
  final PickerTitleParams params;

  /// {@macro picker_params}
  final PickerParams pickerParams;

  @override
  Widget build(BuildContext context) {
    if (!params.showTitle) return const SizedBox();

    final textTheme = Theme.of(context).textTheme;
    final style = params.style ?? textTheme.titleLarge;

    final padding = params.centerTitle
        ? const EdgeInsetsDirectional.only(bottom: 16)
        : const EdgeInsetsDirectional.only(start: 72, bottom: 16);

    return SliverAppBar(
      backgroundColor: pickerParams.backgroundColor,
      pinned: true,
      expandedHeight: params.expandedHeight,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: params.centerTitle,
        titlePadding: params.padding ?? padding,
        title: params.customWidget ??
            Text(
              params.text ?? '',
              style: style,
              maxLines: 1,
            ),
      ),
    );
  }
}
