import 'package:flutter/material.dart';
import 'package:single_web_page/single_web_page/single_web_page_controller.dart';
import 'package:single_web_page/single_web_page/widget_size_notifier.dart';
import 'package:sliver_tools/sliver_tools.dart';

class SingleWebPage extends StatelessWidget {
  const SingleWebPage({super.key, required this.controller, this.physics, this.sliverAppBar, required this.sections,});
  final SingleWebPageController controller;
  final ScrollPhysics? physics;
  final SliverAppBar? sliverAppBar;
  final List<Widget> sections;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      physics: physics,
      slivers: [
        SliverStack(
          children: [
            SliverToBoxAdapter(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: sections.asMap().entries.map(
                  (e) => WidgetSizeNotifier(
                    widget: e.value,
                    onChange: (size) {
                      controller.updateSectionHeights(e.key, size.height);
                    },
                  )
                ).toList()
              ),
            ),
            if(sliverAppBar != null)
              sliverAppBar!,
          ]
        )
      ],
    );
  }
}