import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  static Future<void> launchUrlExternally(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static Future<bool> openEmailApp({
    required String toEmail,
    String? subject,
    String? body,
  }) async {
    final String encodedSubject = subject != null
        ? Uri.encodeComponent(subject)
        : "";
    final String encodedBody = body != null ? Uri.encodeComponent(body) : "";

    final Uri emailUri = Uri.parse(
      "mailto:$toEmail?subject=$encodedSubject&body=$encodedBody",
    );

    if (await canLaunchUrl(emailUri)) {
      return launchUrl(emailUri);
    } else {
      return false;
    }
  }
}
