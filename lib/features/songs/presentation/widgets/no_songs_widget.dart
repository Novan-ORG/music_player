import 'package:flutter/material.dart';

class NoSongsWidget extends StatelessWidget {
  const NoSongsWidget({
    super.key,
    this.onRefresh,
    this.message = 'No songs available',
  });

  final String message;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 14,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          ElevatedButton(onPressed: onRefresh, child: const Text('Refresh')),
        ],
      ),
    );
  }
}
