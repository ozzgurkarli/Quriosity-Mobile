// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/USize.dart';

class USegmentedButton extends StatelessWidget {
  Set<String> selected;
  List<ButtonSegment<String>> segments;
  Function(Set<String>) onSelectionChanged;
  USegmentedButton(
      {super.key, required this.onSelectionChanged, required this.selected, required this.segments});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: USize.Width * 0.8,
      child: SegmentedButton(
        showSelectedIcon: false,
          style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              elevation: const WidgetStatePropertyAll(8),
              shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)))),
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return UColor.SecondHeavyColor;
                  }
                  return UColor.ThirdColor;
                },
              ),
              shadowColor: const WidgetStatePropertyAll(Colors.black)),
          emptySelectionAllowed: false,
          segments: segments,
          onSelectionChanged: onSelectionChanged,
          multiSelectionEnabled: false,
          selected: selected),
    );
  }
}
