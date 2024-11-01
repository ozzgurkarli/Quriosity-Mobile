// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:gap/gap.dart';
import 'package:quriosity/api/ENV.dart';
import 'package:quriosity/api/IService.dart';
import 'package:quriosity/api/UProxy.dart';
import 'package:quriosity/components/UButton.dart';
import 'package:quriosity/components/UScaffold.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/components/UTextField.dart';
import 'package:quriosity/dto/DTOMessage.dart';
import 'package:quriosity/helpers/HelperMethods.dart';
import 'package:quriosity/helpers/Localizer.dart';
import 'package:quriosity/helpers/Pool.dart';
import 'package:quriosity/helpers/UAsset.dart';
import 'package:quriosity/helpers/UColor.dart';
import 'package:quriosity/helpers/URequestType.dart';
import 'package:quriosity/helpers/USize.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CMNTYHME extends StatefulWidget {
  String communityId;
  CMNTYHME({super.key, required this.communityId});

  @override
  State<CMNTYHME> createState() => _CMNTYHMEState();
}

class _CMNTYHMEState extends State<CMNTYHME> {
  final shakeKey = GlobalKey<ShakeWidgetState>();
  TextEditingController messageController = TextEditingController();
  late final WebSocketChannel channel;
  List<DTOMessage> messages = [];
  double chatHeight = USize.Height * 0.37;
  bool chatExpanded = false;
  Future<dynamic>? futureMsg;

  @override
  void initState() {
    super.initState();
    futureMsg = UProxy.Request(URequestType.GET, IService.COMMUNITY_USERNAMES,
            param: widget.communityId)
        .then((users) {
      return UProxy.Request(URequestType.GET, IService.MESSAGES,
              param: widget.communityId)
          .then((v) {
        for (var i = 0; i < v.length; i++) {
          DTOMessage msg = DTOMessage.fromJson(v[i]);
          msg.SenderUsername = (users as List)
              .where((x) => x["uid"] == msg.senderuid)
              .first["id"];
          messages.add(msg);
        }
        listenChat();
        return v;
      });
    });
  }

  void listenChat() {
    channel = WebSocketChannel.connect(
      Uri.parse(
          'ws://${ENV.ConnectionString.substring(8)}messages/${widget.communityId}'),
    );

    bool firstRun = true;
    channel.stream.listen((message) {
      setState(() {
        if (firstRun) {
          firstRun = false;
          return;
        }
        messages.insert(0, DTOMessage.fromJson(jsonDecode(message)));
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UScaffold(
      body: Center(
        child: Column(
          children: [
            Gap(USize.Height * 0.07),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: USize.Height * 0.8 - chatHeight,
                  width: USize.Width * 0.8,
                  decoration: const BoxDecoration(color: UColor.PrimaryColor),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            removeBottom: true,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                showUsername(true, "ozzgur123321", true),
                                CustomPaint(
                                  painter: TrianglePainter(paintTriangle: true),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: USize.Width / 50,
                                          vertical: USize.Width / 67,
                                        ),
                                        decoration: const BoxDecoration(
                                          color: UColor.WhiteHeavyColor,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                        child: UText(
                                          "özge karadeniz bahçivan mıdır. özge karadeniz bahçivan mıdır. özge karadeniz bahçivan mıdır. ",
                                          color: UColor.PrimaryColor,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    UButton(
                      onPressed: () {},
                      child: UText(
                        "Soru Ekle",
                        color: UColor.PrimaryColor,
                      ),
                    ),
                    UButton(
                      onPressed: () {
                        setState(() {
                          if (chatExpanded) {
                            chatHeight = USize.Height * 0.3;
                            chatExpanded = false;
                          } else {
                            chatHeight = USize.Height * 0.57;
                            chatExpanded = true;
                          }
                        });
                      },
                      primaryButton: true,
                      child: UText(
                          chatExpanded ? "Sohbeti Küçült" : "Sohbeti Büyült"),
                    ),
                  ],
                ),
              ],
            ),
            Gap(USize.Height * 0.01),
            Container(
                height: USize.Height * 0.08,
                width: USize.Width * 0.8,
                decoration: const BoxDecoration(color: UColor.PrimaryColor),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.topCenter,
                          children: [
                            SizedBox(
                              width: USize.Width * 0.2,
                              height: USize.Height * 0.06,
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                    'lib/assets/pp_${index % 4}.png'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: USize.Width * 0.1,
                              ),
                              child: Container(
                                width: USize.Height / 77,
                                height: USize.Height / 77,
                                decoration: BoxDecoration(
                                    color: UColor.GreenColor,
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: USize.Width / 100,
                          ),
                          decoration: const BoxDecoration(
                            color: UColor.Transparent,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: UText(
                            "özgür karli",
                            color: UColor.WhiteColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  },
                )),
            Gap(USize.Height * 0.01),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: USize.Width * 0.8,
                  height: chatHeight,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: futureMsg,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Expanded(
                                child: Center(
                                  child: HelperMethods.ShowAsset(UAsset.LOADING,
                                      height: USize.Height / 17,
                                      width: USize.Height / 17),
                                ),
                              );
                            }

                            return Expanded(
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                removeBottom: true,
                                child: ListView.builder(
                                  itemCount: messages.length,
                                  reverse: true,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          messages[index].senderuid ==
                                                  Pool.User.uid
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          messages[index].senderuid ==
                                                  Pool.User.uid
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      children: [
                                        showUsername(
                                            (messages[index].senderuid !=
                                                    Pool.User.uid) &&
                                                (index == messages.length - 1 ||
                                                    messages[index].senderuid !=
                                                        messages[index + 1]
                                                            .senderuid),
                                            messages[index].SenderUsername!,
                                            false),
                                        CustomPaint(
                                          painter: TrianglePainter(
                                              paintTriangle: (messages[index]
                                                          .senderuid !=
                                                      Pool.User.uid) &&
                                                  (index ==
                                                          messages.length - 1 ||
                                                      messages[index]
                                                              .senderuid !=
                                                          messages[index + 1]
                                                              .senderuid)),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              messages[index].senderuid ==
                                                      Pool.User.uid
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: (index > 0 &&
                                                          messages[index]
                                                                  .senderuid !=
                                                              messages[
                                                                      index - 1]
                                                                  .senderuid)
                                                      ? USize.Width / 44
                                                      : USize.Width / 200,
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        USize.Width / 50,
                                                    vertical: USize.Width / 67,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: messages[index]
                                                                .senderuid ==
                                                            Pool.User.uid
                                                        ? UColor
                                                            .SecondHeavyColor
                                                        : UColor.WhiteColor,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft: messages[index]
                                                                  .senderuid ==
                                                              Pool.User.uid
                                                          ? const Radius
                                                              .circular(12)
                                                          : const Radius
                                                              .circular(0),
                                                      topRight: messages[index]
                                                                  .senderuid ==
                                                              Pool.User.uid
                                                          ? const Radius
                                                              .circular(0)
                                                          : const Radius
                                                              .circular(12),
                                                      bottomLeft: messages[
                                                                      index]
                                                                  .senderuid ==
                                                              Pool.User.uid
                                                          ? const Radius
                                                              .circular(0)
                                                          : const Radius
                                                              .circular(12),
                                                      bottomRight: messages[
                                                                      index]
                                                                  .senderuid ==
                                                              Pool.User.uid
                                                          ? const Radius
                                                              .circular(12)
                                                          : const Radius
                                                              .circular(0),
                                                    ),
                                                  ),
                                                  child: UText(
                                                    messages[index].Message!,
                                                    fontSize: 13,
                                                    color: messages[index]
                                                                .senderuid ==
                                                            Pool.User.uid
                                                        ? UColor.WhiteColor
                                                        : Colors.black87,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                      Gap(USize.Height / 100),
                      UTextField(
                        width: USize.Width * 0.8,
                        controller: messageController,
                        constraints:
                            BoxConstraints(maxHeight: USize.Height / 22),
                        suffixIcon: ShakeMe(
                            key: shakeKey,
                            shakeCount: 3,
                            shakeOffset: 5,
                            shakeDuration: const Duration(milliseconds: 500),
                            child: UButton(
                                primaryButton: true,
                                onPressed: () async {
                                  if (messageController.text.isEmpty) {
                                    shakeKey.currentState?.shake();
                                    HelperMethods.SetSnackBar(
                                        context,
                                        Localizer.Get(Localizer
                                            .community_name_cannot_be_less_than_4_characters),
                                        errorBar: true);
                                    return;
                                  }
                                  DTOMessage msg = DTOMessage(
                                      Message: messageController.text,
                                      CommunityId: widget.communityId,
                                      senderuid: Pool.User.uid,
                                      QuestionId: "3131");
                                  messageController.text = "";
                                  UProxy.Request(
                                      URequestType.POST, IService.SEND_MESSAGE,
                                      data: msg.toJson());
                                },
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: UColor.WhiteColor,
                                ))),
                        fillColor: UColor.WhiteHeavyColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(USize.Height * 0.01)
          ],
        ),
      ),
    );
  }

  Widget showUsername(bool showUsername, String message, bool question) {
    if (showUsername) {
      return Padding(
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: UText(
          message,
          color: UColor.SecondHeavyColor,
          fontWeight: FontWeight.w600,
          fontSize: question ? 17 : 13,
        ),
      );
    } else {
      return Container();
    }
  }
}

class TrianglePainter extends CustomPainter {
  bool paintTriangle;
  TrianglePainter({required this.paintTriangle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = paintTriangle ? UColor.WhiteColor : UColor.PrimaryColor;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(10, -10);
    path.lineTo(20, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
