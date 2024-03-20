import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:single_web_page/single_web_page_controller.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SingleWebPage extends StatelessWidget {
  const SingleWebPage({
    super.key,
    required this.controller,
    this.physics,
    this.sliverAppBar,
    required this.sections,
  });

  final SingleWebPageController controller;
  final ScrollPhysics? physics;
  final Widget? sliverAppBar;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      physics: physics,
      slivers: [
        SliverStack(children: [
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: sections
                  .asMap()
                  .entries
                  .map(
                    (e) => _WidgetSizeNotifier(
                      widget: e.value,
                      onChange: (size) {
                        controller.updateSectionHeights(e.key, size.height);
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
          if (sliverAppBar != null) sliverAppBar!,
        ])
      ],
    );
  }
}

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
