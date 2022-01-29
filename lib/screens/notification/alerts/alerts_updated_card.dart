import 'package:flutter/material.dart';
import 'package:pr2/components/message_card.dart';

class AlertsUpdatedCard extends StatelessWidget {
  const AlertsUpdatedCard({
    Key? key,
  }) : super(key: key);

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
                "All Alerts Updated",
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          ),
        ],
      ),
      error: false,
    );
  }
}
