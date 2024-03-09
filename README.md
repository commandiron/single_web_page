# single_web_page

Create Single Web Page Layout with adaptive scrollable implementations in Flutter.

## How it Looks
What does the code in the [example](https://pub.dev/packages/single_web_page/example) look like;

![](art/swp.gif)

## How to use

```
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
    );
    _controller.onScrollAnimationStart((currentIndex, targetIndex) {
      //Listen index on animation start.
    });
    _controller.onScrollAnimationEnd((currentIndex) {
      //Listen index on animation end.
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //If you want adaptive scroll, use AdaptiveSingleWebPage
    return SingleWebPage(
      controller: _controller, //Provide controller
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
```

## Note
Please keep this in mind when using this library. While creating this library, I never tried it on platforms other than the web.
