import 'package:flutter/material.dart';
import 'single_web_page_example.dart';

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
      home: const SingleWebPageExample()
    );
  }
}
