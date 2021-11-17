import 'package:flutter/material.dart';

class SensorDataRowItem extends StatelessWidget {
  const SensorDataRowItem(this.value, this.title, {Key? key}) : super(key: key);

  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: Theme.of(context).textTheme.overline,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
          ),
        )
      ],
    );
  }
}
