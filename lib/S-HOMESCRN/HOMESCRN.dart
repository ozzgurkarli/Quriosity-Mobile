import 'package:flutter/material.dart';
import 'package:quriosity/S-CRTJNACT/CRTJNACT.dart';
import 'package:quriosity/api/IService.dart';
import 'package:quriosity/api/UProxy.dart';
import 'package:quriosity/components/UButton.dart';
import 'package:quriosity/components/UIconButton.dart';
import 'package:quriosity/components/UScaffold.dart';
import 'package:quriosity/components/USegmentedButton.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/dto/DTOCommunity.dart';
import 'package:quriosity/helpers/HelperMethods.dart';
import 'package:quriosity/helpers/Localizer.dart';
import 'package:quriosity/helpers/Pool.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/URequestType.dart';
import 'package:quriosity/helpers/USize.dart';

class HOMESCRN extends StatefulWidget {
  const HOMESCRN({super.key});

  @override
  State<HOMESCRN> createState() => _HOMESCRNState();
}

class _HOMESCRNState extends State<HOMESCRN> {
  Set<String> segmentSelected = {"0"};
  Future<dynamic>? request;
  List<DTOCommunity> communityList = [];

  @override
  void initState() {
    super.initState();
    request = UProxy.Request(URequestType.GET, IService.COMMUNITIES,
        param: Pool.User.uid);
  }

  void newRequest() {
    request = UProxy.Request(URequestType.GET, IService.COMMUNITIES,
        param: Pool.User.uid);
  }

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
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 5.0, right: USize.Width / 50),
                      child: UIconButton(
                          icon: const Icon(
                        Icons.person,
                        color: UColor.WhiteHeavyColor,
                      )),
                    ))
              ],
            ),
            SizedBox(
              height: USize.Height / 17,
            ),
            USegmentedButton(
                segments: [
                  ButtonSegment(
                      value: '0',
                      label: UText(
                        Localizer.Get(Localizer.my_communities),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      )),
                  ButtonSegment(
                      value: '1',
                      label: UText(
                        Localizer.Get(Localizer.unopened),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ))
                ],
                onSelectionChanged: (p0) {
                  setState(() {
                    segmentSelected = p0;
                  });
                },
                selected: segmentSelected),
            SizedBox(
              height: USize.Height / 50,
            ),
            SizedBox(
              width: USize.Width * 0.7,
              child: UButton(
                primaryButton: true,
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CRTJNACT()));
                  newRequest();
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.diversity_3,
                          color: UColor.WhiteColor,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: UText(
                        Localizer.Get(Localizer.create_join_community),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: USize.Height / 50,
            ),
            Container(
              width: USize.Width * 0.7,
              height: USize.Height / 1.7,
              decoration: BoxDecoration(
                  color: UColor.WhiteHeavyColor,
                  borderRadius: BorderRadius.circular(15)),
              child: FutureBuilder(
                  future: request,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: HelperMethods.ShowAsset(UAsset.LOADING,
                            height: USize.Height / 17,
                            width: USize.Height / 17),
                      );
                    }
                    List<DTOCommunity> commList = [];
                    communityList = [];
                    bool newActivity = false;
                    for (var item in snapshot.data) {
                      communityList.add(DTOCommunity.fromJson(item));
                    }
                    communityList.sort(
                        (a, b) => b.LastActivity!.compareTo(a.LastActivity!));

                    if (segmentSelected.first == "0") {
                      commList = communityList;
                    } else if (segmentSelected.first == "1") {
                      for (var comm in communityList) {
                        for (var item in comm.Participants!) {
                          if (item["uid"] == Pool.User.uid && item["flag"] == 1) {
                            commList.add(comm);
                          }
                        }
                      }
                    }
                    return MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: ListView.builder(
                        itemCount: commList.length,
                        itemBuilder: (context, index) {
                          for (var item in commList[index].Participants!) {
                            if (item["uid"] == Pool.User.uid) {
                              newActivity = item["flag"] == 1;
                            }
                          }
                          return Column(
                            children: [
                              Container(height: index == 0 ? 0 : 0.5, width: USize.Width*0.7, color: UColor.ThirdColor,),
                              ListTile(
                                leading: Container(
                                  width: USize.Height / 77,
                                  height: USize.Height / 77,
                                  decoration: BoxDecoration(
                                      color: newActivity
                                          ? UColor.SecondHeavyColor
                                          : UColor.WhiteHeavyColor,
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                splashColor: Colors.transparent,
                                title: UText(
                                  commList[index].CommunityName!,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                                subtitle: UText(
                                  "${Localizer.Get(Localizer.last_activity)}${HelperMethods.CalculateLastActivityTime(commList[index].LastActivity!)}${Localizer.Get(Localizer.ago)}",
                                  color: UColor.ThirdColor,
                                ),
                                trailing: commList[index].Streak! > 2
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          UText(
                                            commList[index].Streak!.toString(),
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                          Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(bottom: 10),
                                              child: HelperMethods.ShowAsset(
                                                  UAsset.FIRE,
                                                  height: USize.Height / 33,
                                                  width: USize.Height / 50),
                                            ),
                                          )
                                        ],
                                      )
                                    : Container(
                                        width: USize.Height / 77,
                                        height: USize.Height / 77,
                                        decoration: BoxDecoration(
                                            color: UColor.WhiteHeavyColor,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                      ),
                                onTap: () {},
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
