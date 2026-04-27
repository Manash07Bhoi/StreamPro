import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin SafePopMixin<T extends StatefulWidget> on State<T> {
  bool canPop = false;

  void safePop() {
    if (canPop) return;
    HapticFeedback.selectionClick();
    setState(() {
      canPop = true;
    });
    // Let the frame build with canPop: true, then pop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }
}
