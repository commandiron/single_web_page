import 'package:flutter/material.dart';

enum Snap {
  topSnap,
  centerSnap,
  bottomSnap,
}

class SingleWebPageController extends ScrollController {
  SingleWebPageController({
    this.snaps = const [],
    this.topSnapExtraOffset = 0,
    this.centerSnapExtraOffset = 0,
    this.bottomSnapExtraOffset = 0,
  });

  final List<Snap> snaps;
  final double topSnapExtraOffset;
  final double centerSnapExtraOffset;
  final double bottomSnapExtraOffset;
  Map<int, double> sectionHeights = {};
  Map<int, double> topSnapOffsets = {};
  Map<int, double> centerSnapOffsets = {};
  Map<int, double> bottomSnapOffsets = {};
  int sectionIndex = 0;
  double lastCurrentPixels = 0;

  void updateSectionHeights(int index, double height) {

    sectionHeights.update(
      index,
      (value) => height,
      ifAbsent: () => height,
    );

    calculateTopSnapOffsets();
    calculateCenterSnapOffsets();
    calculateBottomSnapOffsets();

    fixOffset();
  }

  void fixOffset() {
    late final Map<int, double> snapOffsets;
    final snap = snaps.elementAtOrNull(sectionIndex);
    switch (snap) {
      case null:
        snapOffsets = topSnapOffsets;
      case Snap.topSnap:
        snapOffsets = topSnapOffsets;
      case Snap.centerSnap:
        snapOffsets = centerSnapOffsets;
      case Snap.bottomSnap:
        snapOffsets = bottomSnapOffsets;
    }
    if (!snapOffsets.containsKey(sectionIndex)) {
      return;
    }
    final correctionOffset = snapOffsets[sectionIndex]!;
    if(position.pixels != correctionOffset) {
      animateTo(correctionOffset, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  void calculateTopSnapOffsets() {
    for (var index in sectionHeights.keys) {
      double offset = 0;
      for (var i = 0; i < index; i++) {
        offset += sectionHeights[i] ?? 0;
      }

      if (index != 0) {
        offset += topSnapExtraOffset;
      }

      offset = fixOffsetBeyondLimits(offset);

      topSnapOffsets.update(
        index,
        (value) => offset,
        ifAbsent: () => offset,
      );
    }
  }

  void calculateCenterSnapOffsets() {
    topSnapOffsets.forEach((index, topSnapOffset) {
      final viewportHeight = position.viewportDimension;
      final viewportHeightMinusSectionHeight =
          viewportHeight - sectionHeights[index]!;
      final viewportHeightMinusSectionHeightDivideTwo =
          viewportHeightMinusSectionHeight / 2;
      double offset =
          topSnapOffsets[index]! - viewportHeightMinusSectionHeightDivideTwo;

      if (index != 0) {
        offset += centerSnapExtraOffset;
      }

      offset = fixOffsetBeyondLimits(offset);

      centerSnapOffsets.update(
        index,
        (value) => offset,
        ifAbsent: () => offset,
      );
    });
  }

  void calculateBottomSnapOffsets() {
    for (var index in sectionHeights.keys) {
      double offset = 0;
      for (var i = 0; i < index; i++) {
        offset += sectionHeights[i] ?? 0;
      }
      final viewportHeight = position.viewportDimension;
      final viewportHeightMinusSectionHeight =
          viewportHeight - sectionHeights[index]!;
      offset = offset - viewportHeightMinusSectionHeight;

      if (index != 0) {
        offset += bottomSnapExtraOffset;
      }

      offset = fixOffsetBeyondLimits(offset);

      bottomSnapOffsets.update(
        index,
        (value) => offset,
        ifAbsent: () => offset,
      );
    }
  }

  double fixOffsetBeyondLimits(double offset) {
    if (offset < 0) {
      return 0;
    }
    if (offset > position.maxScrollExtent) {
      return position.maxScrollExtent;
    }
    return offset;
  }

  animateToNextSectionIndex({
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.ease,
  }) {
    animateToSectionIndex(sectionIndex + 1, duration: duration, curve: curve);
  }

  animateToPreviousSectionIndex({
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.ease,
  }) {
    animateToSectionIndex(sectionIndex - 1, duration: duration, curve: curve);
  }

  void animateToSectionIndex(
    int index, {
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.ease,
  }) {
    if (index < 0) {
      return;
    }
    late final Map<int, double> snapOffsets;
    final snap = snaps.elementAtOrNull(index);
    switch (snap) {
      case null:
        snapOffsets = topSnapOffsets;
      case Snap.topSnap:
        snapOffsets = topSnapOffsets;
      case Snap.centerSnap:
        snapOffsets = centerSnapOffsets;
      case Snap.bottomSnap:
        snapOffsets = bottomSnapOffsets;
    }
    if (!snapOffsets.containsKey(index)) {
      return;
    }
    if (position.isScrollingNotifier.value) {
      return;
    }
    animateTo(snapOffsets[index]!, duration: duration, curve: curve);
    sectionIndex = index;
  }
}
