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

class RSTPASSWD extends StatefulWidget {
  const RSTPASSWD({super.key});

  @override
  State<RSTPASSWD> createState() => _RSTPASSWDState();
}

class _RSTPASSWDState extends State<RSTPASSWD> {
  TextEditingController usernameController = TextEditingController();

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
                width: USize.Width*0.7,
                child: UText(
                    "Parolanı unuttun diye panik yapma! Eğer girdiğin kullanıcı adı ve e-posta birbiriyle iyi anlaşıyorsa, sana yeni bir parola oluşturma bağlantısı göndereceğiz.", fontWeight: FontWeight.w500,),
              ),
              SizedBox(height: USize.Height/33,),
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
                      "Parolanı yeni mi hatırladın?\nGeri dönmek için geç değil.",
                fontWeight: FontWeight.w500,))
            ],
          ),
        ),
      ),
    );
  }
}
