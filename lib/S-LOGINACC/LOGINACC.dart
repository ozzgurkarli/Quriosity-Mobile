// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:quriosity/S-CRTACCTO/CRTACCTO.dart';
import 'package:quriosity/S-HOMESCRN/HOMESCRN.dart';
import 'package:quriosity/S-RSTPASSWD/RSTPASSWD.dart';
import 'package:quriosity/api/ENV.dart';
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
import 'package:quriosity/helpers/Pool.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/URequestType.dart';
import 'package:quriosity/helpers/USize.dart';

class LOGINACC extends StatefulWidget {
  const LOGINACC({super.key});

  @override
  State<LOGINACC> createState() => _LOGINACCState();
}

class _LOGINACCState extends State<LOGINACC> {
  final shakeKey = GlobalKey<ShakeWidgetState>();
  bool passwordObsecure = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                    alignment: Alignment.centerRight,
                    child: Padding(
                padding: EdgeInsets.only(left: USize.Width / 1.5),
                child: UTextButton(
                  onPressed: () {
                    setState(() {
                      Localizer.index = Localizer.index == 0 ? 1 : 0;
                    });
                  },
                  child: UText(
                    Localizer.Get(Localizer.index_text),
                    color: UColor.WhiteColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),)
              ],
            ),
              SizedBox(
                height: USize.Height / 4,
              ),
              UTextField(
                controller: usernameController,
                hintText: Localizer.Get(Localizer.username),
                fillColor: UColor.WhiteHeavyColor,
                maxLength: 15,
                prefixIcon: const Icon(Icons.person_3),
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
                prefixColor: UColor.PrimaryColor,
              ),
              SizedBox(
                height: USize.Height / 67,
              ),
              UTextField(
                controller: passwordController,
                obsecureText: passwordObsecure,
                hintText: Localizer.Get(Localizer.password),
                fillColor: UColor.WhiteHeavyColor,
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
                  child: const Icon(Icons.remove_red_eye_sharp),
                ),
                prefixIcon: const Icon(Icons.password_outlined),
                prefixColor: UColor.PrimaryColor,
              ),
              SizedBox(
                height: USize.Height / 33,
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
                      if (usernameController.text.length < 4) {
                        HelperMethods.SetSnackBar(
                            context,
                            Localizer.Get(Localizer
                                .username_cannot_be_less_than_4_characters),
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

                      if (error) {
                        shakeKey.currentState?.shake();
                        return;
                      }

                      HelperMethods.SetLoadingScreen(context);
                      DTOUser dtoUser = DTOUser(
                        NotificationToken: ENV.NotificationToken,
                          Username: usernameController.text,
                          Password: passwordController.text);
                      try {
                        dtoUser = DTOUser.fromJson(await UProxy.Request(
                            URequestType.POST, IService.LOGIN,
                            data: dtoUser.toJson()));

                        if (dtoUser.uid != null) {
                          Pool.User = dtoUser;
                          ENV.UserToken = dtoUser.UserToken;
                          HelperMethods.InsertData();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HOMESCRN()),
                              (route) => false);
                        }
                      } catch (e) {
                        ENV.ConnectionString = ENV.ConnectionStringList[2];
                        HelperMethods.ApiException(context, e, key: shakeKey);
                      }
                    },
                    child: UText(
                      Localizer.Get(Localizer.login),
                      color: UColor.PrimaryColor,
                      fontWeight: FontWeight.w600,
                    )),
              ),
              SizedBox(
                height: USize.Height / 50,
              ),
              SizedBox(
                height: USize.Height / 5,
              ),
              UTextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CRTACCTO()));
                  },
                  child: UText(
                    Localizer.Get(Localizer.create_an_account_start_asking),
                    fontWeight: FontWeight.w500,
                  )),
              UTextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RSTPASSWD()));
                  },
                  child: UText(
                    Localizer.Get(Localizer.password_what_password),
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
