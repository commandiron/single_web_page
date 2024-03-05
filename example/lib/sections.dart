import 'package:flutter/material.dart';

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
      color: Theme.of(context).colorScheme.primary,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "FLUTTER WEB",
            style: TextStyle(
                fontSize: 240,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary),
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
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).colorScheme.secondaryContainer,
      alignment: Alignment.center,
      child: Text(
        "Section 2",
        style: TextStyle(fontSize: 50, color: Theme.of(context).colorScheme.onSecondaryContainer),
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
      color: Theme.of(context).colorScheme.primary,
      alignment: Alignment.center,
      child: Text(
        "Section 3",
        style: TextStyle(fontSize: 50, color: Theme.of(context).colorScheme.onSecondaryContainer),
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
        style: TextStyle(fontSize: 50, color: Theme.of(context).colorScheme.onSecondaryContainer),
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
      color: Theme.of(context).colorScheme.primary,
      alignment: Alignment.center,
      child: Text(
        "Section 5",
        style: TextStyle(fontSize: 50, color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
    );
  }
}
