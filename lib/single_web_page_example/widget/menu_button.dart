import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, this.onPressed, required this.text});
  final void Function()? onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.onPrimary
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 20
          ),
        )
    );
  }
}