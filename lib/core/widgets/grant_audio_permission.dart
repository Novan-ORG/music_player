import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Widget requesting audio/media permission from the user.
///
/// Displays:
/// - Permission explanation message
/// - Button to navigate to app settings
/// - Optional custom message override
/// - Callback when permission is granted
class GrantAudioPermission extends StatelessWidget {
  const GrantAudioPermission({
    this.message,
    this.onGrantPermission,
    super.key,
  });
  final String? message;
  final VoidCallback? onGrantPermission;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.audiotrack,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 24),
              Text(
                message ?? 'Audio Permission Required',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'This app needs audio permission to play music and provide '
                'you with the best experience.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await openAppSettings();
                  onGrantPermission?.call();
                },
                child: const Text('Grant Permission'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
