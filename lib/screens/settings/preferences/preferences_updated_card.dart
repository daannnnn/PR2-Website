import 'package:flutter/material.dart';
import 'package:pr2/components/message_card.dart';

class PreferencesUpdatedCard extends StatelessWidget {
  PreferencesUpdatedCard({
    Key? key,
    required this.updateInterval,
  }) : super(key: key);

  final double updateInterval;

  final RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  @override
  Widget build(BuildContext context) {
    return MessageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check),
              const SizedBox(width: 8.0),
              Text(
                "Preferences Updated",
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update Interval'.toUpperCase(),
                  style: Theme.of(context).textTheme.overline,
                ),
                Text(
                  '${updateInterval.toString().replaceAll(regex, '')} seconds',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          )
        ],
      ),
      error: false,
    );
  }
}
