import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'single_web_page.dart';
import 'single_web_page_controller.dart';

class AdaptiveSingleWebPage extends StatelessWidget {
  const AdaptiveSingleWebPage({super.key, required this.controller, this.physics, this.sliverAppBar, required this.sections,});
  final SingleWebPageController controller;
  final ScrollPhysics? physics;
  final SliverAppBar? sliverAppBar;
  final List<Widget> sections;
  @override
  Widget build(BuildContext context) {
    return _ScrollDetector(
      onPointerScroll: physics == null
        ? (pointerScrollEvent) {
          if (!_Adaptive.isDesktop() || _Adaptive.isMac()) {
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
          _Adaptive.getValue(
            const AlwaysScrollableScrollPhysics(),
            _Adaptive.isMac()
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics()
          ),
        sliverAppBar: sliverAppBar,
        sections: sections
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
          if(onPointerScroll != null) {
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

  static bool isDesktop() =>
      defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.macOS;

  static bool isMac() =>
      defaultTargetPlatform == TargetPlatform.macOS;

  static dynamic getValue(
      mobileValue,
      desktopValue,
      ) {
    if(defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
      return mobileValue;
    }
    return desktopValue;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
          return mobile;
        }
        return desktop;
      },
    );
  }
}
