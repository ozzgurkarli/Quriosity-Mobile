import 'package:flutter/material.dart';
import 'package:quriosity/components/UButton.dart';
import 'package:quriosity/components/UScaffold.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/components/UTextButton.dart';
import 'package:quriosity/components/UTextField.dart';
import 'package:quriosity/helpers/HelperMethods.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/USize.dart';

class LOGINACC extends StatefulWidget {
  const LOGINACC({super.key});

  @override
  State<LOGINACC> createState() => _LOGINACCState();
}

class _LOGINACCState extends State<LOGINACC> {
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
                height: USize.Height / 4,
              ),
              UText(
                "QURIOSITY",
                fontSize: 45,
                googleFonts: true,
                fontWeight: FontWeight.w600,
                color: UColor.WhiteHeavyColor,
              ),
              SizedBox(
                height: USize.Height / 12,
              ),
              UTextField(
                controller: usernameController,
                hintText: "Kullanıcı Adı",
                fillColor: UColor.WhiteHeavyColor,
                prefixIcon: const Icon(Icons.person_3),
                prefixColor: UColor.PrimaryColor,
              ),
              SizedBox(
                height: USize.Height / 67,
              ),
              UTextField(
                controller: passwordController,
                obsecureText: passwordObsecure,
                hintText: "Parola",
                fillColor: UColor.WhiteHeavyColor,
                suffixIcon: GestureDetector(onTap: (){
                  setState(() {
                    passwordObsecure = !passwordObsecure;
                  });
                }, child: const Icon(Icons.remove_red_eye_sharp),),
                prefixIcon: const Icon(Icons.password_outlined),
                prefixColor: UColor.PrimaryColor,
              ),
              SizedBox(
                height: USize.Height / 100,
              ),
              UButton(
                  onPressed: () {HelperMethods.SetLoadingScreen(context);},
                  child: UText(
                    "Giriş Yap",
                    color: UColor.PrimaryColor,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(
                height: USize.Height / 50,
              ),
              SizedBox(
                height: USize.Height / 5,
              ),
              UTextButton(
                  child: UText(
                "Hesap oluştur, sormaya başla!",
                fontWeight: FontWeight.w500,
              )),
              UTextButton(
                  child: UText(
                "Parola? Ne parolası?",
                fontWeight: FontWeight.w500,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
