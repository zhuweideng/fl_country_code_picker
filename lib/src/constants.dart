import 'package:flutter/material.dart';

/// Default app margin.
/// https://m3.material.io/foundations/layout/applying-layout/compact#5a83ddd7-137f-4657-ba2d-eb08cac065e7
const kAppMargin = 16.0;

/// Default search bar input decoration.
const kInputDecoration = InputDecoration(
  hintText: "'Country', 'Code' or 'Dial Code'",
  hintStyle: TextStyle(fontSize: 12),
  suffixIcon: Icon(Icons.search),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(kBorderRadius),
    borderSide: BorderSide(
      width: 2,
      style: BorderStyle.none,
    ),
  ),
  filled: true,
  contentPadding: EdgeInsets.symmetric(horizontal: 16),
  fillColor: Colors.white,
);

/// Default favorites icon.
const kFavoritesIcon = Icon(Icons.favorite, size: 24, color: Colors.red);

/// Default modal and TextField default borderRadius.
const kBorderRadius = Radius.circular(10);

/// Default modal background color.
const kBackgroundColor = Color(0xFFFFFFFF);

/// Default modal barrier color.
const kBarrierColor = Color(0x50000000);

/// Default modal shape.
const kShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: kBorderRadius,
    topRight: kBorderRadius,
  ),
);
