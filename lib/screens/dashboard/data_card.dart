import 'package:flutter/material.dart';
import 'package:pr2/components/custom_card.dart';

class DataCard extends StatelessWidget {
  const DataCard(this.title, this.value, this.color, {Key? key})
      : super(key: key);

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Column(
            children: [
              Text(
                value,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Container(
                height: 3.0,
                width: 24.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: const BorderRadius.all(Radius.circular(3 / 2)),
                  color: color.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
