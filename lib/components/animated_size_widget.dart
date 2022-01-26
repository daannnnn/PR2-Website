import 'package:flutter/material.dart';

class AnimatedSizeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  const AnimatedSizeWidget({
    Key? key,
    required this.child,
    required this.duration,
  }) : super(key: key);

  @override
  _AnimatedSizeWidgetState createState() => _AnimatedSizeWidgetState();
}

class _AnimatedSizeWidgetState extends State<AnimatedSizeWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: widget.duration,
      child: widget.child,
      curve: Curves.easeInOut,
    );
  }
}
