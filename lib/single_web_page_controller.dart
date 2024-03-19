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
    this.onAnimatedScrollStart,
    this.onAnimatedScrollEnd,
    this.onScrollEnd,
  }) {
    addListener(() {
      if (!_isAnimating) {
        int visibleIndex = 0;
        _sectionHeights.forEach((index, _) {
          final snapOffset = _bottomSnapOffsets[index];
          if (snapOffset == null) {
            return;
          }
          if (position.pixels >= snapOffset) {
            visibleIndex = index;
          }
        });
        if (onScrollEnd != null) {
          onScrollEnd!(visibleIndex);
        }
      }
    });
  }

  final List<Snap> snaps;
  final double topSnapExtraOffset;
  final double centerSnapExtraOffset;
  final double bottomSnapExtraOffset;
  final void Function(int currentIndex, int targetIndex)? onAnimatedScrollStart;
  final void Function(int currentIndex)? onAnimatedScrollEnd;
  final void Function(int lastVisibleIndex)? onScrollEnd;

  final Map<int, double> _sectionHeights = {};
  final Map<int, double> _topSnapOffsets = {};
  final Map<int, double> _centerSnapOffsets = {};
  final Map<int, double> _bottomSnapOffsets = {};
  int _lastAnimatedIndex = 0;
  bool _isAnimating = false;

  void updateSectionHeights(int index, double height) {
    bool sameValueFlag = false;

    _sectionHeights.update(
      index,
      (value) {
        if (value == height) {
          sameValueFlag = true;
        }
        return height;
      },
      ifAbsent: () {
        return height;
      },
    );

    if (sameValueFlag) {
      return;
    }

    _calculateTopSnapOffsets();
    _calculateCenterSnapOffsets();
    _calculateBottomSnapOffsets();

    _fixLastAnimatedIndexOffset();
  }

  void _calculateTopSnapOffsets() {
    for (var index in _sectionHeights.keys) {
      double offset = 0;
      for (var i = 0; i < index; i++) {
        offset += _sectionHeights[i] ?? 0;
      }

      if (index != 0) {
        offset += topSnapExtraOffset;
      }

      offset = _fixOffsetBeyondLimits(offset);

      _topSnapOffsets.update(
        index,
        (value) => offset,
        ifAbsent: () => offset,
      );
    }
  }

  void _calculateCenterSnapOffsets() {
    _topSnapOffsets.forEach((index, topSnapOffset) {
      final viewportHeight = position.viewportDimension;
      final viewportHeightMinusSectionHeight =
          viewportHeight - _sectionHeights[index]!;
      final viewportHeightMinusSectionHeightDivideTwo =
          viewportHeightMinusSectionHeight / 2;
      double offset =
          _topSnapOffsets[index]! - viewportHeightMinusSectionHeightDivideTwo;

      if (index != 0) {
        offset += centerSnapExtraOffset;
      }

      offset = _fixOffsetBeyondLimits(offset);

      _centerSnapOffsets.update(
        index,
        (value) => offset,
        ifAbsent: () => offset,
      );
    });
  }

  void _calculateBottomSnapOffsets() {
    for (var index in _sectionHeights.keys) {
      double offset = 0;
      for (var i = 0; i < index; i++) {
        offset += _sectionHeights[i] ?? 0;
      }
      final viewportHeight = position.viewportDimension;
      final viewportHeightMinusSectionHeight =
          viewportHeight - _sectionHeights[index]!;
      offset = offset - viewportHeightMinusSectionHeight;

      if (index != 0) {
        offset += bottomSnapExtraOffset;
      }

      offset = _fixOffsetBeyondLimits(offset);

      _bottomSnapOffsets.update(
        index,
        (value) => offset,
        ifAbsent: () => offset,
      );
    }
  }

  double _fixOffsetBeyondLimits(double offset) {
    if (offset < 0) {
      return 0;
    }
    if (offset > position.maxScrollExtent) {
      return position.maxScrollExtent;
    }
    return offset;
  }

  void _fixLastAnimatedIndexOffset() {
    final correctionOffset = _getSnapOffsetFromIndex(_lastAnimatedIndex);
    if (correctionOffset == null) {
      return;
    }
    if (position.pixels == correctionOffset) {
      return;
    }
    animateTo(correctionOffset,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  animateToNextSectionIndex({
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.ease,
  }) {
    animateToSectionIndex(_lastAnimatedIndex + 1,
        duration: duration, curve: curve);
  }

  animateToPreviousSectionIndex({
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.ease,
  }) {
    animateToSectionIndex(_lastAnimatedIndex - 1,
        duration: duration, curve: curve);
  }

  Future<void> animateToSectionIndex(
    int index, {
    Duration duration = const Duration(milliseconds: 1000),
    Curve curve = Curves.ease,
  }) async {
    if (index < 0) {
      return;
    }
    if (position.isScrollingNotifier.value) {
      return;
    }
    final snapOffset = _getSnapOffsetFromIndex(index);
    if (snapOffset == null) {
      return;
    }
    if (onAnimatedScrollStart != null) {
      onAnimatedScrollStart!(_lastAnimatedIndex, index);
    }
    _isAnimating = true;
    await animateTo(snapOffset, duration: duration, curve: curve);
    _isAnimating = false;
    _lastAnimatedIndex = index;
    if (onAnimatedScrollEnd != null) {
      onAnimatedScrollEnd!(_lastAnimatedIndex);
    }
  }

  double? _getSnapOffsetFromIndex(int index) {
    late final Map<int, double> snapOffsets;
    final snap = snaps.elementAtOrNull(index);
    switch (snap) {
      case null:
        snapOffsets = _topSnapOffsets;
      case Snap.topSnap:
        snapOffsets = _topSnapOffsets;
      case Snap.centerSnap:
        snapOffsets = _centerSnapOffsets;
      case Snap.bottomSnap:
        snapOffsets = _bottomSnapOffsets;
    }
    if (!snapOffsets.containsKey(index)) {
      return null;
    }
    return snapOffsets[index]!;
  }
}
