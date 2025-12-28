import 'package:music_player/features/songs/domain/enums/enums.dart';

class SortConfig {
  const SortConfig({
    this.sortType = SongsSortType.dateAdded,
    this.orderType = SortOrderType.descOrGreater,
  });
  final SongsSortType sortType;
  final SortOrderType orderType;

  SortConfig copyWith({
    SongsSortType? sortType,
    SortOrderType? orderType,
  }) {
    return SortConfig(
      sortType: sortType ?? this.sortType,
      orderType: orderType ?? this.orderType,
    );
  }
}
