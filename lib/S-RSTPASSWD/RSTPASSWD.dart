import 'package:flutter/material.dart';
import 'package:quriosity/components/UButton.dart';
import 'package:quriosity/components/UScaffold.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/components/UTextButton.dart';
import 'package:quriosity/components/UTextField.dart';
import 'package:quriosity/helpers/HelperMethods.dart';
import 'package:quriosity/helpers/Localizer.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/USize.dart';

class RSTPASSWD extends StatefulWidget {
  const RSTPASSWD({super.key});

  @override
  State<RSTPASSWD> createState() => _RSTPASSWDState();
}

class _RSTPASSWDState extends State<RSTPASSWD> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return UScaffold(
      body: Container(
        height: USize.Height,
        width: USize.Width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(UAsset.WALLPAPER_VERTICAL),
              fit: BoxFit.cover,
              opacity: 1,
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7), BlendMode.darken)),
        ),
        child: Center(
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
                height: USize.Height / 6,
              ),
              SizedBox(
                width: USize.Width * 0.7,
                child: UText(
                  Localizer.Get(
                      Localizer.dont_panic_if_you_forgot_your_password),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: USize.Height / 33,
              ),
              UTextField(
                controller: usernameController,
                hintText: Localizer.Get(Localizer.username),
                onChanged: (p0) {
                  String filteredValue =
                      p0.replaceAll(RegExp(r'[^a-z0-9]'), '');

                  if (filteredValue != p0) {
                    usernameController.text = filteredValue;
                    usernameController.selection = TextSelection.fromPosition(
                      TextPosition(offset: filteredValue.length),
                    );
                  }
                },
                fillColor: UColor.WhiteHeavyColor,
                prefixIcon: const Icon(Icons.contact_emergency),
                prefixColor: UColor.PrimaryColor,
              ),
              SizedBox(
                height: USize.Height / 33,
              ),
              UTextField(
                controller: emailController,
                hintText: Localizer.Get(Localizer.e_mail),
                onChanged: (p0) {
                  String filteredValue =
                      p0.replaceAll(RegExp(r'[^a-zA-Z0-9@._%+-]'), '');
                  if (filteredValue != p0) {
                    emailController.text = filteredValue;
                    emailController.selection = TextSelection.fromPosition(
                      TextPosition(offset: filteredValue.length),
                    );
                  }
                },
                fillColor: UColor.WhiteHeavyColor,
                prefixIcon: const Icon(Icons.mail),
                prefixColor: UColor.PrimaryColor,
              ),
              SizedBox(
                height: USize.Height / 12,
              ),
              UButton(
                  onPressed: () {
                    HelperMethods.SetLoadingScreen(context);
                  },
                  child: UText(
                    Localizer.Get(Localizer.im_ready),
                    color: UColor.PrimaryColor,
                    fontWeight: FontWeight.w600,
                  )),
              UTextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: UText(
                    Localizer.Get(Localizer.just_remembered_password),
                    fontWeight: FontWeight.w500,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
