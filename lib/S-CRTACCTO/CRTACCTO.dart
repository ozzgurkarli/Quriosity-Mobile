// ignore_for_file: use_build_context_synchronously

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
import 'package:quriosity/dto/DTOUser.dart';
import 'package:quriosity/helpers/HelperMethods.dart';
import 'package:quriosity/helpers/Localizer.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/URequestType.dart';
import 'package:quriosity/helpers/USize.dart';

class CRTACCTO extends StatefulWidget {
  const CRTACCTO({super.key});

  @override
  State<CRTACCTO> createState() => _CRTACCTOState();
}

class _CRTACCTOState extends State<CRTACCTO> {
  final shakeKey = GlobalKey<ShakeWidgetState>();
  TextEditingController nameSurnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRepeatController = TextEditingController();
  bool passwordObsecure = true;
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: USize.Height / 12,
              ),
              UText(
                "QURIOSITY",
                fontSize: 45,
                googleFonts: true,
                fontWeight: FontWeight.w600,
                color: UColor.WhiteHeavyColor,
              ),
              SizedBox(
                height: USize.Height / 8,
              ),
              UTextField(
                controller: nameSurnameController,
                hintText: Localizer.Get(Localizer.name_surname),
                onChanged: (p0) {
                  String filteredValue =
                      p0.replaceAll(RegExp(r'[^a-zA-ZğüşöçĞÜŞÖÇİ\s]'), '');

                  if (filteredValue != p0) {
                    nameSurnameController.text = filteredValue;
                    nameSurnameController.selection =
                        TextSelection.fromPosition(
                      TextPosition(offset: filteredValue.length),
                    );
                  }
                },
                fillColor: UColor.WhiteHeavyColor,
                prefixIcon: const Icon(Icons.person_3),
                prefixColor: UColor.PrimaryColor,
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
                height: USize.Height / 33,
              ),
              UTextField(
                controller: passwordController,
                hintText: Localizer.Get(Localizer.password),
                obsecureText: passwordObsecure,
                onChanged: (p0) {
                  String filteredValue = p0.replaceAll(RegExp(r'\s'), '');
                  if (filteredValue != p0) {
                    passwordController.text = filteredValue;
                    passwordController.selection = TextSelection.fromPosition(
                      TextPosition(offset: filteredValue.length),
                    );
                  }
                },
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      passwordObsecure = !passwordObsecure;
                    });
                  },
                  child: const Icon(
                    Icons.remove_red_eye_sharp,
                    color: Colors.black,
                  ),
                ),
                fillColor: UColor.WhiteHeavyColor,
                prefixIcon: const Icon(Icons.password),
                prefixColor: UColor.PrimaryColor,
              ),
              SizedBox(
                height: USize.Height / 33,
              ),
              UTextField(
                controller: passwordRepeatController,
                hintText:
                    "${Localizer.Get(Localizer.password)} (${Localizer.Get(Localizer.again)})",
                obsecureText: passwordObsecure,
                onChanged: (p0) {
                  String filteredValue = p0.replaceAll(RegExp(r'\s'), '');
                  if (filteredValue != p0) {
                    passwordRepeatController.text = filteredValue;
                    passwordRepeatController.selection =
                        TextSelection.fromPosition(
                      TextPosition(offset: filteredValue.length),
                    );
                  }
                },
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      passwordObsecure = !passwordObsecure;
                    });
                  },
                  child: const Icon(
                    Icons.remove_red_eye_sharp,
                    color: Colors.black,
                  ),
                ),
                fillColor: UColor.WhiteHeavyColor,
                prefixIcon: const Icon(Icons.password),
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
                    color: UColor.WhiteHeavyColor,
                    onPressed: () async {
                      bool error = false;
                      if (nameSurnameController.text.split(' ').length < 2) {
                        HelperMethods.SetSnackBar(context,
                            Localizer.Get(Localizer.invalid_namesurname),
                            errorBar: true);
                        error = true;
                      }
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
                      if (passwordController.text.length < 8) {
                        HelperMethods.SetSnackBar(
                            context,
                            Localizer.Get(Localizer
                                .password_cannot_be_less_than_8_characters),
                            errorBar: true);
                        error = true;
                      }
                      if (passwordRepeatController.text !=
                          passwordController.text) {
                        HelperMethods.SetSnackBar(
                            context,
                            Localizer.Get(Localizer
                                .password_and_confirmation_does_not_match),
                            errorBar: true);
                        error = true;
                      }
                      if (error) {
                        shakeKey.currentState?.shake();
                        return;
                      }
                      HelperMethods.SetLoadingScreen(context);
                      DTOUser user = DTOUser(
                          NameSurname: nameSurnameController.text
                              .split(' ')
                              .map((word) => word.isNotEmpty
                                  ? word[0].toUpperCase() + word.substring(1)
                                  : '')
                              .join(' '),
                          Email: emailController.text,
                          Password: passwordController.text,
                          Username: usernameController.text);
                      try {
                        await UProxy.Request(
                            URequestType.POST, IService.ADD_USER,
                            data: user.toJson());
                        HelperMethods.SetSnackBar(
                            context, Localizer.Get(Localizer.account_created),
                            successBar: true, duration: const Duration(seconds: 10));
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LOGINACC()),
                            (route) => false);
                      } catch (e) {
                        HelperMethods.ApiException(context, e, key: shakeKey);
                      }
                    },
                    child: UText(
                      Localizer.Get(Localizer.im_ready),
                      color: UColor.PrimaryColor,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              SizedBox(
                height: USize.Height / 12,
              ),
              UTextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: UText(
                    Localizer.Get(Localizer.just_remembered_account),
                    fontWeight: FontWeight.w500,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
