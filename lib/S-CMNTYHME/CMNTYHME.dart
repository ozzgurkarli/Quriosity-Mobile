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
import 'package:quriosity/components/UTextField.dart';
import 'package:quriosity/dto/DTOMessage.dart';
import 'package:quriosity/helpers/HelperMethods.dart';
import 'package:quriosity/helpers/Localizer.dart';
import 'package:quriosity/helpers/Pool.dart';
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
  Future<dynamic>? futureMsg;

  @override
  void initState() {
    super.initState();
    futureMsg = UProxy.Request(URequestType.GET, IService.MESSAGES,
            param: widget.communityId)
        .then((v) {
      for (var item in v) {
        messages.add(DTOMessage.fromJson(item));
      }
      listenChat();
    });
    //     .then((v) {
    //   listenChat();
    //   return v;
    // });
  }

  void listenChat() {
    channel = WebSocketChannel.connect(
      Uri.parse(
          'ws://${ENV.ConnectionString.substring(7)}messages/${widget.communityId}'),
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
            Gap(USize.Height / 2),
            Container(
              width: USize.Width * 0.7,
              height: USize.Height / 2.2,
              decoration: BoxDecoration(
                  color: UColor.BarrierColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      removeBottom: true,
                      child: ListView.builder(
                        itemCount: messages.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment:
                                messages[index].senderuid == Pool.User.uid
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: USize.Width/100, vertical: USize.Width/100),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: messages[index].senderuid == Pool.User.uid ? UColor.GreenHeavyColor : UColor.ThirdColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    messages[index].Message!,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  UTextField(
                    controller: messageController,
                    constraints: BoxConstraints(maxHeight: USize.Height / 22),
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
      ),
    );
  }
}
