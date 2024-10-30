// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:quriosity/components/UScaffold.dart';

class CMNTYHME extends StatefulWidget {
  String communityId;
  CMNTYHME({super.key, required this.communityId});

  @override
  State<CMNTYHME> createState() => _CMNTYHMEState();
}

class _CMNTYHMEState extends State<CMNTYHME> {
  @override
  Widget build(BuildContext context) {
    return UScaffold(
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}