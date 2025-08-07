import 'package:flutter/material.dart';

class UpnextMusics extends StatelessWidget {
  const UpnextMusics({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text('UPNEXT', style: Theme.of(context).textTheme.titleSmall),
              Icon(Icons.arrow_downward),
            ],
          ),
          Flexible(
            child: ListView.builder(
              itemCount: 5,
              itemExtent: 28,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  minVerticalPadding: 0,
                  leading: Icon(Icons.music_note),
                  title: Text(
                    'Song ${index + 1} - Artist ${index + 1}',
                    maxLines: 1,
                  ),
                  trailing: Text('2:16', maxLines: 1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
