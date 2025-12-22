import 'package:music_player/core/services/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility class for launching URLs and opening email apps.
///
/// Methods:
/// - `launchUrlExternally(url)` - Open URL in external browser
/// - `openEmailApp(toEmail, subject, body)` - Compose and send email
class LauncherUtils {
  static Future<void> launchUrlExternally(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    ).catchError((dynamic e) {
      Logger.error('error in launching url: $e');
      return true;
    });
  }

  static Future<bool> openEmailApp({
    required String toEmail,
    String? subject,
    String? body,
  }) async {
    final encodedSubject = subject != null ? Uri.encodeComponent(subject) : '';
    final encodedBody = body != null ? Uri.encodeComponent(body) : '';

    final emailUri = Uri.parse(
      'mailto:$toEmail?subject=$encodedSubject&body=$encodedBody',
    );

    if (await canLaunchUrl(emailUri)) {
      return launchUrl(emailUri);
    } else {
      return false;
    }
  }
}
