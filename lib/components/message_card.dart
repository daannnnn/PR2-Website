import 'package:flutter/material.dart';
import 'package:pr2/components/custom_card.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({Key? key, required this.child, required this.error})
      : super(key: key);

  final Widget child;
  final bool error;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
      color: error
          ? Theme.of(context).colorScheme.error.withAlpha(40)
          : Theme.of(context).colorScheme.primary.withAlpha(40),
    );
  }
}
