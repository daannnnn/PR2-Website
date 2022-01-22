import 'package:flutter/material.dart';
import 'package:pr2/components/custom_card.dart';
import 'package:pr2/models/factor.dart';

class FactorCard extends StatelessWidget {
  FactorCard({
    Key? key,
    required Factor factor,
    required this.selected,
    required this.onTap,
  })  : title = factor.name,
        color = factor.color,
        super(key: key);

  final bool selected;

  final String title;
  final Color color;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomCard(
        color: selected
            ? Theme.of(context).colorScheme.primary.withAlpha(40)
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          child: Row(
            children: [
              Container(
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.button?.copyWith(
                      color: Colors.black.withOpacity(0.87),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
