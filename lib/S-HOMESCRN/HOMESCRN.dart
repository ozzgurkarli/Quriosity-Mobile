import 'package:flutter/material.dart';
import 'package:quriosity/components/UButton.dart';
import 'package:quriosity/components/UScaffold.dart';
import 'package:quriosity/components/USegmentedButton.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/helpers/HelperMethods.dart';
import 'package:quriosity/helpers/Localizer.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/USize.dart';

class HOMESCRN extends StatefulWidget {
  const HOMESCRN({super.key});

  @override
  State<HOMESCRN> createState() => _HOMESCRNState();
}

class _HOMESCRNState extends State<HOMESCRN> {
  Set<String> segmentSelected = {"0"};
  @override
  Widget build(BuildContext context) {
    return UScaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: USize.Height / 10,
            ),
            UText(
              "QURIOSITY",
              fontSize: 45,
              googleFonts: true,
              fontWeight: FontWeight.w600,
              color: UColor.WhiteHeavyColor,
            ),
            SizedBox(
              height: USize.Height / 17,
            ),
            USegmentedButton(
                segments: [
                  ButtonSegment(
                      value: '0',
                      label: UText(
                        Localizer.Get(Localizer.my_communities),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      )),
                  ButtonSegment(
                      value: '1',
                      label: UText(
                        Localizer.Get(Localizer.unopened),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ))
                ],
                onSelectionChanged: (p0) {
                  setState(() {
                    segmentSelected = p0;
                  });
                },
                selected: segmentSelected),
            SizedBox(
              height: USize.Height / 50,
            ),
            SizedBox(
              width: USize.Width * 0.7,
              child: UButton(
                primaryButton: true,
                onPressed: () {},
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: const Icon(
                          Icons.diversity_3,
                          color: UColor.WhiteColor,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: UText("Topluluk Oluştur/Katıl"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: USize.Height / 50,
            ),
            Container(
              width: USize.Width * 0.7,
              height: USize.Height / 1.7,
              decoration: BoxDecoration(
                  color: UColor.WhiteHeavyColor,
                  borderRadius: BorderRadius.circular(15)),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView(
                  children: [
                    ListTile(
                      leading: Container(
                        width: USize.Height / 77,
                        height: USize.Height / 77,
                        decoration: BoxDecoration(
                            color: UColor.SecondHeavyColor,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      splashColor: Colors.transparent,
                      title: UText(
                        "GRUPDIDDIDIIR",
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      subtitle: UText(
                        "Son soru: 3dk önce",
                        color: UColor.ThirdColor,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          UText(
                            "8",
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: HelperMethods.ShowAsset(UAsset.FIRE,
                                  height: USize.Height / 33,
                                  width: USize.Height / 50),
                            ),
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
