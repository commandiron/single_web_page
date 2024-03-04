import 'package:flutter/material.dart';

class SiteButton extends StatelessWidget {
  const SiteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary),
        foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),
      onPressed: () {},
      child: const Text("Site Button", style: TextStyle(fontSize: 20),),
    );
  }
}
