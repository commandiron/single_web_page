import 'package:flutter/cupertino.dart';
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
          primary: Color(0xff008CFF),
          onPrimary: Color(0xffffffff),
          primaryContainer: Color(0xff010203),
          onPrimaryContainer: Color(0xffffffff),
          secondaryContainer: Color(0xff0D0D0D),
          onSecondaryContainer: Color(0xffffffff),
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

  int _currentIndex = 0;

  @override
  void initState() {
    _controller = SingleWebPageController(
      snaps: [
        Snap.topSnap,
        Snap.topSnap,
        Snap.centerSnap,
        Snap.bottomSnap,
        Snap.bottomSnap
      ],
      topSnapExtraOffset: -collapsedHeight,
      centerSnapExtraOffset: collapsedHeight,
      onAnimatedScrollStart: (currentIndex, targetIndex) {
        setState(() {
          _currentIndex = targetIndex;
        });
      },
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
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      shadowColor: Colors.transparent,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      surfaceTintColor: Colors.transparent,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      toolbarHeight: toolbarHeight,
      snap: false,
      floating: false,
      pinned: true,
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  child: Row(
                    children: Section.sections
                        .asMap()
                        .entries
                        .map(
                          (e) => MenuButton(
                            onPressed: () =>
                                _controller.animateToSectionIndex(e.key),
                            isHighlighted: _currentIndex == e.key,
                            text: e.value.title,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            if(MediaQuery.of(context).size.width > 1200)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxHeight < 40) {
                        return const SizedBox.shrink();
                      }
                      return const FittedBox(
                        child: Row(
                          children: [
                            Text(
                              "FLUTTER WEB",
                              style: TextStyle(
                                fontSize: 40,
                                color: Color(0xffBABABA),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Icon(
                              Icons.flutter_dash,
                              color: Color(0xffBABABA),
                              size: 40,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            if(MediaQuery.of(context).size.width > 1200)
              Expanded(
                flex: 2,
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

class Section {
  final String title;
  final Widget widget;

  Section({
    required this.title,
    required this.widget,
  });

  static final List<Section> sections = [
    Section(
      title: "Section 1",
      widget: const Section1(),
    ),
    Section(
      title: "Section 2",
      widget: const Section2(),
    ),
    Section(
      title: "Section 3",
      widget: const Section3(),
    ),
    Section(
      title: "Section 4",
      widget: const Section4(),
    ),
    Section(
      title: "Section 5",
      widget: const Section5(),
    ),
  ];
}

class Section1 extends StatelessWidget {
  const Section1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          FittedBox(
            child: Text(
              "FLUTTER WEB",
              style: TextStyle(
                  fontSize: 240,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 128,
            ),
            child: Image.network(
              "https://storage.googleapis.com/cms-storage-bucket/780e0e64d323aad2cdd5.png",
              width: 1000,
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(
              vertical: 32,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    PrimaryScrollController.of(context).animateTo(
                      400,
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.ease,
                    );
                  },
                  icon: const Icon(
                    Icons.expand_circle_down_outlined,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Scroll Down",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Section2 extends StatelessWidget {
  const Section2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 60,
      color: Theme.of(context).colorScheme.secondaryContainer,
      alignment: Alignment.center,
      child: Text(
        "Section 2",
        style: TextStyle(
            fontSize: 50,
            color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
    );
  }
}

class Section3 extends StatelessWidget {
  const Section3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Text(
        "Section 3",
        style: TextStyle(
            fontSize: 50,
            color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
    );
  }
}

class Section4 extends StatelessWidget {
  const Section4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 300,
      color: Theme.of(context).colorScheme.secondaryContainer,
      alignment: Alignment.center,
      child: Text(
        "Section 4",
        style: TextStyle(
            fontSize: 50,
            color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
    );
  }
}

class Section5 extends StatelessWidget {
  const Section5({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: Theme.of(context).colorScheme.primaryContainer,
      alignment: Alignment.center,
      child: Text(
        "Section 5",
        style: TextStyle(
            fontSize: 50,
            color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    this.onPressed,
    required this.isHighlighted,
    required this.text,
  });

  final void Function()? onPressed;
  final bool isHighlighted;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(
            isHighlighted
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ));
  }
}

class SiteButton extends StatelessWidget {
  const SiteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
        foregroundColor:
            MaterialStatePropertyAll(Theme.of(context).colorScheme.onPrimary),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),
      onPressed: () {},
      child: const Text(
        "Site Button",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
