import 'package:flutter/material.dart';
import 'package:music_player/extensions/extensions.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: context.theme.colorScheme.onSecondary,
        ),
      ),
    );
  }
}
