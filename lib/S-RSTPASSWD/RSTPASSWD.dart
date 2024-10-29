import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:quriosity/S-LOGINACC/LOGINACC.dart';
import 'package:quriosity/api/IService.dart';
import 'package:quriosity/api/UProxy.dart';
import 'package:quriosity/components/UButton.dart';
import 'package:quriosity/components/UScaffold.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/components/UTextButton.dart';
import 'package:quriosity/components/UTextField.dart';
import 'package:quriosity/helpers/HelperMethods.dart';
import 'package:quriosity/helpers/Localizer.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/URequestType.dart';
import 'package:quriosity/helpers/USize.dart';

class RSTPASSWD extends StatefulWidget {
  const RSTPASSWD({super.key});

  @override
  State<RSTPASSWD> createState() => _RSTPASSWDState();
}

class _RSTPASSWDState extends State<RSTPASSWD> {
  final shakeKey = GlobalKey<ShakeWidgetState>();
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
                height: USize.Height / 13,
              ),
              UText(
                "QURIOSITY",
                fontSize: 45,
                googleFonts: true,
                fontWeight: FontWeight.w600,
                color: UColor.WhiteHeavyColor,
              ),
              SizedBox(
                height: USize.Height / 5,
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
                maxLength: 15,
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
              ShakeMe(
                key: shakeKey,
                shakeCount: 3,
                shakeOffset: 5,
                shakeDuration: const Duration(milliseconds: 500),
                child: UButton(
                    onPressed: () {
                      bool error = false;
                      if (usernameController.text.length < 4) {
                        HelperMethods.SetSnackBar(
                            context,
                            Localizer.Get(Localizer
                                .username_cannot_be_less_than_4_characters),
                            errorBar: true);
                        error = true;
                      }
                      if (emailController.text.split('@').length < 2 ||
                          emailController.text.split('.c').length < 2) {
                        HelperMethods.SetSnackBar(
                            context, Localizer.Get(Localizer.invalid_email),
                            errorBar: true);
                        error = true;
                      }
                      if (error) {
                        shakeKey.currentState?.shake();
                        return;
                      }
                      HelperMethods.SetLoadingScreen(context);
                      UProxy.Request(URequestType.GET, IService.RESET_PASSWORD, param: "${usernameController.text}/${Uri.encodeComponent(emailController.text)}");
                      HelperMethods.SetSnackBar(context, Localizer.Get(Localizer.check_email_for_link), duration: const Duration(seconds: 10));
                      Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LOGINACC()),
                            (route) => false);
                    },
                    child: UText(
                      Localizer.Get(Localizer.im_ready),
                      color: UColor.PrimaryColor,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              SizedBox(height: USize.Height/12,),
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
