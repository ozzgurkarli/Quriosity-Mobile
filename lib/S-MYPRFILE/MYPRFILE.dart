import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quriosity/S-LOGINACC/LOGINACC.dart';
import 'package:quriosity/S-STPRFICN/STPRFICN.dart';
import 'package:quriosity/api/IService.dart';
import 'package:quriosity/api/UProxy.dart';
import 'package:quriosity/components/UAnimatedWidget.dart';
import 'package:quriosity/components/UIconButton.dart';
import 'package:quriosity/components/UScaffold.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/components/UTextButton.dart';
import 'package:quriosity/helpers/HelperMethods.dart';
import 'package:quriosity/helpers/Localizer.dart';
import 'package:quriosity/helpers/Pool.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/URequestType.dart';
import 'package:quriosity/helpers/USize.dart';

class MYPRFILE extends StatefulWidget {
  const MYPRFILE({super.key});

  @override
  State<MYPRFILE> createState() => _MYPRFILEState();
}

class _MYPRFILEState extends State<MYPRFILE> {
  @override
  Widget build(BuildContext context) {
    return UScaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: USize.Height / 13,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                UAnimatedWidget(
                  child: SizedBox(
                    child: UText(
                      "QURIOSITY",
                      fontSize: 45,
                      googleFonts: true,
                      fontWeight: FontWeight.w600,
                      color: UColor.WhiteHeavyColor,
                    ),
                  ),
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
            Gap(USize.Height * 0.08),
            UAnimatedWidget(
              child: SizedBox(
                  width: USize.Height * 0.15,
                  height: USize.Height * 0.15,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(
                        UAsset.PROFILE_ICONS[Pool.User.ProfileIcon!]),
                  )),
            ),
            UTextButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const STPRFICN()));
                  setState(() {});
                },
                child: UText(
                  Localizer.GetRandom(Localizer.change_icon),
                )),
            Gap(USize.Height * 0.15),
            SizedBox(
              width: USize.Width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UText(
                  "${Localizer.Get(Localizer.language_preference)}:"),
                  UTextButton(
                    onPressed: () {
                      setState(() {
                        HelperMethods.InsertIndex();
                      });
                    },
                    child: UText(
                      Localizer.index_text[(Localizer.index + 1) % 2],
                      color: UColor.WhiteColor,
                      fontWeight: FontWeight.w800,
                    ),
                  )
                ],
              ),
            ),
            Gap(USize.Height * 0.15),
            UTextButton(
                onPressed: () {
                  Pool.User.NotificationToken = null;
                  UProxy.Request(URequestType.POST, IService.LOGIN,
                      data: Pool.User.toJson());
                  HelperMethods.DeleteData();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LOGINACC()),
                      (route) => false);
                },
                child: UText(
                  Localizer.Get(Localizer.log_out),
                  color: UColor.RedColor,
                )),
          ],
        ),
      ),
    );
  }
}
