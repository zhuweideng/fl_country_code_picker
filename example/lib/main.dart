import 'package:fl_country_code_picker/fl_country_code_picker.dart' as fl;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'demo/demo.dart';

void main() {
  fl.FlCountryCodePicker.initalize(
    pickerParams: const fl.CustomPickerParams(width: 700),
    pickerSearchParams: const fl.CustomPickerSearchParams(showSearch: true),
    pickerItemParams: const fl.CustomPickerItemParams(
      bodyParams: fl.CustomItemBodyParams(
        nameDisplay: fl.CountryNameDisplay.full,
      ),
      leadingParams: fl.CustomItemLeadingParams(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        size: 40,
        shape: fl.FlagShape.circular,
      ),
      trailingParams: fl.CustomItemTrailingParams(),
    ),
    pickerTitleParams: const fl.CustomPickerTitleParams(
      text: 'Select your country',
      centerTitle: false,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      supportedLocales:
          fl.CountryLocalizations.supportedLocales.map(Locale.new),
      localizationsDelegates: const [
        fl.CountryLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const DemoPage(),
    );
  }
}
