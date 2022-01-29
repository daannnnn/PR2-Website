import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pr2/components/message_card.dart';

class AlertsPendingUpdateCard extends StatelessWidget {
  const AlertsPendingUpdateCard({
    Key? key,
    required this.deviceLastUpdateTime,
    required this.pendingSetAlertCount,
    required this.pendingDeleteAlertCount,
  }) : super(key: key);

  final DateTime deviceLastUpdateTime;
  final int pendingSetAlertCount;
  final int pendingDeleteAlertCount;

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (pendingSetAlertCount != 0)
                  Row(
                    children: [
                      Container(
                        height: 24.0,
                        width: 48.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.greenAccent.withAlpha(40),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '$pendingSetAlertCount ${(pendingSetAlertCount == 1) ? 'alert' : 'alerts'} pending addition',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                if (pendingSetAlertCount != 0 && pendingDeleteAlertCount != 0)
                  const SizedBox(height: 8.0),
                if (pendingDeleteAlertCount != 0)
                  Row(
                    children: [
                      Container(
                        height: 24.0,
                        width: 48.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.redAccent.withAlpha(40),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '$pendingDeleteAlertCount ${(pendingDeleteAlertCount == 1) ? 'alert' : 'alerts'} pending deletion',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
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
