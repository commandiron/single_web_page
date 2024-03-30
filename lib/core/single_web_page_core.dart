part of '../single_web_page.dart';

class _SingleWebPageCore extends StatelessWidget {
  const _SingleWebPageCore({
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
