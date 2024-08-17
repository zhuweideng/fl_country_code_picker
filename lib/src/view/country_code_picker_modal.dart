import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// {@template country_code_picker_modal}
/// Widget that can be used on showing a modal as bottom sheet that
/// contains all of the [CountryCode]s.
///
/// After pressing the [CountryCode]'s [ListTile], the widget pops
/// and returns the selected [CountryCode] which can be manipulated.
/// {@endtemplate}
class CountryCodePickerModal extends StatefulWidget {
  /// {@macro country_code_picker_modal}
  const CountryCodePickerModal({
    required this.favoriteCountries,
    required this.filteredCountries,
    required this.localized,
    required this.pickerParams,
    required this.pickerItemParams,
    required this.pickerSearchParams,
    required this.pickerTitleParams,
    this.focusedCountry,
    super.key,
  });

  /// {@macro filtered_countries}
  final List<String> filteredCountries;

  /// {@macro favorite_countries}
  final List<String> favoriteCountries;

  /// {@macro localize}
  final bool localized;

  /// If not null, automatically scrolls the list view to this country.
  final String? focusedCountry;

  /// {@macro picker_params}
  final PickerParams pickerParams;

  /// {@macro picker_title_params}
  final PickerTitleParams pickerTitleParams;

  /// {@macro picker_item_params}
  final PickerItemParams pickerItemParams;

  /// {@macro picker_search_params}
  final PickerSearchParams pickerSearchParams;

  @override
  State<CountryCodePickerModal> createState() => _CountryCodePickerModalState();
}

class _CountryCodePickerModalState extends State<CountryCodePickerModal> {
  late final List<CountryCode> baseList;
  final availableCountryCodes = <CountryCode>[];
  late ItemScrollController itemScrollController;

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
    _initCountries();
  }

  Future<void> _initCountries() async {
    final complete = codes.map(CountryCode.fromMap).toList();

    // We're pulling the list of favorites from the complete.
    // This is necessary to put the favorites at the top of the list.
    final favoriteList = <CountryCode>[
      if (widget.favoriteCountries.isNotEmpty)
        ...complete.where((c) => widget.favoriteCountries.contains(c.code)),
    ];

    // In this filteredList, we're removing the countries that are filtered
    // programmatically.
    final filteredList = [
      ...widget.filteredCountries.isNotEmpty
          ? complete.where((c) => widget.filteredCountries.contains(c.code))
          : complete,
    ]..removeWhere((c) => widget.favoriteCountries.contains(c.code));

    // Here we're merging the favorites and filtered as one list.
    //
    // baseList contains the clean version of the merged favorites
    // and filtered. This will be used for example if the user tried
    // to query for country codes, we'll use this list to reset it
    // back to the base copy.
    baseList = [...favoriteList, ...filteredList];

    // availableCountryCodes contains the items that will be visible
    // to the user.
    availableCountryCodes.addAll(baseList);

    // Temporary fix due to some unknown bug where the controller
    // was having a race condition in render and attachment.
    await Future<void>.delayed(Duration.zero);
    if (!itemScrollController.isAttached) return;

    if (widget.focusedCountry != null) {
      final index = availableCountryCodes.indexWhere(
        (c) => c.code == widget.focusedCountry,
      );

      await itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 600),
      );
    }
  }

  void onSearchChanged(String value) {
    final results = [
      ...baseList.where(
        (c) {
          final country = widget.localized ? c.localize(context) : c;
          final query = value.toLowerCase();
          return country.code.toLowerCase().contains(query) ||
              country.dialCode.toLowerCase().contains(query) ||
              country.name.toLowerCase().contains(query);
        },
      ),
    ];

    availableCountryCodes
      ..clear()
      ..addAll(results);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.pickerParams.backgroundColor,
      body: CustomScrollView(
        primary: true,
        slivers: [
          PickerTitle(
            params: widget.pickerTitleParams,
            pickerParams: widget.pickerParams,
          ),
          PickerSearch(
            params: widget.pickerSearchParams,
            pickerParams: widget.pickerParams,
            onChanged: onSearchChanged,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final code = availableCountryCodes[index];
                final params = widget.pickerItemParams;
                return PickerItem(
                  code: code,
                  favorites: widget.favoriteCountries,
                  params: params,
                );
              },
              childCount: availableCountryCodes.length,
            ),
          ),
        ],
      ),
    );
  }
}
