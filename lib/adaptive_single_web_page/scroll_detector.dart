import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScrollDetector extends StatelessWidget {
  const ScrollDetector({
    super.key,
    required this.onPointerScroll,
    this.onPointerDown,
    this.onPointerUp,
    required this.child,
  });

  final void Function(PointerScrollEvent pointerScrollEvent)? onPointerScroll;
  final void Function(PointerDownEvent event)? onPointerDown;
  final void Function(PointerUpEvent event)? onPointerUp;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: onPointerDown,
      onPointerUp: onPointerUp,
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          if(onPointerScroll != null) {
            onPointerScroll!(pointerSignal);
          }
        }
      },
      child: child,
    );
  }
}