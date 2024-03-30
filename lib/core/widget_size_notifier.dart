part of '../single_web_page.dart';

class _WidgetSizeNotifier extends StatefulWidget {
  const _WidgetSizeNotifier({required this.widget, required this.onChange});

  final Widget widget;
  final Function(Size size) onChange;

  @override
  State<_WidgetSizeNotifier> createState() => _WidgetSizeNotifierState();
}

class _WidgetSizeNotifierState extends State<_WidgetSizeNotifier> {
  GlobalKey widgetKey = GlobalKey();
  Size oldSize = Size.zero;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    super.initState();
  }

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
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
        return true;
      },
      child: SizeChangedLayoutNotifier(
        key: widgetKey,
        child: widget.widget,
      ),
    );
  }
}
