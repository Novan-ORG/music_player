import 'package:flutter/material.dart';

class AlbumsView extends StatelessWidget {
  const AlbumsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Albums View',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
