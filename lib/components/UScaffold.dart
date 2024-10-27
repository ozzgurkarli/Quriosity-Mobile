// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:quriosity/helpers/UColor.dart';

class UScaffold extends StatefulWidget {
  Widget? body;
  List<Widget>? actions;
  Widget? leading;
  Widget? title;
  bool? isLogged;
  FloatingActionButton? floatingActionButton;

  UScaffold(
      {super.key,
      this.body,
      this.isLogged,
      this.actions,
      this.leading,
      this.floatingActionButton,
      this.title});

  @override
  State<UScaffold> createState() => _UScaffoldState();
}

class _UScaffoldState extends State<UScaffold> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UColor.PrimaryColor,
      
      body: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(child: widget.body)),
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
