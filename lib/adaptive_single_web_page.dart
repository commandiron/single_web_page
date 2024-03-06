import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:single_web_page/single_web_page.dart';
import 'package:single_web_page/single_web_page_controller.dart';

class AdaptiveSingleWebPage extends StatelessWidget {
  const AdaptiveSingleWebPage({
    super.key,
    required this.controller,
    this.physics,
    this.sliverAppBar,
    required this.sections,
  });

  final SingleWebPageController controller;
  final ScrollPhysics? physics;
  final SliverAppBar? sliverAppBar;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    return _ScrollDetector(
      onPointerScroll: physics == null
          ? (pointerScrollEvent) {
              if (!_Adaptive.isWindows()) {
                return;
              }
              if (pointerScrollEvent.scrollDelta.dy > 0) {
                controller.animateToNextSectionIndex();
              }
              if (pointerScrollEvent.scrollDelta.dy < 0) {
                controller.animateToPreviousSectionIndex();
              }
            }
          : null,
      child: SingleWebPage(
        controller: controller,
        physics: physics ??
            (_Adaptive.isWindows()
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics()),
        sliverAppBar: sliverAppBar,
        sections: sections,
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
