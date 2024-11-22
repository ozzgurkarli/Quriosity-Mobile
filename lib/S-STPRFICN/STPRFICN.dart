import 'package:flutter/material.dart';
import 'package:quriosity/components/UScaffold.dart';
import 'package:quriosity/helpers/Pool.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/USize.dart';

class STPRFICN extends StatefulWidget {
  const STPRFICN({super.key});

  @override
  State<STPRFICN> createState() => _STPRFICNState();
}

class _STPRFICNState extends State<STPRFICN> {
  late Color borderColor;
  @override
  Widget build(BuildContext context) {
    return UScaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              width: USize.Width*0.9,
              height: USize.Height*0.2*UAsset.PROFILE_ICONS.length,
              child: GridView.builder(
                itemCount: UAsset.PROFILE_ICONS.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  borderColor = index == Pool.User.ProfileIcon! ? UColor.GreenHeavyColor : Colors.transparent;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        border: Border(top: BorderSide(color: borderColor,width: 5), bottom: BorderSide(color: borderColor,width: 5), left: BorderSide(color: borderColor,width: 5), right: BorderSide(color: borderColor,width: 5))
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(UAsset.PROFILE_ICONS[index]),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
