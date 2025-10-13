import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionInfo extends StatelessWidget {
  const VersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (_, snapShot) {
        if (snapShot.hasData &&
            snapShot.connectionState == ConnectionState.done) {
          final packageInfo = snapShot.data!;
          return Text(
            'V${packageInfo.version}+${packageInfo.buildNumber}',
            style: Theme.of(context).textTheme.labelSmall,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
