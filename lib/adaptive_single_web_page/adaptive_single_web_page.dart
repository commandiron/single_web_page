import 'package:flutter/material.dart';
import 'package:single_web_page/adaptive_single_web_page/scroll_detector.dart';

import '../single_web_page/single_web_page.dart';
import '../single_web_page/single_web_page_controller.dart';
import 'adaptive.dart';

class AdaptiveSingleWebPage extends StatelessWidget {
  const AdaptiveSingleWebPage({super.key, required this.controller, this.physics, this.sliverAppBar, required this.sections,});
  final SingleWebPageController controller;
  final ScrollPhysics? physics;
  final SliverAppBar? sliverAppBar;
  final List<Widget> sections;
  @override
  Widget build(BuildContext context) {
    return ScrollDetector(
      onPointerScroll: physics == null
        ? (pointerScrollEvent) {
          if (!Adaptive.isDesktop() || Adaptive.isMac()) {
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
          Adaptive.getValue(
            const AlwaysScrollableScrollPhysics(),
            Adaptive.isMac()
              ? const AlwaysScrollableScrollPhysics()
              : const NeverScrollableScrollPhysics()
          ),
        sliverAppBar: sliverAppBar,
        sections: sections
      ),
    );
  }
}
