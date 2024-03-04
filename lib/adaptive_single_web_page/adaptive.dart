import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Adaptive extends StatelessWidget {
  final bool debugMode;
  final Widget mobile;
  final Widget desktop;
  Adaptive({
    super.key,
    this.debugMode = false,
    required this.mobile,
    required this.desktop,
  }){
    if(debugMode) {
      debugPrint("Adaptive Widget in debugMode!!!");
    }
  }

  static bool isMobile() =>
      defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android;

  static bool isDesktop() =>
      defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.macOS;

  static bool isIOS() =>
      defaultTargetPlatform == TargetPlatform.iOS;

  static bool isMac() =>
      defaultTargetPlatform == TargetPlatform.macOS;

  static bool isWindows() =>
      defaultTargetPlatform == TargetPlatform.windows;

  static dynamic getValue(
    mobileValue,
    desktopValue,
  ) {
    if(defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
      return mobileValue;
    }
    return desktopValue;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
          return mobile;
        }
        return desktop;
      },
    );
  }
}