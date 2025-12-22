import 'package:flutter/widgets.dart';

/// Extension on Widget for convenient padding applications.
///
/// Provides methods:
/// - `padding()` - Apply uniform padding
/// - `paddingSymmetric()` - Apply symmetric padding (horizontal/vertical)
/// - `paddingOnly()` - Apply padding to specific sides
extension PaddingEx on Widget {
  Widget padding({double value = 0}) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  Widget paddingOnly({
    double top = 0,
    double bottom = 0,
    double right = 0,
    double left = 0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }
}
