import 'package:flutter/material.dart';

class AnimationConstants {
  // Durations
  static const micro = Duration(milliseconds: 80);
  static const fast = Duration(milliseconds: 160);
  static const normal = Duration(milliseconds: 280);
  static const slow = Duration(milliseconds: 400);
  static const verySlow = Duration(milliseconds: 600);
  static const shimmer = Duration(milliseconds: 1500);
  static const splash = Duration(milliseconds: 1800);

  // Curves
  static const curveEnter = Curves.easeOutCubic;
  static const curveExit = Curves.easeInCubic;
  static const curveBounce = Curves.elasticOut;
  static const curveSheetSlide = Curves.easeOutQuart;
  static const curveSpring = Curves.easeOutBack;
}
