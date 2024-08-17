import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

const _rectangularMaxSize = 100.0;
const _rectangularMinSize = 20.0;

/// {@template flag_shape}
/// Shape of flags for ui.
///
/// View all flags [here](https://github.com/fernan542/fl_country_code_picker/tree/master/assets/flags).
/// {@endtemplate}
enum FlagShape {
  /// Circle.
  circular,

  /// Rectangle.
  rectangular,

  /// Rounded Rectangle.
  roundedRectangular,
}

/// {@template item_leading_params}
/// An object that contains the parameters needed for
/// customizing the list item's *leading* widget.
///
/// Params are currently limited to flags display.
///
/// See also:
///
/// * [DefaultItemLeadingParams], the default design params for the
/// leading widget.
/// * [CustomItemLeadingParams], the customizeable params for
/// the leading widget.
/// {@endtemplate}
sealed class ItemLeadingParams {
  /// {@macro item_leading_params}
  const ItemLeadingParams({
    this.showLeading = true,
    this.shape = FlagShape.rectangular,
    this.size = 40,
    this.borderRadius,
  });

  /// Whether to show the list item's leading widget.
  final bool showLeading;

  /// Defaults to `Flagshape.rectangular`.
  ///
  /// {@macro flag_shape}
  final FlagShape shape;

  /// Custom size of the flag.
  ///
  /// If the [FlagShape] was set to rectangular, the value of the
  /// flag's size is constrained to `300` because the image's resolution
  /// of the flags can be distorted. In the future, we'll migrate the
  /// images to SVG for better quality. But at the moment, png is
  /// more preferred due to size.
  ///
  /// Defaults to 40 for accessibility.
  ///
  /// https://m3.material.io/components/lists/specs#87ae8a2b-51a5-4a1d-913d-d12583fe82ca
  final double size;

  /// Border radius for rounded rectangular flags.
  ///
  /// Value will not be used if FlagShape is not
  final BorderRadius? borderRadius;
}

/// {@template default_item_leading_params}
/// Contains the default design params for the leading widget.
///
/// {@macro item_leading_params}
/// {@endtemplate}
class DefaultItemLeadingParams extends ItemLeadingParams {
  /// {@macro default_item_leading_params}
  const DefaultItemLeadingParams();
}

/// {@template custom_item_leading_params}
/// Customizeable params for the leading widget.
///
/// {@macro item_trailing_params}
/// {@endtemplate}
class CustomItemLeadingParams extends ItemLeadingParams {
  /// {@macro custom_item_leading_params}
  const CustomItemLeadingParams({
    super.size,
    super.shape,
    super.showLeading,
    super.borderRadius,
  });
}

/// {@template item_leading}
/// Widget for list item's leading.
/// {@endtemplate}
class ItemLeading extends StatelessWidget {
  /// {@macro item_leading}
  const ItemLeading({
    required this.code,
    required this.params,
    super.key,
  });

  /// {@macro code}
  final CountryCode code;

  /// {@macro item_leading_params}
  final ItemLeadingParams params;

  @override
  Widget build(BuildContext context) {
    assert(
      params.size <= _rectangularMaxSize && params.size >= _rectangularMinSize,
      'Please enter a valid rectangular flag size. '
      'Size should be <= 50 and >= 20. Current size: ${params.size}',
    );
    if (!params.showLeading) return const SizedBox();

    return SizedBox(
      width: params.size,
      height: params.size,
      child: ClipPath(
        clipper: _ShapeClipper(
          shape: params.shape,
          borderRadius: params.borderRadius,
        ),
        child: Image.asset(
          code.flagUri,
          fit: BoxFit.cover,
          package: code.flagImagePackage,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class _ShapeClipper extends CustomClipper<Path> {
  const _ShapeClipper({
    required this.shape,
    this.borderRadius,
  });

  final FlagShape shape;
  final BorderRadius? borderRadius;

  @override
  Path getClip(Size size) {
    switch (shape) {
      case FlagShape.circular:
        return Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
      case FlagShape.rectangular:
        return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      case FlagShape.roundedRectangular:
        final radius = borderRadius;
        if (radius != null) {
          return Path()
            ..addRRect(
              RRect.fromRectAndCorners(
                Rect.fromLTWH(0, 0, size.width, size.height),
                topLeft: radius.topLeft,
                topRight: radius.topRight,
                bottomLeft: radius.bottomLeft,
                bottomRight: radius.bottomRight,
              ),
            );
        }
        // If radius is not given, we'll fall back to default rectangle.
        return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
