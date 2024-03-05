import 'package:example/sections.dart';
import 'package:example/widget/menu_button.dart';
import 'package:example/widget/site_button.dart';
import 'package:flutter/material.dart';
import 'package:single_web_page/adaptive_single_web_page.dart';
import 'package:single_web_page/single_web_page_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SWPMaterialApp();
  }
}

class SWPMaterialApp extends StatelessWidget {
  const SWPMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xff010203),
          onPrimary: Color(0xffBABABA),
          secondary: Color(0xff008CFF),
          onSecondary: Colors.white,
          secondaryContainer: Color(0xff0D0D0D),
          onSecondaryContainer: Colors.white,
        ),
      ),
      home: const SingleWebPageExample(),
    );
  }
}

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
        ),
      ),
    );
  }
}