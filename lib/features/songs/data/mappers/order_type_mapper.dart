import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

/// Maps enum values between native query types and domain sort types.
class OrderTypeMapper {
  static OrderType fromIndex(int index) {
    switch (index) {
      case 0:
        return OrderType.ASC_OR_SMALLER;
      case 1:
        return OrderType.DESC_OR_GREATER;
      default:
        return OrderType.ASC_OR_SMALLER;
    }
  }

  // we used the `SortOrderType` in domain layer
  // but the `OrderType` in data layer
  static SortOrderType toSortOrderType(OrderType orderType) {
    switch (orderType) {
      case OrderType.ASC_OR_SMALLER:
        return SortOrderType.ascOrSmaller;
      case OrderType.DESC_OR_GREATER:
        return SortOrderType.descOrGreater;
    }
  }
}
