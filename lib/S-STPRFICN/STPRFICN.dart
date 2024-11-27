import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quriosity/api/IService.dart';
import 'package:quriosity/api/UProxy.dart';
import 'package:quriosity/components/UButton.dart';
import 'package:quriosity/components/UIconButton.dart';
import 'package:quriosity/components/UScaffold.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/helpers/Pool.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/URequestType.dart';
import 'package:quriosity/helpers/USize.dart';

class STPRFICN extends StatefulWidget {
  const STPRFICN({super.key});

  @override
  State<STPRFICN> createState() => _STPRFICNState();
}

class _STPRFICNState extends State<STPRFICN> {
  int selectedIcon = Pool.User.ProfileIcon!;
  late Color borderColor;
  @override
  Widget build(BuildContext context) {
    return UScaffold(
      body: Center(
        child: Column(
          children: [
            Gap(USize.Height / 13),
            Stack(
              alignment: Alignment.center,
              children: [
                UText(
                  "QURIOSITY",
                  fontSize: 45,
                  googleFonts: true,
                  fontWeight: FontWeight.w600,
                  color: UColor.WhiteHeavyColor,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: USize.Width / 50, left: USize.Width / 50),
                      child: UIconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: UColor.WhiteHeavyColor,
                          )),
                    )),
              ],
            ),
            SizedBox(
              width: USize.Width * 0.9,
              height: USize.Height * 0.1 * UAsset.PROFILE_ICONS.length,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: UAsset.PROFILE_ICONS.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    borderColor = index == selectedIcon
                        ? UColor.ProfileIcons[selectedIcon]
                        : Colors.transparent;
                    return Padding(
                      padding: const EdgeInsets.all(24),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIcon = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(180),
                              border: Border(
                                  top: BorderSide(color: borderColor, width: 5),
                                  bottom:
                                      BorderSide(color: borderColor, width: 5),
                                  left:
                                      BorderSide(color: borderColor, width: 5),
                                  right: BorderSide(
                                      color: borderColor, width: 5))),
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage(UAsset.PROFILE_ICONS[index % 4]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            UButton(
                onPressed: () {
                  if (Pool.User.ProfileIcon != selectedIcon) {
                    Pool.User.ProfileIcon = selectedIcon;
                    UProxy.Request(
                        URequestType.PUT, IService.UPDATE_PROFILE_ICON,
                        data: Pool.User.toJson());
                        Navigator.pop(context);
                  }
                },
                color: UColor.SecondHeavyColor,
                child: UText("seç"))
          ],
        ),
      ),
    );
  }
}
