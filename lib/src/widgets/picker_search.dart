import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:fl_country_code_picker/src/constants.dart';
import 'package:flutter/material.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16, vertical: 4);

/// {@template picker_search_params}
/// Picker params that are related to search bar.
///
/// See also:
///
/// * [DefaultPickerSearchParams], the default design params for the
/// picker search bar.
/// * [CustomPickerSearchParams], the customizeable params for the
/// picker search bar.
/// {@endtemplate}
abstract class PickerSearchParams {
  const PickerSearchParams({
    this.padding = _padding,
    this.decoration = kInputDecoration,
    this.showSearch = false,
    this.style,
    this.widget,
    this.onChanged,
    this.height,
  });

  /// Custom padding for the search bar's text content.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 16, vertical: 4)`.
  final EdgeInsetsGeometry padding;

  /// Custom decoration for the search bar.
  final InputDecoration? decoration;

  /// Whether to show the search bar.
  ///
  /// Defaults to `false`.
  final bool showSearch;

  /// Height of the search bar.
  ///
  /// Defaults to device's tool bar height.
  final double? height;

  /// The text style for the search.
  ///
  /// Defaults to `Theme.of(context).textTheme.bodyLarge`
  final TextStyle? style;

  /// Overrides the widget provided by the package.
  final Widget? widget;

  /// Called when the user initiates a change to the TextField's value:
  /// when they have inserted or deleted text.
  final ValueChanged<String>? onChanged;
}

/// {@template default_picker_search_params}
/// Contains the default design params for the picker's search bar.
///
/// {@macro picker_search_params}
/// {@endtemplate}
class DefaultPickerSearchParams extends PickerSearchParams {
  /// {@macro default_picker_search_params}
  const DefaultPickerSearchParams();
}

/// {@template custom_picker_search_params}
/// Customizeable params for the picker's search bar.
///
/// {@macro picker_search_params}
/// {@endtemplate}
class CustomPickerSearchParams extends PickerSearchParams {
  /// {@macro custom_picker_search_params}
  const CustomPickerSearchParams({
    super.widget,
    super.decoration,
    super.onChanged,
    super.padding,
    super.showSearch,
    super.style,
  });
}

/// {@template picker_search}
/// Widget for picker's search bar.
/// {@endtemplate}
class PickerSearch extends StatelessWidget {
  /// {@macro picker_search}
  const PickerSearch({
    required this.pickerParams,
    super.key,
    this.params = const DefaultPickerSearchParams(),
    this.onChanged,
  });

  /// {@macro picker_params}
  final PickerParams pickerParams;

  /// {@macro picker_search_params}
  final PickerSearchParams params;

  /// Called when the user initiates a change to the TextField's value:
  /// when they have inserted or deleted text.
  final ValueSetter<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (!params.showSearch) return const SliverToBoxAdapter(child: SizedBox());
    if (params.widget != null) return params.widget!;

    final backgroundColor = pickerParams.backgroundColor ??
        Theme.of(context).scaffoldBackgroundColor;

    return SliverPersistentHeader(
      pinned: true,
      delegate: _StickySearchBarDelegate(
        height: params.height ?? kToolbarHeight,
        backgroundColor: backgroundColor,
        searchBar: Padding(
          padding: params.padding,
          child: TextField(
            onChanged: (v) {
              onChanged?.call(v);
              params.onChanged?.call(v);
            },
            decoration: params.decoration ?? kInputDecoration,
            keyboardType: TextInputType.text,
            style: params.style,
          ),
        ),
      ),
    );
  }
}

class _StickySearchBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickySearchBarDelegate({
    required this.backgroundColor,
    required this.height,
    required this.searchBar,
  });

  final Widget searchBar;
  final double height;
  final Color backgroundColor;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: searchBar,
    );
  }

  @override
  bool shouldRebuild(_StickySearchBarDelegate oldDelegate) {
    return searchBar != oldDelegate.searchBar || height != oldDelegate.height;
  }
}
