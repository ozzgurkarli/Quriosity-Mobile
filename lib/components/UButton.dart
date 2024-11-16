// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class UButton extends StatefulWidget {
  final VoidCallback? onPressed;
  Widget? child;
  Color? color;

  UButton({
    super.key,
    required this.onPressed,
    required this.color,
    required this.child
  });
  @override
  State<UButton> createState() => _UButtonState();
}

class _UButtonState extends State<UButton> {
  double scale = 1;

  void onTapDown(TapDownDetails details) {
    setState(() {
      scale = 0.9;
    });
  }

  void onTapUp(TapUpDetails details) {
    setState(() {
      scale = 1;
    });
  }

  void onTapCancel() {
    setState(() {
      scale = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 500),
        child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                elevation: const WidgetStatePropertyAll(8),
                shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)))),
                backgroundColor: WidgetStatePropertyAll(widget.color),
                shadowColor: const WidgetStatePropertyAll(Colors.black)),
            child: widget.child),
      ),
    );
  }
}
