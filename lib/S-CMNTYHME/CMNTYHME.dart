// ignore_for_file: must_be_immutable, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shakemywidget/flutter_shakemywidget.dart';
import 'package:gap/gap.dart';
import 'package:quriosity/api/ENV.dart';
import 'package:quriosity/api/IService.dart';
import 'package:quriosity/api/UProxy.dart';
import 'package:quriosity/components/UButton.dart';
import 'package:quriosity/components/UIconButton.dart';
import 'package:quriosity/components/UScaffold.dart';
import 'package:quriosity/components/UText.dart';
import 'package:quriosity/components/UTextField.dart';
import 'package:quriosity/dto/DTOInvitationCode.dart';
import 'package:quriosity/dto/DTOMessage.dart';
import 'package:quriosity/dto/DTOQuestion.dart';
import 'package:quriosity/dto/DTOUser.dart';
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
  final shakeKeyNewOption = GlobalKey<ShakeWidgetState>();
  TextEditingController messageController = TextEditingController();
  TextEditingController newQuestionController = TextEditingController();
  TextEditingController newOptionController = TextEditingController();
  PageController pageController = PageController();
  List<Map<String, dynamic>> newQuestionOptions = [];
  late final WebSocketChannel channelChat;
  late final WebSocketChannel channelQuestions;
  late final WebSocketChannel channelActiveUsers;
  List<DTOMessage> messages = [];
  List<DTOQuestion> questions = [];
  List<DTOUser> activeUsers = [];
  List users = [];
  DTOInvitationCode? invitationCode;
  double chatHeight = USize.Height * 0.23;
  bool chatExpanded = false;
  bool newQuestionTab = false;
  double questionHeight = USize.Height * 0.1;
  Future<dynamic>? futureMsg;
  Future<dynamic>? futureQst;
  Future<dynamic>? futureAct;
  bool loaded = false;
  bool loading = false;
  AsyncSnapshot<dynamic>? snapshotMsg;
  AsyncSnapshot<dynamic>? snapshotQst;
  AsyncSnapshot<dynamic>? snapshotAct;

  @override
  void initState() {
    super.initState();
    SystemChannels.lifecycle.setMessageHandler((String? message) async {
      if (message == AppLifecycleState.inactive.toString()) {
        DTOUser dtoUser = DTOUser(
            CommunityId: widget.communityId, uid: Pool.User.uid, State: 0);
        UProxy.Request(URequestType.POST, IService.USER_ACTIVITY,
                data: dtoUser.toJson())
            .then((v) => {});
      } else if (message == AppLifecycleState.resumed.toString()) {
        DTOUser dtoUser = DTOUser(
            CommunityId: widget.communityId, uid: Pool.User.uid, State: 1);
        UProxy.Request(URequestType.POST, IService.USER_ACTIVITY,
            data: dtoUser.toJson());
      }
      return null;
    });
    DTOUser dtoUser =
        DTOUser(CommunityId: widget.communityId, uid: Pool.User.uid, State: 1);
    UProxy.Request(URequestType.POST, IService.USER_ACTIVITY,
        data: dtoUser.toJson());
    futureMsg = UProxy.Request(URequestType.GET, IService.COMMUNITY_USERNAMES,
            param: widget.communityId)
        .then((_users) {
      users = _users;
      futureAct = UProxy.Request(URequestType.GET, IService.USER_ACTIVITY,
              param: widget.communityId)
          .then((a) {
        for (var i = 0; i < a.length; i++) {
          DTOUser usr = DTOUser.fromJson(a[i]);
          usr.Username =
              (_users as List).where((x) => x["uid"] == usr.uid).first["id"];
          activeUsers.add(usr);
        }
        listenActiveUsers();
        return a;
      });
      futureQst = UProxy.Request(URequestType.GET, IService.QUESTIONS,
              param: widget.communityId)
          .then((q) {
        for (var i = 0; i < q.length; i++) {
          DTOQuestion qst = DTOQuestion.fromJson(q[i]);
          qst.Options = [];
          for (var doc in q[i]["Options"]) {
            qst.Options!.add(doc);
          }
          qst.SenderUsername = (_users as List)
              .where((x) => x["uid"] == qst.senderuid)
              .first["id"];
          questions.add(qst);
        }
        listenQuestions();
        return q;
      });
      return UProxy.Request(URequestType.GET, IService.MESSAGES,
              param: widget.communityId)
          .then((v) {
        for (var i = 0; i < v.length; i++) {
          DTOMessage msg = DTOMessage.fromJson(v[i]);
          msg.SenderUsername = (_users as List)
              .where((x) => x["uid"] == msg.senderuid)
              .first["id"];
          messages.add(msg);
        }
        listenChat();
        return v;
      });
    });
  }

  void listenActiveUsers() {
    channelActiveUsers = WebSocketChannel.connect(
      Uri.parse(
          'ws://${ENV.ConnectionString.substring(ENV.MODE)}userActivities/${widget.communityId}'),
    );

    bool firstRun = true;
    channelActiveUsers.stream.listen((user) {
      setState(() {
        if (firstRun) {
          firstRun = false;
          return;
        }
        DTOUser usr = DTOUser.fromJson(jsonDecode(user));
        if (usr.CommunityId == null) {
          activeUsers.removeWhere((x) => x.uid == usr.uid);
        } else {
          usr.Username = (users).where((x) => x["uid"] == usr.uid).first["id"];
          activeUsers.insert(0, usr);
        }
      });
    });
  }

  void listenQuestions() {
    channelQuestions = WebSocketChannel.connect(
      Uri.parse(
          'ws://${ENV.ConnectionString.substring(ENV.MODE)}questions/${widget.communityId}'),
    );

    bool firstRun = true;
    channelQuestions.stream.listen((question) {
      setState(() {
        if (firstRun) {
          firstRun = false;
          return;
        }
        DTOQuestion qst = DTOQuestion.fromJson(jsonDecode(question));
        qst.Options = [];
        for (var doc in jsonDecode(question)["Options"]) {
          qst.Options!.add(doc);
        }
        qst.SenderUsername =
            (users).where((x) => x["uid"] == qst.senderuid).first["id"];
        questions.insert(0, qst);
      });
    });
  }

  void listenChat() {
    channelChat = WebSocketChannel.connect(
      Uri.parse(
          'ws://${ENV.ConnectionString.substring(ENV.MODE)}messages/${widget.communityId}'),
    );

    bool firstRun = true;
    channelChat.stream.listen((message) {
      setState(() {
        if (firstRun) {
          firstRun = false;
          return;
        }
        DTOMessage msg = DTOMessage.fromJson(jsonDecode(message));
        msg.SenderUsername =
            (users).where((x) => x["uid"] == msg.senderuid).first["id"];
        messages.insert(0, msg);
      });
    });
  }

  @override
  void dispose() {
    channelChat.sink.close();
    channelQuestions.sink.close();
    channelActiveUsers.sink.close();
    DTOUser dtoUser =
        DTOUser(CommunityId: widget.communityId, uid: Pool.User.uid, State: 0);
    UProxy.Request(URequestType.POST, IService.USER_ACTIVITY,
        data: dtoUser.toJson());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UScaffold(
      body: Center(
        child: Column(
          children: [
            Gap(USize.Height * 0.07),
            Row(
              children: [
                UIconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: UColor.WhiteColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  height: USize.Height * 0.08,
                  width: USize.Width * 0.89,
                  decoration: const BoxDecoration(color: UColor.PrimaryColor),
                  child: activeUsersContainer(),
                ),
              ],
            ),
            Gap(USize.Height * 0.005),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: USize.Width * 0.8,
                  height: USize.Height * 0.8 - chatHeight,
                  decoration: const BoxDecoration(color: UColor.PrimaryColor),
                  child: Positioned.fill(
                    child: FutureBuilder(
                        future: futureQst,
                        builder: (context, snapshot) {
                          snapshotQst = snapshot;
                          if (!snapshot.hasData) {
                            if (!loading) {
                              loading = true;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                HelperMethods.SetLoadingScreen(context);
                              });
                            }
                            return const Center();
                          }
                          if (snapshotAct != null &&
                              snapshotAct!.hasData &&
                              snapshotMsg != null &&
                              snapshotMsg!.hasData &&
                              snapshotQst != null &&
                              snapshotQst!.hasData &&
                              !loaded) {
                            loaded = true;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pop(context);
                            });
                          }
                          return PageView.builder(
                            itemCount: newQuestionTab ? 1 : questions.length,
                            itemBuilder: (context, index) {
                              return questionContainer(
                                  question: newQuestionTab ? DTOQuestion() : questions[index]);
                            },
                          );
                        }),
                  ),
                ),
                SizedBox(
                  width: USize.Width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      UButton(
                        color: UColor.WhiteHeavyColor,
                        onPressed: () {
                          if (!newQuestionTab) {
                            setState(() {
                              newQuestionTab = true;
                              chatExpanded = true;

                              setChatSize();
                            });
                          } else if (newQuestionController.text.isEmpty) {
                            HelperMethods.SetSnackBar(context,
                                "Yok artık! Soruyu sormayı mı unuttun, yoksa ben mi yanlış anladım?",
                                errorBar: true);
                          } else if (newQuestionOptions.length < 2) {
                            HelperMethods.SetSnackBar(context,
                                "Bir soruda en az iki seçenek olmalı! Yoksa sorunuz öyle bir yalnızlığa mahkum olur ki, yalnızca karanlık düşüncelerle baş başa kalır!",
                                errorBar: true);
                          } else {
                            setState(() {
                              DTOQuestion question = DTOQuestion(
                                  Question: newQuestionController.text,
                                  senderuid: Pool.User.uid,
                                  Options: newQuestionOptions.reversed.toList(),
                                  CommunityId: widget.communityId,
                                  InactiveUsers: users.where((x)=> !x["active"]).toList());
                              UProxy.Request(
                                  URequestType.POST, IService.NEW_QUESTION,
                                  data: question.toJson());
                              clearNewQuestionInfos();
                              setChatSize();
                            });
                          }
                        },
                        child: UText(
                          newQuestionTab ? "Soruyu Tamamla" : "Soru Ekle",
                          color: UColor.PrimaryColor,
                        ),
                      ),
                      UIconButton(
                        icon: const Icon(
                          Icons.share,
                          color: UColor.WhiteColor,
                        ),
                        onPressed: () async {
                          if (invitationCode == null) {
                            HelperMethods.SetLoadingScreen(context);
                            invitationCode = DTOInvitationCode.fromJson(
                                await UProxy.Request(
                                    URequestType.GET, IService.INVITATION_CODE,
                                    param: widget.communityId));
                            Navigator.pop(context);
                          }
                          HelperMethods.SetSnackBar(context,
                              "Topluluk Davet Kodu: ${invitationCode!.InvitationCode!}");
                        },
                      ),
                      UButton(
                        onPressed: () {
                          if (newQuestionTab) {
                            clearNewQuestionInfos();
                          }
                          setState(() {
                            setChatSize();
                          });
                        },
                        color: newQuestionTab
                            ? UColor.RedHeavyColor
                            : UColor.SecondHeavyColor,
                        child: UText(newQuestionTab
                            ? "Vazgeç"
                            : chatExpanded
                                ? "Sohbeti Küçült"
                                : "Sohbeti Büyült"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                            snapshotMsg = snapshot;
                            if (!snapshot.hasData) {
                              if (!loading) {
                                loading = true;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  HelperMethods.SetLoadingScreen(context);
                                });
                              }
                              return const Center();
                            }
                            if (snapshotAct != null &&
                                snapshotAct!.hasData &&
                                snapshotMsg != null &&
                                snapshotMsg!.hasData &&
                                snapshotQst != null &&
                                snapshotQst!.hasData &&
                                !loaded) {
                              loaded = true;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pop(context);
                              });
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
                                color: UColor.SecondHeavyColor,
                                onPressed: () async {
                                  if (messageController.text.isEmpty) {
                                    shakeKey.currentState?.shake();
                                    HelperMethods.SetSnackBar(
                                        context,
                                        Localizer.Get(
                                            Localizer.message_cannot_be_empty),
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

  void setChatSize() {
    if (newQuestionTab) {
      chatHeight = 0;
    } else if (chatExpanded) {
      chatHeight = USize.Height * 0.23;
      chatExpanded = false;
    } else {
      chatHeight = USize.Height * 0.57;
      chatExpanded = true;
    }
  }

  Widget activeUsersContainer() {
    return FutureBuilder(
        future: futureAct,
        builder: (context, snapshot) {
          snapshotAct = snapshot;
          if (!snapshot.hasData) {
            if (!loading) {
              loading = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                HelperMethods.SetLoadingScreen(context);
              });
            }
            return const Center();
          }
          if (snapshotAct != null &&
              snapshotAct!.hasData &&
              snapshotMsg != null &&
              snapshotMsg!.hasData &&
              snapshotQst != null &&
              snapshotQst!.hasData &&
              !loaded) {
            loaded = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context);
            });
          }
          List usersListed = [];
          for (var item in users) {
            if (activeUsers.where((x) => x.uid == item["uid"]).isNotEmpty) {
              item["active"] = true;
              usersListed.insert(0, item);
            } else {
              item["active"] = false;
              usersListed.add(item);
            }
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
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
                            backgroundImage:
                                AssetImage('lib/assets/pp_${index % 4}.png'),
                          )),
                      Container(
                        width: USize.Width * 0.2,
                        height: USize.Height * 0.06,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: usersListed[index]["active"]
                              ? Colors.black.withOpacity(0)
                              : Colors.black.withOpacity(0.7),
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
                              color: usersListed[index]["active"]
                                  ? UColor.GreenColor
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: USize.Width / 100,
                    ),
                    decoration: BoxDecoration(
                      color: UColor.Transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: UText(
                      usersListed[index]["id"]!,
                      color: UColor.WhiteColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  Widget questionContainer({DTOQuestion? question, bool secondCall = false}) {
    if (newQuestionTab) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          showUsername(true, Pool.User.Username!, true),
          CustomPaint(
            painter: TrianglePainter(paintTriangle: true),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: USize.Width / 67,
                    ),
                    decoration: const BoxDecoration(
                      color: UColor.WhiteColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: UTextField(
                        hintText: "Soru", controller: newQuestionController)),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: USize.Height * 0.55,
                child: MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  removeTop: true,
                  child: ListView.builder(
                    reverse: true,
                    itemCount: newQuestionOptions.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(USize.Height * 0.01),
                        child: Container(
                          width: USize.Width * 0.8,
                          padding: EdgeInsets.symmetric(
                            horizontal: USize.Width / 50,
                            vertical: USize.Width / 67,
                          ),
                          decoration: const BoxDecoration(
                            color: UColor.WhiteHeavyColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: UText(
                            newQuestionOptions[index]
                                .entries
                                .where((x) => x.key == "option")
                                .first
                                .value,
                            color: UColor.PrimaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              UTextField(
                width: USize.Width * 0.8,
                controller: newOptionController,
                hintText: "Seçenek ekle...",
                readOnly: newQuestionOptions.length > 3,
                constraints: BoxConstraints(maxHeight: USize.Height / 22),
                suffixIcon: ShakeMe(
                    key: shakeKeyNewOption,
                    shakeCount: 3,
                    shakeOffset: 5,
                    shakeDuration: const Duration(milliseconds: 500),
                    child: UButton(
                        color: UColor.GreenHeavyColor,
                        onPressed: () async {
                          if (newQuestionOptions.length > 3) {
                            shakeKeyNewOption.currentState?.shake();
                            HelperMethods.SetSnackBar(
                                context,
                                Localizer.Get(Localizer
                                    .question_cannot_have_more_than_4_options),
                                errorBar: true);
                            return;
                          } else if (newOptionController.text.isEmpty) {
                            shakeKeyNewOption.currentState?.shake();
                            HelperMethods.SetSnackBar(context,
                                Localizer.Get(Localizer.option_cannot_be_empty),
                                errorBar: true);
                            return;
                          }
                          setState(() {
                            newQuestionOptions.insert(
                              0,
                              {
                                "option": newOptionController.text,
                                "id": newQuestionOptions.length
                              },
                            );
                            newOptionController.text = "";
                          });
                        },
                        child: const Icon(
                          Icons.arrow_upward,
                          color: UColor.WhiteColor,
                        ))),
                fillColor: UColor.WhiteHeavyColor,
              ),
            ],
          )
        ],
      );
    } else if (chatExpanded && !secondCall) {
      return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment:
        chatExpanded ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
      showUsername(true, question!.SenderUsername!, true),
      Padding(
        padding: EdgeInsets.only(right: USize.Width * 0.05),
        child: CustomPaint(
          painter: TrianglePainter(paintTriangle: true),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: USize.Width / 50,
              vertical: USize.Width / 67,
            ),
            decoration: const BoxDecoration(
              color: UColor.WhiteColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: UText(
              question.Question!,
              color: UColor.PrimaryColor,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      )
              ],
            );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            showUsername(true, question!.SenderUsername!, true),
            Padding(
              padding: EdgeInsets.only(right: USize.Width * 0.05),
              child: CustomPaint(
                painter: TrianglePainter(paintTriangle: true),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: USize.Width / 50,
                    vertical: USize.Width / 67,
                  ),
                  decoration: const BoxDecoration(
                    color: UColor.WhiteColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: UText(
                    question.Question!,
                    color: UColor.PrimaryColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(bottom: USize.Width * 0.05),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: question.Options!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.all(USize.Height * 0.01),
                child: Container(
                    width: USize.Width * 0.8,
                    padding: EdgeInsets.symmetric(
                      horizontal: USize.Width / 50,
                      vertical: USize.Width / 67,
                    ),
                    decoration: const BoxDecoration(
                      color: UColor.WhiteHeavyColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: optionContainer(question, index)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget optionContainer(DTOQuestion question, int index) {
    String answers = "";
    if (question.Answers != null) {
      for (var item in question.Answers!) {
        if (item["id"] == question.Options![index]["id"]) {
          if (answers.isEmpty) {
            answers = "(${item["Username"]})";
          } else {
            answers =
                "${answers.substring(0, answers.length - 1)}, ${item["Username"]}])";
          }
        }
      }
    }

    if (answers.isEmpty) {
      return Column(
        children: [
          UText(
            question.Options![index]["option"],
            color: UColor.PrimaryColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          UText(
            question.Options![index]["option"],
            color: UColor.PrimaryColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          UText(
            "(cabbar16)",
            color: UColor.PrimaryLightColor,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          )
        ],
      );
    }
  }

  void clearNewQuestionInfos() {
    newOptionController.text = "";
    newQuestionController.text = "";
    newQuestionOptions = [];
    newQuestionTab = false;
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
