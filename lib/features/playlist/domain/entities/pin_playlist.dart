import 'package:equatable/equatable.dart';

/// Represents a playlist that has been pinned to the top of the list.
///
/// Contains the playlist ID and the order in which it should be displayed.
class PinPlaylist extends Equatable {
  const PinPlaylist({
    required this.playlistId,
    required this.order,
  });

  final int playlistId;
  final int order;

  @override
  List<Object?> get props => [playlistId, order];

  PinPlaylist copyWith({
    int? playlistId,
    int? order,
  }) {
    return PinPlaylist(
      playlistId: playlistId ?? this.playlistId,
      order: order ?? this.order,
    );
  }
}
