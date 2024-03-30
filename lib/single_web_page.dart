import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:single_web_page/single_web_page_controller.dart';
import 'package:sliver_tools/sliver_tools.dart';

part 'core/single_web_page_core.dart';

part 'core/widget_size_notifier.dart';

enum SingleWebPagePhysics {
  adaptive,
  stepByStep,
  flutterDefault,
  lock,
}

class SingleWebPage extends StatefulWidget {
  const SingleWebPage({
    super.key,
    required this.controller,
    this.singleWebPagePhysics = SingleWebPagePhysics.adaptive,
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
      SingleWebPagePhysics.adaptive => _Adaptive.isWindows()
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
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
      onPointerScroll: widget.singleWebPagePhysics ==
                  SingleWebPagePhysics.stepByStep ||
              (widget.singleWebPagePhysics == SingleWebPagePhysics.adaptive &&
                  _Adaptive.isWindows())
          ? (pointerScrollEvent) {
              if (pointerScrollEvent.scrollDelta.dy > 0) {
                widget.controller.animateToNextSectionIndex();
              }
              if (pointerScrollEvent.scrollDelta.dy < 0) {
                widget.controller.animateToPreviousSectionIndex();
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
    required this.child,
  });

  final void Function(PointerScrollEvent pointerScrollEvent)? onPointerScroll;
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
      child: child,
    );
  }
}

class _Adaptive extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const _Adaptive({
    required this.mobile,
    required this.desktop,
  });

  static bool isWindows() => defaultTargetPlatform == TargetPlatform.windows;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android) {
          return mobile;
        }
        return desktop;
      },
    );
  }
}
