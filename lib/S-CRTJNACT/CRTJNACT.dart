// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:quriosity/api/IService.dart';
import 'package:quriosity/api/UProxy.dart';
import 'package:quriosity/components/UButton.dart';
import 'package:quriosity/components/UIconButton.dart';
import 'package:quriosity/components/UScaffold.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/components/UTextField.dart';
import 'package:quriosity/dto/DTOCommunity.dart';
import 'package:quriosity/helpers/HelperMethods.dart';
import 'package:quriosity/helpers/Localizer.dart';
import 'package:quriosity/helpers/Pool.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/URequestType.dart';
import 'package:quriosity/helpers/USize.dart';

class CRTJNACT extends StatefulWidget {
  const CRTJNACT({super.key});

  @override
  State<CRTJNACT> createState() => _CRTJNACTState();
}

class _CRTJNACTState extends State<CRTJNACT> {
  final shakeKeyJoin = GlobalKey<ShakeWidgetState>();
  final shakeKeyCreate = GlobalKey<ShakeWidgetState>();
  TextEditingController invitationLinkController = TextEditingController();
  TextEditingController communityNameController = TextEditingController();
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
                Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: USize.Width / 50, right: USize.Width / 50),
                      child: UIconButton(
                          icon: const Icon(
                        Icons.person,
                        color: UColor.WhiteHeavyColor,
                      )),
                    ))
              ],
            ),
            SizedBox(
              height: USize.Height / 4,
            ),
            UTextField(
              controller: invitationLinkController,
              maxLength: 12,
              hintText: Localizer.Get(Localizer.invitation_code),
              fillColor: UColor.WhiteHeavyColor,
              prefixIcon: const Icon(Icons.share),
              suffixIcon: ShakeMe(
                  key: shakeKeyJoin,
                  shakeCount: 3,
                  shakeOffset: 5,
                  shakeDuration: const Duration(milliseconds: 500),
                  child: UButton(
                      color: UColor.SecondHeavyColor,
                      onPressed: () async {
                        shakeKeyJoin.currentState?.shake();
                        if (invitationLinkController.text.length != 12) {
                          HelperMethods.SetSnackBar(
                              context,
                              Localizer.Get(Localizer
                                  .invitation_code_cannot_be_less_than_8_characters));
                        }
                        try {
                          await UProxy.Request(
                              URequestType.GET, IService.JOIN_COMMUNITY,
                              param:
                                  "${invitationLinkController.text}/${Pool.User.uid}");
                          Navigator.pop(context);
                        } catch (e) {
                          HelperMethods.ApiException(context, e);
                        }
                      },
                      child: UText(
                        Localizer.Get(Localizer.join),
                        fontWeight: FontWeight.w500,
                      ))),
              onChanged: (p0) {
                String filteredValue = p0.replaceAll(RegExp(r'[^A-Z0-9]'), '');

                if (filteredValue != p0) {
                  invitationLinkController.text = filteredValue;
                  invitationLinkController.selection =
                      TextSelection.fromPosition(
                    TextPosition(offset: filteredValue.length),
                  );
                }
              },
              prefixColor: UColor.PrimaryColor,
            ),
            SizedBox(
              height: USize.Height / 20,
            ),
            SizedBox(
              width: USize.Width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 1,
                    width: USize.Width * 0.25,
                    decoration:
                        const BoxDecoration(color: UColor.WhiteHeavyColor),
                  ),
                  Expanded(child: UText(Localizer.Get(Localizer.or))),
                  Container(
                    height: 1,
                    width: USize.Width * 0.25,
                    decoration:
                        const BoxDecoration(color: UColor.WhiteHeavyColor),
                  )
                ],
              ),
            ),
            SizedBox(
              height: USize.Height / 20,
            ),
            UTextField(
              controller: communityNameController,
              maxLength: 30,
              hintText: Localizer.Get(Localizer.community_name),
              fillColor: UColor.WhiteHeavyColor,
              prefixIcon: const Icon(Icons.diversity_3),
              suffixIcon: ShakeMe(
                  key: shakeKeyCreate,
                  shakeCount: 3,
                  shakeOffset: 5,
                  shakeDuration: const Duration(milliseconds: 500),
                  child: UButton(
                      color: UColor.SecondHeavyColor,
                      onPressed: () async {
                        if (communityNameController.text.length < 4) {
                          shakeKeyCreate.currentState?.shake();
                          HelperMethods.SetSnackBar(
                              context,
                              Localizer.Get(Localizer
                                  .community_name_cannot_be_less_than_4_characters),
                              errorBar: true);
                          return;
                        }
                        HelperMethods.SetLoadingScreen(context);
                        DTOCommunity dtoCommunity = DTOCommunity(
                            CommunityName: communityNameController.text.trim(),
                            Participants: [
                              {'uid': Pool.User.uid, 'flag': 0}
                            ]);
                        try {
                          await UProxy.Request(
                              URequestType.POST, IService.CREATE_COMMUNITY,
                              data: dtoCommunity.toJson());
                          HelperMethods.SetSnackBar(context,
                              Localizer.Get(Localizer.community_created));
                          int count = 0;
                          Navigator.of(context).popUntil((_) => count++ >= 2);
                        } catch (e) {
                          HelperMethods.ApiException(context, e);
                        }
                      },
                      child: UText(
                        Localizer.Get(Localizer.create),
                        fontWeight: FontWeight.w500,
                      ))),
              onChanged: (p0) {
                String filteredValue =
                    p0.replaceAll(RegExp(r'[^a-zA-ZçÇğĞıİöÖşŞüÜ\s]'), '');

                if (filteredValue != p0) {
                  communityNameController.text = filteredValue;
                  communityNameController.selection =
                      TextSelection.fromPosition(
                    TextPosition(offset: filteredValue.length),
                  );
                }
              },
              prefixColor: UColor.PrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
