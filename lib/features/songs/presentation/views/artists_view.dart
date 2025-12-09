import 'package:flutter/material.dart';

class ArtistsView extends StatelessWidget {
  const ArtistsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Artists View',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
