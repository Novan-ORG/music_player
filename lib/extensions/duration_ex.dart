/// Extension on Duration for formatting to HH:MM:SS string.
///
/// Method: `format()` - Returns formatted duration as "HH:MM:SS"
extension DurationEx on Duration {
  String format() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return '${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
