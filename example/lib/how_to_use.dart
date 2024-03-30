import 'package:flutter/material.dart';
import 'package:single_web_page/single_web_page.dart';
import 'package:single_web_page/single_web_page_controller.dart';

class HowToUseSingleWebPage extends StatefulWidget {
  const HowToUseSingleWebPage({super.key});

  @override
  State<HowToUseSingleWebPage> createState() => _HowToUseSingleWebPageState();
}

class _HowToUseSingleWebPageState extends State<HowToUseSingleWebPage> {
  late final SingleWebPageController _controller;

  @override
  void initState() {
    _controller = SingleWebPageController(
      //Specify snap for each index (default topSnap)
      snaps: [Snap.topSnap, Snap.centerSnap, Snap.bottomSnap],
      //Specify extra offset for topSnaps
      topSnapExtraOffset: 0,
      //Specify extra offset for centerSnaps
      centerSnapExtraOffset: 0,
      //Specify extra offset for bottomSnaps
      bottomSnapExtraOffset: 0,
      onAnimatedScrollStart: (currentIndex, targetIndex) {
        //Listen index on animated scroll start
      },
      onAnimatedScrollEnd: (currentIndex) {
        //Listen index on animated scroll end
      },
      onScrollEnd: (lastVisibleIndex) {
        //Listen last visible index on (non-animated) scroll end
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleWebPage(
      controller: _controller, //Provide controller
      singleWebPagePhysics: SingleWebPagePhysics.adaptive, //Specify physics
      sliverAppBar: null, //Specify sliverAppBar if you want
      sections: [
        //Specify sections
        Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Section 1"),
              ElevatedButton(
                //Animate to index easily (Provided snap is applied)
                onPressed: () => _controller.animateToSectionIndex(1),
                child: const Text("To Section 2"),
              ),
              ElevatedButton(
                onPressed: () => _controller.animateToSectionIndex(2),
                child: const Text("To Section 3"),
              )
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 2,
          color: Colors.grey,
          alignment: Alignment.center,
          child: const Text("Section 2"),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 2,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Section 3"),
              ElevatedButton(
                onPressed: () => _controller.animateToSectionIndex(0),
                child: const Text("To Top"),
              )
            ],
          ),
        ),
      ],
    );
  }
}
