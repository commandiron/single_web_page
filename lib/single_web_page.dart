import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:single_web_page/single_web_page_controller.dart';
import 'package:sliver_tools/sliver_tools.dart';

part 'core/single_web_page_core.dart';
part 'core/widget_size_notifier.dart';

enum SingleWebPagePhysics {
  stepByStep,
  flutterDefault,
  lock,
}

class SingleWebPage extends StatefulWidget {
  const SingleWebPage({
    super.key,
    required this.controller,
    this.singleWebPagePhysics = SingleWebPagePhysics.stepByStep,
    this.sliverAppBar,
    required this.sections,
  });

  final SingleWebPageController controller;
  final SingleWebPagePhysics singleWebPagePhysics;
  final Widget? sliverAppBar;
  final List<Widget> sections;

  @override
  State<SingleWebPage> createState() => _SingleWebPageState();
}

class _SingleWebPageState extends State<SingleWebPage> {
  late final ScrollPhysics _physics;

  @override
  void initState() {
    _physics = switch (widget.singleWebPagePhysics) {
      SingleWebPagePhysics.stepByStep => const NeverScrollableScrollPhysics(),
      SingleWebPagePhysics.flutterDefault =>
        const AlwaysScrollableScrollPhysics(),
      SingleWebPagePhysics.lock => const NeverScrollableScrollPhysics(),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _ScrollDetector(
      onPointerScroll:
          widget.singleWebPagePhysics == SingleWebPagePhysics.stepByStep
              ? (pointerScrollEvent) {
                  if (pointerScrollEvent.scrollDelta.dy > 0) {
                    widget.controller.animateToNextSectionIndex();
                  }
                  if (pointerScrollEvent.scrollDelta.dy < 0) {
                    widget.controller.animateToPreviousSectionIndex();
                  }
                }
              : null,
      onPointerMove:
          widget.singleWebPagePhysics == SingleWebPagePhysics.stepByStep
              ? (pointerMoveEvent) {
                  if (pointerMoveEvent.delta.dy > 0) {
                    widget.controller.animateToPreviousSectionIndex();
                  }
                  if (pointerMoveEvent.delta.dy < 0) {
                    widget.controller.animateToNextSectionIndex();
                  }
                }
              : null,
      child: _SingleWebPageCore(
        controller: widget.controller,
        physics: _physics,
        sliverAppBar: widget.sliverAppBar,
        sections: widget.sections,
      ),
    );
  }
}

class _ScrollDetector extends StatelessWidget {
  const _ScrollDetector({
    required this.onPointerScroll,
    required this.onPointerMove,
    required this.child,
  });

  final void Function(PointerScrollEvent pointerScrollEvent)? onPointerScroll;
  final void Function(PointerMoveEvent pointerMoveEvent)? onPointerMove;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          if (onPointerScroll != null) {
            onPointerScroll!(pointerSignal);
          }
        }
      },
      onPointerMove: onPointerMove,
      child: child,
    );
  }
}
