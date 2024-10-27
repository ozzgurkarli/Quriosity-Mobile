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

class CRTACCTO extends StatefulWidget {
  const CRTACCTO({super.key});

  @override
  State<CRTACCTO> createState() => _CRTACCTOState();
}

class _CRTACCTOState extends State<CRTACCTO> {
  TextEditingController usernameController = TextEditingController();
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
              UTextField(
                controller: usernameController,
                hintText: "Ad Soyad",
                fillColor: UColor.WhiteHeavyColor,
                prefixIcon: const Icon(Icons.person_3),
                prefixColor: UColor.PrimaryColor,
              ),
              SizedBox(
                height: USize.Height / 33,
              ),
              UTextField(
                controller: usernameController,
                hintText: "Kullanıcı Adı",
                fillColor: UColor.WhiteHeavyColor,
                prefixIcon: const Icon(Icons.contact_emergency),
                prefixColor: UColor.PrimaryColor,
              ),
              SizedBox(
                height: USize.Height / 33,
              ),
              UTextField(
                controller: usernameController,
                hintText: "E-mail",
                fillColor: UColor.WhiteHeavyColor,
                prefixIcon: const Icon(Icons.mail),
                prefixColor: UColor.PrimaryColor,
              ),
              SizedBox(
                height: USize.Height / 33,
              ),
              UTextField(
                controller: usernameController,
                hintText: "Parola",
                obsecureText: passwordObsecure,
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
                controller: usernameController,
                hintText: "Parola (Tekrar)",
                obsecureText: passwordObsecure,
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
              UButton(
                  onPressed: () {
                    HelperMethods.SetLoadingScreen(context);
                  },
                  child: UText(
                    "Hazırım!",
                    color: UColor.PrimaryColor,
                    fontWeight: FontWeight.w600,
                  )),
              UTextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                  child: UText(
                      "Hesabın olduğunu yeni mi hatırladın?\nGeri dönmek için geç değil.",
                fontWeight: FontWeight.w500,))
            ],
          ),
        ),
      ),
    );
  }
}
