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
  final shakeKeyNewOption = GlobalKey<ShakeWidgetState>();
  TextEditingController messageController = TextEditingController();
  TextEditingController newQuestionController = TextEditingController();
  TextEditingController newOptionController = TextEditingController();
  PageController pageController = PageController();
  List<Map<String, dynamic>> newQuestionOptions = [];
  DateTime lastOptionChooseDate = DateTime(1);
  DateTime optionWarningDate = DateTime(1);
  int lastOptionQuestionIndex = -1;
  late final WebSocketChannel channelChat;
  late final WebSocketChannel channelQuestions;
  late final WebSocketChannel channelActiveUsers;
  List<DTOMessage> messages = [];
  List<DTOQuestion> questions = [];
  List<DTOUser> activeUsers = [];
  int userOption = -1;
  int qstIndexHolder = 0;
  List users = [];
  DTOInvitationCode? invitationCode;
  double chatHeight = USize.Height * 0.23;
  bool chatExpanded = false;
  bool newQuestionTab = false;
  double questionHeight = USize.Height * 0.1;
  int questionIndex = 0;
  PageController questionIndexController = PageController();
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
    UProxy.Request(URequestType.GET, IService.COMMUNITY_USERNAMES,
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
      futureQst = HelperMethods.GetLastOpenedDate("QST", widget.communityId)
          .then((date) {
        var data = UProxy.Request(
          URequestType.GET,
          IService.QUESTIONS,
          param: "${widget.communityId}/$date",
        ).then((v) {
          var d2 = HelperMethods.SelectFromLocalDB(
                  "SELECT * FROM QUESTIONS WHERE COMMUNITYID = '${widget.communityId}' AND LOCALUID = '${Pool.User.uid}' ORDER BY QUESTIONDATE DESC")
              .then((t) {
            setState(() {
              for (var i = 0; i < t.length; i++) {
                Map<String, dynamic> jsonQst =
                    t[i].map((key, value) => MapEntry(key.toString(), value));
                List opts = [];
                List anss = [];
                for (var item
                    in (jsonQst["Options"] as String).split("''%%/()/")) {
                  opts.add({
                    "option": item.split("**//--**^^")[0],
                    "id": item.split("**//--**^^")[1]
                  });
                }
                jsonQst["Options"] = opts;
                if (jsonQst["Answers"] != null &&
                    jsonQst["Answers"] is String) {
                  for (var item
                      in (jsonQst["Answers"] as String).split("''%%/()/")) {
                    anss.add({
                      "uid": item.split("**//--**^^")[0],
                      "id": item.split("**//--**^^")[1],
                      "Username": (_users as List)
                          .where((x) => x["uid"] == item.split("**//--**^^")[0])
                          .first["id"]
                    });
                  }
                  jsonQst["Answers"] = anss;
                } else if (jsonQst["Answers"] is! String) {
                  jsonQst["Answers"] = null;
                }
                jsonQst["Options"] = opts;
                DTOQuestion qst2 = DTOQuestion.fromJson(jsonQst);
                qst2.Options = opts;
                qst2.SenderUsername = (_users as List)
                    .where((x) => x["uid"] == qst2.senderuid)
                    .first["id"];
                questions.add(qst2);
              }

              for (var i = 0; i < v.length; i++) {
                DTOQuestion qst = DTOQuestion.fromJson(v[i]);
                qst.SenderUsername = (_users as List)
                    .where((x) => x["uid"] == qst.senderuid)
                    .first["id"];
                Map<String, dynamic> jsonQst = qst.toJson();
                jsonQst["Localuid"] = Pool.User.uid;
                HelperMethods.InsertLocalDB("QUESTIONS", jsonQst);
                questions.insert(i, qst);
              }
            });
            listenQuestions();
            return t;
          });
          return d2;
        });

        return data;
      });
      futureMsg = HelperMethods.GetLastOpenedDate("MSG", widget.communityId)
          .then((date) {
        var data = UProxy.Request(
          URequestType.GET,
          IService.MESSAGES,
          param: "${widget.communityId}/$date",
        ).then((v) {
          var d2 = HelperMethods.SelectFromLocalDB(
                  "SELECT * FROM MESSAGES WHERE COMMUNITYID = '${widget.communityId}' AND LOCALUID = '${Pool.User.uid}' ORDER BY MESSAGEDATE DESC")
              .then((t) {
            setState(() {
              for (var i = 0; i < t.length; i++) {
                messages.add(DTOMessage.fromJson(t[i]));
              }

              for (var i = 0; i < v.length; i++) {
                DTOMessage msg = DTOMessage.fromJson(v[i]);
                msg.SenderUsername = (_users as List)
                    .where((x) => x["uid"] == msg.senderuid)
                    .first["id"];
                Map<String, dynamic> jsonMsg = msg.toJson();
                jsonMsg["Localuid"] = Pool.User.uid;
                HelperMethods.InsertLocalDB("MESSAGES", jsonMsg);
                messages.insert(i, msg);
              }
            });
            listenChat();
            return t;
          });
          return d2;
        });

        return data;
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
          try {
            usr.Username =
                (users).where((x) => x["uid"] == usr.uid).first["id"];
          } catch (e) {
            if (e is StateError) {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CMNTYHME(communityId: widget.communityId)));
            }
          }
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
        var mapQst = jsonDecode(question);
        HelperMethods.SetLastOpenedDate("QST", widget.communityId,
            DateTime.fromMillisecondsSinceEpoch(mapQst["LastOpenedDate"]));
        if (firstRun && questions.length == 1) {
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
        Map<String, dynamic> jsonQst = qst.toJson();
        jsonQst["Localuid"] = Pool.User.uid;
        int tmpIndx = questions.indexWhere((x) => x.id == qst.id);
        if (tmpIndx != -1) {
          questions[tmpIndx] = qst;
          HelperMethods.UpdateLocalDB("QUESTIONS", jsonQst);
        } else {
          HelperMethods.InsertLocalDB("QUESTIONS", jsonQst);
          HelperMethods.SetSnackBar(
              context, "Yeni sorular var, görmek için tıkla!");
          questions.insert(0, qst);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          questionIndexController.jumpToPage(questionIndex);
        });
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
        var mapMsg = jsonDecode(message);
        HelperMethods.SetLastOpenedDate("MSG", widget.communityId,
            DateTime.fromMillisecondsSinceEpoch(mapMsg["LastOpenedDate"]));
        if (firstRun &&
            (messages.length == 1 || messages.first.id == mapMsg["id"])) {
          firstRun = false;
          return;
        }
        DTOMessage msg = DTOMessage.fromJson(mapMsg);
        msg.SenderUsername =
            (users).where((x) => x["uid"] == msg.senderuid).first["id"];
        Map<String, dynamic> jsonMsg = msg.toJson();
        jsonMsg["Localuid"] = Pool.User.uid;
        HelperMethods.InsertLocalDB("MESSAGES", jsonMsg);
        if (msg.MessageDate!.isAfter(
            DateTime.fromMillisecondsSinceEpoch(mapMsg["LastOpenedDate"]))) {
          HelperMethods.SetLastOpenedDate(
              "MSG", widget.communityId, msg.MessageDate!);
        }
        if (msg.senderuid != Pool.User.uid) {
          messages.insert(0, msg);
        }
      });
    });
  }

  @override
  void dispose() {
    channelChat.sink.close();
    channelActiveUsers.sink.close();
    channelQuestions.sink.close();
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
                  width: USize.Width,
                  height: USize.Height * 0.8 - chatHeight,
                  decoration: const BoxDecoration(color: UColor.PrimaryColor),
                ),
                Positioned.fill(
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
                          controller: questionIndexController,
                          itemBuilder: (context, index) {
                            if (!newQuestionTab) {
                              if (qstIndexHolder >= 0) {
                                questionIndex = index;
                              }
                              qstIndexHolder += 1;
                            } else {
                              qstIndexHolder = -2;
                            }
                            List x = [];
                            if (questions.isNotEmpty &&
                                questions[index].Answers != null) {
                              x = questions[index]
                                  .Answers!
                                  .where((x) =>
                                      x["Username"] == Pool.User.Username)
                                  .toList();
                            }
                            userOption = x.isEmpty
                                ? -1
                                : int.parse(x.first["id"].toString());
                            return SizedBox(
                              width: USize.Width * 0.8,
                              child: questionContainer(
                                  question: newQuestionTab
                                      ? DTOQuestion()
                                      : questions[index]),
                            );
                          },
                        );
                      }),
                ),
                SizedBox(
                  width: USize.Width * 0.8,
                  child: Column(
                    children: [
                      Row(
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
                                      Options:
                                          newQuestionOptions.reversed.toList(),
                                      CommunityId: widget.communityId,
                                      InactiveUsers: users
                                          .where((x) => !x["active"])
                                          .toList());
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
                                    await UProxy.Request(URequestType.GET,
                                        IService.INVITATION_CODE,
                                        param: widget.communityId));
                                Navigator.pop(context);
                              }
                              HelperMethods.SetSnackBar(
                                context,
                                "Topluluk Davet Kodu:\n${invitationCode!.InvitationCode!}\n(Panoya kopyalamak için tıkla)",
                                onTap: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text: invitationCode!.InvitationCode!));
                                  HelperMethods.SetSnackBar(context,
                                      "Kod panoya kopyalandı.");
                                },
                              );
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
                      Gap(newQuestionTab ? 60 : 0)
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
                  width: USize.Width * 0.95,
                  height: chatHeight,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      FutureBuilder(
                          future: futureMsg,
                          builder: (context, snapshot) {
                            snapshotMsg = snapshot;
                            if (snapshotMsg!.connectionState ==
                                ConnectionState.waiting) {
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
                                snapshotAct!.connectionState ==
                                    ConnectionState.done &&
                                snapshotMsg != null &&
                                snapshotMsg!.connectionState ==
                                    ConnectionState.done &&
                                snapshotQst != null &&
                                snapshotQst!.connectionState ==
                                    ConnectionState.done &&
                                !loaded) {
                              loaded = true;
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pop(context);
                              });
                            }
                            snapshotAct!.data;
                            snapshotQst!.data;
                            snapshotMsg!.data;
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
                                        Align(
                                            alignment: Alignment.center,
                                            child: showDate(index)),
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
                                          mainAxisSize: MainAxisSize.min,
                                          textDirection:
                                              messages[index].senderuid ==
                                                      Pool.User.uid
                                                  ? TextDirection.ltr
                                                  : TextDirection.rtl,
                                          mainAxisAlignment:
                                              messages[index].senderuid ==
                                                      Pool.User.uid
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      USize.Width * 0.01),
                                              child: UText(
                                                "${messages[index].MessageDate!.hour.toString().padLeft(2, '0')}:${messages[index].MessageDate!.minute.toString().padLeft(2, '0')}",
                                                fontSize: 11,
                                                color: UColor.WhiteHeavyColor,
                                              ),
                                            ),
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
                        width: USize.Width * 0.95,
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
                                      QuestionId: questions.isNotEmpty
                                          ? questions[questionIndex].id
                                          : "");
                                  messageController.text = "";
                                  msg.SenderUsername = Pool.User.Username;
                                  msg.MessageDate = DateTime.now();
                                  messages.insert(0, msg);
                                  Map<String, dynamic> mapMsg = msg.toJson();
                                  mapMsg["MessageDate"] = null;
                                  UProxy.Request(
                                      URequestType.POST, IService.SEND_MESSAGE,
                                      data: mapMsg);
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

  Widget showDate(int index) {
    if (index == messages.length - 1 ||
        messages[index + 1].MessageDate!.day !=
            messages[index].MessageDate!.day) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 20,
        ),
        child: UText(
          "${messages[index].MessageDate!.day.toString().padLeft(2, '0')}.${messages[index].MessageDate!.month.toString().padLeft(2, '0')}.${messages[index].MessageDate!.year}",
          color: UColor.WhiteColor,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      );
    } else {
      return Container();
    }
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
                          width: USize.Height * 0.06,
                          height: USize.Height * 0.06,
                          child: CircleAvatar(
                            backgroundImage: AssetImage(UAsset.PROFILE_ICONS[
                                usersListed[index]["ProfileIcon"]]),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
                            hintText: "Soru",
                            controller: newQuestionController)),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                removeTop: true,
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: newQuestionOptions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: USize.Height * 0.01,
                          horizontal: USize.Width * 0.11),
                      child: Container(
                        width: USize.Width * 0.8,
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
              const Gap(50),
              UTextField(
                width: USize.Width * 0.8,
                controller: newOptionController,
                hintText: "Seçenek ekle...",
                scrollPadding:
                    EdgeInsets.fromLTRB(20, 20, 20, USize.Height * 0.065),
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
              Gap(USize.Height * 0.01)
            ],
          )
        ],
      );
    } else if (chatExpanded && !secondCall) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            chatExpanded ? MainAxisAlignment.start : MainAxisAlignment.start,
        children: [
          SizedBox(
            width: USize.Width * 0.8,
            child: Stack(
              alignment: Alignment.center,
              children: [
                showUsername(true, question!.SenderUsername ?? "", true),
                Align(
                    alignment: Alignment.centerRight,
                    child: UText(
                        HelperMethods.CalculateLastActivityTime(
                            question.QuestionDate!),
                        color: UColor.WhiteHeavyColor))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: USize.Width * 0.05),
            child: CustomPaint(
              painter: TrianglePainter(paintTriangle: true),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(
                  width: USize.Width * 0.8,
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
              ),
            ],
          )
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SizedBox(
              width: USize.Width * 0.8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  showUsername(true, question!.SenderUsername ?? "", true),
                  Align(
                      alignment: Alignment.centerRight,
                      child: UText(
                          HelperMethods.CalculateLastActivityTime(
                              question.QuestionDate!),
                          color: UColor.WhiteHeavyColor))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: USize.Width * 0.05),
              child: CustomPaint(
                painter: TrianglePainter(paintTriangle: true),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    width: USize.Width * 0.8,
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
                ),
              ],
            ),
          ],
        ),
        Column(
          children: [
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: question.Options!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: USize.Height * 0.01,
                        horizontal: USize.Width * 0.11),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (onOptionChoose()) {
                            if (userOption == index ||
                                (userOption != -1 && userOption != index)) {
                              question.Answers!.removeWhere(
                                  (x) => x["Username"] == Pool.User.Username);
                              if (userOption == index) {
                                userOption = -1;
                                question.Answers ??= [];
                                Map<String, dynamic> mapAns = {
                                  "Username": Pool.User.Username,
                                  "id": index,
                                  "QuestionId": question.id,
                                  "uid": Pool.User.uid,
                                  "remove": true
                                };
                                UProxy.Request(
                                    URequestType.PUT, IService.UPDATE_ANSWERS,
                                    data: mapAns);
                                return;
                              }
                            }
                            userOption = index;
                            question.Answers ??= [];
                            Map<String, dynamic> mapAns = {
                              "Username": Pool.User.Username,
                              "id": index,
                              "QuestionId": question.id,
                              "uid": Pool.User.uid
                            };
                            question.Answers!.add(mapAns);
                            UProxy.Request(
                                URequestType.PUT, IService.UPDATE_ANSWERS,
                                data: mapAns);
                          }
                        });
                      },
                      child: Container(
                          width: USize.Width * 0.8,
                          padding: EdgeInsets.symmetric(
                            horizontal: USize.Width / 50,
                            vertical: USize.Width / 100,
                          ),
                          decoration: BoxDecoration(
                            color: userOption == index
                                ? UColor.SecondColor
                                : UColor.WhiteColor,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                          ),
                          child: optionContainer(question, index)),
                    ),
                  );
                },
              ),
            ),
            Gap(USize.Height * 0.05)
          ],
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
                "${answers.substring(0, answers.length - 1)}, ${item["Username"]})";
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
            fontWeight: userOption == index ? FontWeight.w700 : FontWeight.w500,
          ),
          UText(
            answers,
            color: UColor.PrimaryLightColor,
            fontSize: 13,
            fontWeight: userOption == index ? FontWeight.w600 : FontWeight.w400,
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

  bool onOptionChoose() {
    if (DateTime.now().difference(optionWarningDate).inMilliseconds < 4000) {
      return false;
    }
    if (lastOptionQuestionIndex == questionIndex &&
        DateTime.now().difference(lastOptionChooseDate).inMilliseconds < 2000) {
      optionWarningDate = DateTime.now();
      HelperMethods.SetSnackBar(context, "yarram sürekli şıklara basıp durma",
          errorBar: true);
      return false;
    }
    lastOptionQuestionIndex = questionIndex;
    lastOptionChooseDate = DateTime.now();
    return true;
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
