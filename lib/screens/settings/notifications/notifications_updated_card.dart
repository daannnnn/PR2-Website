import 'package:flutter/material.dart';
import 'package:pr2/components/message_card.dart';

class NotificationsUpdatedCard extends StatelessWidget {
  const NotificationsUpdatedCard({
    Key? key,
    required sendNotifications,
  })  : sendNotifications = sendNotifications ? 'Yes' : 'No',
        super(key: key);

  final String sendNotifications;

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
                "All Notification Settings Updated",
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
                  "Send notifications to this device".toUpperCase(),
                  style: Theme.of(context).textTheme.overline,
                ),
                Text(
                  sendNotifications.toUpperCase(),
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
