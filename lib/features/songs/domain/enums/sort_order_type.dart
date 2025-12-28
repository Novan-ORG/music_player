import 'package:flutter/material.dart' show BuildContext, IconData, Icons;
import 'package:music_player/extensions/extensions.dart';

/// Enum representing the order type for sorting.
enum SortOrderType {
  ascOrSmaller,
  descOrGreater,
}

extension SortOrderTypeExtension on SortOrderType {
  String toLocalizationString(BuildContext context) {
    switch (this) {
      case SortOrderType.ascOrSmaller:
        return context.localization.ascending;
      case SortOrderType.descOrGreater:
        return context.localization.descending;
    }
  }

  IconData toIconData() {
    switch (this) {
      case SortOrderType.ascOrSmaller:
        return Icons.arrow_upward;
      case SortOrderType.descOrGreater:
        return Icons.arrow_downward;
    }
  }
}
