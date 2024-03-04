import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WidgetSizeNotifier extends StatefulWidget {
  const WidgetSizeNotifier({super.key, required this.widget, required this.onChange});

  final Widget widget;
  final Function(Size size) onChange;

  @override
  State<WidgetSizeNotifier> createState() => _WidgetSizeNotifierState();
}

class _WidgetSizeNotifierState extends State<WidgetSizeNotifier> {

  GlobalKey widgetKey = GlobalKey();
  Size oldSize = Size.zero;

  void postFrameCallback(_) {
    final BuildContext? context = widgetKey.currentContext;
    if (context == null) return;

    Size? newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize ?? Size.zero;
    widget.onChange(newSize ?? Size.zero);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
        return Container(
          key: widgetKey,
          child: widget.widget,
        );
      }
    );
  }
}