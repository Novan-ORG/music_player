/// Represents a device folder that contains one or more songs.
class Folder {
  /// Creates a [Folder] with its display metadata.
  const Folder({
    required this.name,
    required this.path,
    required this.songCount,
  });

  /// Folder name shown in the UI.
  final String name;

  /// Absolute folder path on the device.
  final String path;

  /// Number of songs found inside this folder.
  final int songCount;
}
