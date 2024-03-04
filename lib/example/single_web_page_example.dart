import 'package:flutter/material.dart';
import 'package:single_web_page/adaptive_single_web_page.dart';
import 'package:single_web_page/example/widget/menu_button.dart';
import 'package:single_web_page/example/widget/site_button.dart';
import '../single_web_page_controller.dart';
import 'sections.dart';

class SingleWebPageExample extends StatefulWidget {
  const SingleWebPageExample({super.key});

  @override
  State<SingleWebPageExample> createState() => _SingleWebPageExampleState();
}

class _SingleWebPageExampleState extends State<SingleWebPageExample> {
  late final SingleWebPageController _controller;

  static const double expandedHeight = 140;
  static const double collapsedHeight = 60;
  static const double toolbarHeight = 0;

  @override
  void initState() {
    _controller = SingleWebPageController(
      snaps: [Snap.bottomSnap, Snap.topSnap, Snap.centerSnap, Snap.bottomSnap, Snap.bottomSnap],
      topSnapExtraOffset: -collapsedHeight,
      centerSnapExtraOffset: collapsedHeight,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdaptiveSingleWebPage(
        controller: _controller,
        sliverAppBar: _buildSliverAppBar(),
        sections: Section.sections.map((e) => e.widget).toList(),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shadowColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        surfaceTintColor: Colors.transparent,
        expandedHeight: expandedHeight,
        collapsedHeight: collapsedHeight,
        toolbarHeight: toolbarHeight,
        snap: false,
        floating: false,
        pinned: true,
        flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 64,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: Section.sections
                          .asMap()
                          .entries
                          .map(
                            (e) => MenuButton(
                              onPressed: () => _controller.animateToSectionIndex(e.key),
                              text: e.value.title,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    alignment: Alignment.center,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxHeight < 40) {
                          return const SizedBox.shrink();
                        }
                        return FittedBox(
                          child: Row(
                            children: [
                              Text(
                                "FLUTTER WEB",
                                style: TextStyle(
                                  fontSize: 40,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Icon(
                                Icons.flutter_dash,
                                color: Theme.of(context).colorScheme.onPrimary,
                                size: 40,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    alignment: Alignment.centerRight,
                    child: const FittedBox(child: SiteButton()),
                  ),
                ),
              ],
            )));
  }
}
