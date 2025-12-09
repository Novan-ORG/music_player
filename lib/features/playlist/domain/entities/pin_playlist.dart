class PinPlaylist {
  PinPlaylist({
    required this.playlistId,
    required this.order,
  });

  factory PinPlaylist.fromJson(Map<String, dynamic> json) {
    return PinPlaylist(
      playlistId: json['playlistId'] as int,
      order: json['order'] as int,
    );
  }

  final int playlistId;
  final int order;

  PinPlaylist copyWith({
    int? playlistId,
    int? order,
  }) {
    return PinPlaylist(
      playlistId: playlistId ?? this.playlistId,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toJson() => {
    'playlistId': playlistId,
    'order': order,
  };
}
