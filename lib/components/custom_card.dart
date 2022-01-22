import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.child, this.color = Colors.white})
      : super(key: key);

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
            blurRadius: 8.0,
          )
        ],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0.0,
        child: child,
      ),
    );
  }
}
