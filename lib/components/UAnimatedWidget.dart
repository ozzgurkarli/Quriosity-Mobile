// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class UAnimatedWidget extends StatefulWidget {
  Widget? child;
  int? milliseconds;
  bool trigger = false;
  UAnimatedWidget({super.key, required this.child, this.milliseconds});

  @override
  State<UAnimatedWidget> createState() => _UAnimatedWidgetState();
}

class _UAnimatedWidgetState extends State<UAnimatedWidget> {
  double scale = 0;
  @override
  void initState() {
    super.initState();
    animation();
  }

  void animation() async {
    while (scale < 1) {
      setState(() {
        if (scale > 0.95) {
          scale = 1;
        } else {
          scale += 0.1;
        }
      });
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: Duration(milliseconds: widget.milliseconds ?? 500),
      child: widget.child
    );
  }
}
