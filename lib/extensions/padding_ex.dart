import 'package:flutter/widgets.dart';

extension PaddingEx on Widget {
  Widget padding({double horizontal = 0, double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }
}
