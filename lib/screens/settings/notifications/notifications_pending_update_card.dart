import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pr2/components/message_card.dart';

class NotificationsPendingUpdateCard extends StatelessWidget {
  NotificationsPendingUpdateCard({
    Key? key,
    required this.deviceLastUpdateTime,
    required currentSendNotifications,
    required pendingSendNotifications,
  })  : currentSendNotifications = currentSendNotifications ? 'Yes' : 'No',
        pendingSendNotifications = pendingSendNotifications ? 'Yes' : 'No',
        super(key: key);

  final DateTime deviceLastUpdateTime;
  final String currentSendNotifications;
  final String pendingSendNotifications;

  @override
  Widget build(BuildContext context) {
    return MessageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pending Update",
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(height: 8.0),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.caption,
              children: [
                const TextSpan(
                    text: 'You can wait for the next update schedule on '),
                TextSpan(
                    text: DateFormat.yMMMd().add_jms().format(
                        deviceLastUpdateTime.add(const Duration(days: 1))),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const TextSpan(text: ', or you can '),
                const TextSpan(
                    text: 'restart',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: ' the device to update immediately.'),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            "Current:",
            style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Send notifications to this device".toUpperCase(),
                  style: Theme.of(context).textTheme.overline,
                ),
                Text(
                  currentSendNotifications.toUpperCase(),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            "Pending updates:",
            style: Theme.of(context)
                .textTheme
                .caption
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Send notifications to this device".toUpperCase(),
                  style: Theme.of(context).textTheme.overline,
                ),
                Text(
                  pendingSendNotifications.toUpperCase(),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ],
      ),
      error: true,
    );
  }
}
