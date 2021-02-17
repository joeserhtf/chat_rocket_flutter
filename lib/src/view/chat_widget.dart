import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:io';
import 'dart:typed_data';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_meteor_web/dart_meteor_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:link/link.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

import '../../const.dart';
import '../controller/chat_controller.dart';
import '../model/agents.dart';
import '../model/callback_data.dart';
import '../model/chat_option.dart';
import '../model/department.dart';
import '../model/guest.dart';
import '../model/login.dart';
import '../model/messages.dart';
import '../model/room_messages.dart' as roomHist;
import '../model/socket_room.dart';
import '../view/seek_bar.dart';
import '../view/widget_mini_chats.dart';
import '../view/widgets.dart';
import 'input_bar.dart';

class WidgetChat extends StatefulWidget {
  String url;
  String urlLogo;
  String urlSound;
  Color baseColor;
  Color textColor;
  Color iconsColor;
  Color audioColor;
  Color iconButtonColor;
  List<ChatOption> options;
  Function(CallbackData) onClose;
  Function(CallbackData) onTransfer;
  Function(CallbackData) onUpdate;

  WidgetChat({
    this.baseColor,
    @required this.url,
    @required this.urlLogo,
    this.textColor,
    this.iconsColor,
    this.audioColor,
    this.urlSound,
    this.iconButtonColor,
    this.options,
    this.onClose,
    this.onTransfer,
    this.onUpdate,
  });

  @override
  _WidgetChatState createState() => _WidgetChatState();
}

class _WidgetChatState extends State<WidgetChat> {
  Message messages;
  Users destinyAgents;

  Departments department;
  bool transferring = false;

  PageController _historicController = PageController(initialPage: 0);

  final _formValidator = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _userChatController = TextEditingController(
    text: '',
  );
  TextEditingController _passwordChatController = TextEditingController(
    text: '',
  );
  final FocusNode _userFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool openHistoric = false;

  var notificationSound = AudioPlayer();

  @override
  void initState() {
    super.initState();
    if (widget.baseColor != null) baseColor = widget.baseColor;
    if (widget.url != null) globalurl = widget.url;
    if (widget.urlLogo != null) urlLogo = widget.urlLogo;
    if (widget.urlSound != null) urlSound = widget.urlSound;
    if (widget.textColor != null) textColor = widget.textColor;
    if (widget.iconsColor != null) iconsColor = widget.iconsColor;
    if (widget.audioColor != null) audioColor = widget.audioColor;
    if (widget.iconButtonColor != null)
      iconButtonColor = widget.iconButtonColor;

    notificationSound.setUrl(urlSound);

    meteor = MeteorClient.connect(
      url: "wss://${globalurl.replaceAll("https://", '')}/websocket",
    );
    meteor.prepareCollection('stream-notify-user');
    meteor.prepareCollection('stream-room-messages');
  }

  @override
  void dispose() {
    super.dispose();
    meteor.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    //print('Rebuild Chat');
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomRight,
        child: _body(),
      ),
    );
  }

  _body() {
    return StreamBuilder<DdpConnectionStatus>(
      stream: meteor.status(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.connected) {
            return StreamBuilder<Map<String, dynamic>>(
              stream: meteor.user(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (rocketUser == null) {
                    String savedToken =
                        html.window.localStorage['Meteor.loginToken'];
                    _loginApi(resume: savedToken);
                  } else {
                    if (rocketUser.data != null) {
                      subscriptionHandler = meteor.subscribe(
                        'stream-notify-user',
                        ["${rocketUser.data.userId}/rooms-changed", false],
                      );
                    }
                  }
                  subscriptionHandler = meteor.subscribe(
                    'stream-room-messages',
                    ["__my_messages__", false],
                  );
                  return chatActive ? _chat() : _minimizedChat();
                }
                return showLoginForm ? _formLogin() : _loginButton();
              },
            );
          }
          return _reconnectButton();
        }
        return Container();
      },
    );
  }

  _reconnectButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        backgroundColor: baseColor,
        child: Icon(
          Icons.refresh,
          color: iconButtonColor,
        ),
        onPressed: () {
          meteor.reconnect();
        },
      ),
    );
  }

  _loginButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        backgroundColor: baseColor,
        child: Icon(
          MdiIcons.loginVariant,
          color: iconButtonColor,
        ),
        onPressed: () {
          setState(() {
            showLoginForm = true;
          });
        },
      ),
    );
  }

  _minimizedChat() {
    return StreamBuilder(
      stream: meteor.collections['stream-notify-user'],
      builder: (context, snapshot) {
        if ((liveRooms == null || snapshot.hasData)) {
          loadRooms();
        }
        return StreamBuilder(
          stream: blocRooms.stream,
          builder: (context, snapshot) {
            return Align(
              alignment: Alignment.bottomRight,
              child: Badge(
                showBadge: true,
                badgeContent: Text(
                  "$waitingRooms",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                shape: BadgeShape.circle,
                animationType: BadgeAnimationType.scale,
                child: FloatingActionButton(
                  backgroundColor: baseColor,
                  onPressed: () async {
                    setState(() {
                      fistChat = true;
                      chatActive = !chatActive;
                    });
                  },
                  child: Icon(
                    MdiIcons.chat,
                    color: iconButtonColor,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  _chat() {
    return Container(
      width: widthChatBox,
      child: StreamBuilder(
        stream: meteor.collections['stream-room-messages'],
        builder: (context, snapshot) {
          loadRooms(data: snapshot.data);
          return StreamBuilder(
            stream: blocRooms.stream,
            builder: (context, snapshot) {
              if (playNotifier && snapshot.hasData) {
                if (rooms != null) {
                  for (int n = 0; n < rooms.length; n++) {
                    if (snapshot.data.length == rooms.length) {
                      if ((rooms[n].lastMessage?.sId !=
                              snapshot.data[n].lastMessage?.sId) &&
                          rooms[n].lastMessage?.alias !=
                              rooms[n].servedBy.username) {
                        notificationSound.seek(Duration.zero, index: 0);
                        notificationSound.pause();
                        notificationSound.play();
                        break;
                      }
                    } else if (snapshot.data.length > rooms.length) {
                      notificationSound.seek(Duration.zero, index: 0);
                      notificationSound.pause();
                      notificationSound.play();
                      break;
                    }
                  }
                }
              }
              if (snapshot.hasData) {
                rooms = snapshot.data;
              }

              if (snapshot.hasData) {
                playNotifier = true;
                if (waitingRooms == 0) {
                  return _noRoomButton();
                }
                if (selectedRoom > rooms.length - 1) {
                  selectedRoom = 0;
                }
                _streamRoom(rooms[selectedRoom].sId);
                _checkUpdate(rooms);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!expandedChat)
                      MiniChats(rooms, () {
                        setState(() {
                          playNotifier = false;
                        });
                      }),
                    Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        height: heightChatBox,
                        child: Column(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  _messagesList(),
                                  expandedChat
                                      ? Container(
                                          height: 50,
                                          color: baseColor,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: MiniChats(rooms, () {
                                                  setState(() {});
                                                }),
                                              ),
                                              _buttons(),
                                            ],
                                          ),
                                        )
                                      : _buttons(),
                                ],
                              ),
                            ),
                            InputBar(rooms[selectedRoom].sId ?? ''),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }

  _noRoomButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Badge(
        showBadge: true,
        badgeContent: Text(
          'X',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        shape: BadgeShape.circle,
        animationType: BadgeAnimationType.scale,
        child: FloatingActionButton(
          tooltip: 'Nenhum Chat Ativo',
          backgroundColor: baseColor,
          onPressed: () {},
          child: Icon(
            MdiIcons.chat,
            color: iconButtonColor,
          ),
        ),
      ),
    );
  }

  _messagesList() {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: StreamBuilder(
            stream: meteor.collections['stream-room-messages'],
            builder: (context, snapshot) {
              _loadMessages(rooms[selectedRoom].sId);
              return StreamBuilder(
                stream: blocMensagens.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Message messages = snapshot.data;
                    return ListView.builder(
                      itemCount: messages.messages.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return _buildMessage(
                          index == 0,
                          '${messages.messages[index].message}',
                          !messages.messages[index].u.username
                              .contains("guest"),
                          messages.messages[index].ts.date ?? 0,
                          messages.messages[index].u.name,
                          messages.messages[index],
                          messages.messages[index].u.username,
                          index,
                        );
                      },
                    );
                  }
                  if (rooms == null || rooms.isEmpty) {
                    return Center(
                      child: Text("Nenhuma Conversa Ativa"),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          ),
        ),
        if (openHistoric) ...{
          Expanded(
            flex: 3,
            child: _historicBody(),
          )
        }
      ],
    );
  }

  _historicBody() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.grey[400],
            width: 0.8,
          ),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: PageView(
              controller: _historicController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _listHistoricChat(),
                _listMessagesHistoric(),
              ],
            ),
          )
        ],
      ),
    );
  }

  _listHistoricChat() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[400],
                width: 0.6,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    setState(() {
                      openHistoric = false;
                    });
                  }),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: blocHistoricoConversas.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              dynamic chats = snapshot.data;

              return ListView.builder(
                itemCount: chats["history"].length,
                itemBuilder: (context, index) {
                  return index == 0
                      ? Container()
                      : Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ),
                          child: ListTile(
                            onTap: () async {
                              _historicController.animateToPage(1,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                              roomHist.RoomMessages messages =
                                  await RocketChatApi.getRoomMessages(
                                chats["history"][index]["_id"],
                              );
                              blocHistoricoMensagens.add(messages);
                            },
                            title: Text(
                              "${chats["history"][index]["servedBy"]["username"]}"
                              " - ${DateFormat('dd/MM/yy HH:mm').format(
                                DateTime.parse(
                                    chats["history"][index]["_updatedAt"]),
                              )}",
                            ),
                            subtitle: Text(
                              "${chats["history"][index]["lastMessage"]["msg"]}",
                            ),
                          ),
                        );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  _listMessagesHistoric() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[400],
                width: 0.6,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    setState(() {
                      _historicController.animateToPage(0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                      _getLocalHistoric();
                    });
                  }),
              IconButton(
                  icon: Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    setState(() {
                      openHistoric = false;
                    });
                  }),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: blocHistoricoMensagens.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              roomHist.RoomMessages messages = snapshot.data;

              return ListView.builder(
                itemCount: messages.messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return messages.messages[index].t == 'command'
                      ? Container()
                      : _buildHistoricMessage(
                          index == 0,
                          '${messages.messages[index].message}',
                          !messages.messages[index].u.username
                              .contains("guest"),
                          messages.messages[index].ts,
                          messages.messages[index].u.name,
                          messages.messages[index],
                          messages.messages[index].u.username,
                          index,
                        );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  _buttons() {
    return Container(
      color: transferring
          ? expandedChat
              ? Colors.transparent
              : Colors.white
          : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: transferring,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  expandedChat
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Agente: ",
                                  style: TextStyle(
                                    color: expandedChat
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                _selectAgents(),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Departamento: ",
                                  style: TextStyle(
                                    color: expandedChat
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                _selectDepartment(),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Agente: "),
                                _selectAgents(),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Departamento: "),
                                _selectDepartment(),
                              ],
                            ),
                          ],
                        ),
                  expandedChat
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: expandedChat ? 8 : 0,
                                ),
                                child: IconButton(
                                  tooltip: "Cancelar",
                                  iconSize: 22,
                                  color: Colors.red,
                                  icon: Icon(
                                    MdiIcons.close,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      transferring = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Material(
                              child: IconButton(
                                tooltip: "Transferir",
                                iconSize: 22,
                                color: Colors.green,
                                icon: Icon(
                                  MdiIcons.check,
                                ),
                                onPressed: () {
                                  _chatTransfer();
                                },
                              ),
                              color: Colors.transparent,
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: expandedChat ? 8 : 0,
                                ),
                                child: IconButton(
                                  tooltip: "Cancelar",
                                  iconSize: 22,
                                  color: Colors.red,
                                  icon: Icon(
                                    MdiIcons.close,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      transferring = false;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Material(
                              child: IconButton(
                                tooltip: "Transferir",
                                iconSize: 22,
                                color: Colors.green,
                                icon: Icon(
                                  MdiIcons.check,
                                ),
                                onPressed: () {
                                  _chatTransfer();
                                },
                              ),
                              color: Colors.transparent,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !transferring,
            child: Tooltip(
              message: "Opções",
              child: PositionedTapDetector(
                onTap: (details) {
                  _showPopupMenu(details.global);
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    MdiIcons.dotsHorizontal,
                    color: expandedChat ? Colors.white : iconsColor,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !transferring,
            child: Row(
              children: [
                IconButton(
                  tooltip: expandedChat ? "Reduzir" : 'Tela Cheia',
                  iconSize: 22,
                  color: expandedChat ? Colors.white : iconsColor,
                  icon: Icon(
                    expandedChat
                        ? MdiIcons.arrowCollapse
                        : MdiIcons.arrowExpand,
                  ),
                  onPressed: () {
                    setState(() {
                      expandedChat = !expandedChat;
                      sizeChatMensagens = expandedChat
                          ? MediaQuery.of(context).size.width * 0.55
                          : sizePadraoMensagem;
                      heightChatBox = expandedChat
                          ? MediaQuery.of(context).size.height - 72
                          : alturaPadraoChat;
                      widthChatBox = expandedChat
                          ? MediaQuery.of(context).size.width - 72
                          : larguraPadraoChat;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(right: expandedChat ? 8 : 0),
                  child: IconButton(
                    tooltip: 'Minimizar',
                    iconSize: 22,
                    color: expandedChat ? Colors.white : iconsColor,
                    icon: Icon(
                      MdiIcons.arrowBottomRight,
                    ),
                    onPressed: () {
                      setState(() {
                        fistChat = true;
                        playNotifier = false;
                        chatActive = !chatActive;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildMessage(
    bool isLast,
    String message,
    bool send,
    int date,
    String name,
    Messages messages,
    String user,
    int index,
  ) {
    if (send) {
      return Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Text(
                    "$user",
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 5.0),
                )
              ],
            ),
            Row(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: sizeChatMensagens,
                  ),
                  child: Container(
                    child: (messages.attachments != null
                            ? messages.attachments.isNotEmpty
                            : false)
                        ? messages.file.type.contains("image")
                            ? Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _showImageZoom(
                                        "$globalurl${messages.attachments[0].titleLink}",
                                      );
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "$globalurl${messages.attachments[0].titleLink}",
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      width: 200,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Link(
                                      child: Icon(
                                        MdiIcons.cloudDownloadOutline,
                                        color: iconsColor,
                                      ),
                                      url:
                                          "$globalurl${messages.attachments[0].titleLink}"
                                          "?download",
                                    ),
                                  ),
                                ],
                              )
                            : messages.file.type.contains("audio")
                                ? _playAudio(index,
                                    "$globalurl${messages.attachments[0].titleLink}")
                                : Link(
                                    child: Text(
                                      messages.attachments[0].title,
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    url:
                                        "$globalurl${messages.attachments[0].titleLink}"
                                        "?download",
                                  )
                        : copyText(message, corText: textColor),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: greyColor2,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            isLast
                ? Container(
                    child: Text(
                      DateFormat('dd/MM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(date),
                      ),
                      style: TextStyle(
                        color: greyColor,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: 30.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                  )
                : Container()
          ],
        ),
        margin: EdgeInsets.only(
          bottom: 10.0,
          right: 10.0,
        ),
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: expandedChat ? 45 : 30.0,
                  height: expandedChat ? 45 : 30.0,
                  margin: EdgeInsets.only(left: 8),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(),
                      padding: EdgeInsets.all(10.0),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                        color: Color(
                          (multiplicadorCor(rooms[selectedRoom].sId,
                                      rooms[selectedRoom].departmentId) *
                                  0xFFFFFF)
                              .toInt(),
                        ).withOpacity(1.0),
                      ),
                      child: Text(
                        '${(name == null || name == '') ? ''
                            '' : name.substring(0, 1)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    imageUrl: "",
                    fit: BoxFit.cover,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: sizeChatMensagens,
                  ),
                  child: Container(
                    child: messages.urls != null && !message.contains("Log:")
                        ? (messages.urls[messages.urls.length - 1].headers ==
                                    null
                                ? false
                                : messages.urls[messages.urls.length - 1]
                                    .headers.contentType
                                    .contains("image"))
                            ? Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _showImageZoom(
                                          "${message.replaceAll("]", '')}");
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${message.replaceAll("]", '')}",
                                      progressIndicatorBuilder: (
                                        context,
                                        url,
                                        downloadProgress,
                                      ) =>
                                          CircularProgressIndicator(
                                        value: downloadProgress.progress,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      width: 200,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Link(
                                      child: Icon(
                                        MdiIcons.cloudDownloadOutline,
                                        color: iconsColor,
                                      ),
                                      url: "${message.replaceAll("]", '')}",
                                    ),
                                  ),
                                ],
                              )
                            : (messages.urls[messages.urls.length - 1]
                                            .headers ==
                                        null
                                    ? false
                                    : messages.urls[messages.urls.length - 1]
                                        .headers.contentType
                                        .contains("audio"))
                                ? _playAudio(
                                    index, "${message.replaceAll("]", '')}")
                                : Link(
                                    child: Text(
                                      message
                                          .replaceAll("\n", "")
                                          .replaceAll("]", ""),
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    url: "${message.replaceAll("]", '')}",
                                    //onError: _onErrorCallback
                                  )
                        : copyText(message, corText: Colors.white),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    margin: EdgeInsets.only(left: 8.0),
                  ),
                )
              ],
            ),
            isLast
                ? Container(
                    child: Text(
                      DateFormat('dd/MM kk:mm').format(
                        DateTime.fromMillisecondsSinceEpoch(
                          date,
                          isUtc: false,
                        ),
                      ),
                      style: TextStyle(
                        color: greyColor,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: 50.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  _showPopupMenu(Offset offset) async {
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
              _closeRoom();
            },
            title: Text("Encerrar"),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
              _getLocalHistoric();
              setState(() {
                expandedChat = true;
                openHistoric = true;
                sizeChatMensagens = expandedChat
                    ? MediaQuery.of(context).size.width * 0.55
                    : sizePadraoMensagem;
                heightChatBox = expandedChat
                    ? MediaQuery.of(context).size.height - 72
                    : alturaPadraoChat;
                widthChatBox = expandedChat
                    ? MediaQuery.of(context).size.width - 72
                    : larguraPadraoChat;
              });
            },
            title: Text("Historico"),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              setState(() {
                transferring = true;
                Navigator.pop(context);
              });
              _loadAgents();
              destinyAgents = null;
            },
            title: Text("Transferir"),
          ),
        ),
        ..._optionsBuilder(),
      ],
      elevation: 8.0,
    );
  }

  _getLocalHistoric() async {
    Guest guest = await RocketChatApi.getDataGuest(
      rooms[selectedRoom].v.token,
    );
    dynamic history = await RocketChatApi.getHistGuest(
      rooms[selectedRoom].sId,
      guest.visitor.sId,
    );
    blocHistoricoConversas.add(history);
  }

  _loadMessages(String roomID) async {
    if (rooms == null) await Future.delayed(Duration(seconds: 1));
    var resp = await meteor.call('loadHistory', [
      "$roomID",
      null,
      0,
      {"\$date": DateTime.now().millisecondsSinceEpoch}
    ]);
    messages = Message.fromJson(resp);
    blocMensagens.add(messages);
    return messages;
  }

  _loginApi({
    String resume = '',
  }) async {
    LoginClass apiUser = await RocketChatApi.loginRocket(
      _userChatController.text,
      _passwordChatController.text,
      resume: resume,
    );
    if (apiUser == null) {
      _onError("Usuário ou senha incorreto(s)!");
    } else {
      rocketUser = apiUser;
      subscriptionHandler = meteor.subscribe(
        'stream-notify-user',
        ["${rocketUser.data.userId}/rooms-changed", false],
      );
      _loginSocketToken(rocketUser.data.authToken);
      RocketChatApi.changeStatus(true);
    }
  }

  void _onError(msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
    ));
  }

  _loginSocketToken(String token) {
    meteor.loginWithToken(token: "$token");
  }

  _streamRoom(String roomId) {
    globalRoomId = roomId;
  }

  _closeRoom() async {
    bool isConfirmed = true;
    if (widget.onClose != null) {
      isConfirmed = await widget.onClose(
        CallbackData(
          roomId: rooms[selectedRoom]?.sId ?? "",
          contactName: rooms[selectedRoom]?.fName ?? "Contato",
          number: "",
          token: rooms[selectedRoom]?.v?.token ?? "",
          agentName: rooms[selectedRoom]?.servedBy?.username ?? "",
          department: rooms[selectedRoom]?.departmentId ?? "",
          destinyAgentName: destinyAgents?.username ?? "",
          destinyDepartment: department?.sId ?? "",
          guestId: "",
        ),
      );
    }
    if (isConfirmed ?? true) {
      await RocketChatApi.closeRoom(
        rooms[selectedRoom].sId,
        rooms[selectedRoom].v.token,
      );
      await loadRooms();
      setState(() {
        selectedRoom = 0;
      });
    }
  }

  _chatTransfer() async {
    bool isConfirmed = true;
    if (widget.onTransfer != null) {
      isConfirmed = await widget.onTransfer(
        CallbackData(
          roomId: rooms[selectedRoom]?.sId ?? "",
          contactName: rooms[selectedRoom]?.fName ?? "Contato",
          number: "",
          token: rooms[selectedRoom]?.v?.token ?? "",
          agentName: rooms[selectedRoom]?.servedBy?.username ?? "",
          department: rooms[selectedRoom]?.departmentId ?? "",
          destinyAgentName: destinyAgents?.username ?? "",
          destinyDepartment: department?.sId ?? "",
          guestId: "",
        ),
      );
    }
    if (isConfirmed ?? true) {
      await RocketChatApi.transferRoom(
        rooms[selectedRoom].sId,
        destinyAgents.sId,
        department: '',
      );
      await loadRooms();
      setState(() {
        transferring = false;
        destinyAgents = null;
        selectedRoom = 0;
      });
    } else {
      Navigator.pop(context);
    }
  }

  _playAudio(int index, String url) {
    var player = AudioPlayer();
    try {
      player.setUrl(url);
    } catch (e) {
      print(e);
    }
    return StreamBuilder<Duration>(
      stream: player.durationStream,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;
        return Row(
          children: [
            StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
                final playerState = snapshot.data;
                final processingState = playerState?.processingState;
                final playing = playerState?.playing;
                if (processingState == ProcessingState.loading ||
                    processingState == ProcessingState.buffering) {
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    width: 28.0,
                    height: 28.0,
                    child: CircularProgressIndicator(),
                  );
                } else if (playing != true) {
                  return IconButton(
                    icon: Icon(Icons.play_arrow),
                    iconSize: 28.0,
                    onPressed: player.play,
                    color: audioColor,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: Icon(Icons.pause),
                    iconSize: 28.0,
                    onPressed: player.pause,
                    color: audioColor,
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons.replay),
                    iconSize: 28.0,
                    color: audioColor,
                    onPressed: () {
                      player.seek(Duration.zero, index: 0);
                      player.pause();
                      player.play();
                    },
                  );
                }
              },
            ),
            Expanded(
              child: StreamBuilder<Duration>(
                stream: player.positionStream,
                builder: (context, snapshot) {
                  var position = snapshot.data ?? Duration.zero;
                  if (position > duration) {
                    position = duration;
                  }
                  return SeekBar(
                    duration: duration,
                    position: position,
                    stateColor: audioColor,
                    onChangeEnd: (newPosition) {
                      player.seek(newPosition);
                      player.pause();
                      player.play();
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  _selectAgents() {
    return StreamBuilder(
      stream: blocAgentes.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 30,
          );
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<Users>(
            disabledHint: Text('Agente'),
            value: destinyAgents,
            icon: Icon(Icons.arrow_downward),
            iconSize: 15,
            elevation: 14,
            style: TextStyle(
              color: iconButtonColor,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (Users value) {
              setState(() {
                destinyAgents = value;
              });
            },
            items: snapshot.data.map<DropdownMenuItem<Users>>((Users value) {
              return DropdownMenuItem<Users>(
                value: value,
                child: Center(
                  child: Text(
                    allWordsCapitilize(_nameSizeControl(value)),
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  _nameSizeControl(Users value) {
    List<String> words = value.name.split(' ');
    if (words.length > 1) return "${words[0]} ${words[1]}";
    return value.name;
  }

  _selectDepartment() {
    return StreamBuilder(
      stream: blocDepartamentos.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          department = null;
          return Container(
            height: 30,
          );
        }

        Department snapDepartments = snapshot.data;
        if (department == null) {
          snapDepartments.departments.forEach((element) {
            if (element.sId == rooms[selectedRoom].departmentId)
              department = element;
          });
        }

        snapDepartments.departments.removeWhere(
          (element) => !element.enabled,
        );

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<Departments>(
            disabledHint: Text('Departamento'),
            value: department,
            icon: Icon(Icons.arrow_downward),
            iconSize: 15,
            elevation: 14,
            style: TextStyle(
              color: iconButtonColor,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (Departments value) {
              setState(() {
                department = value;
              });
            },
            items: snapDepartments.departments
                .map<DropdownMenuItem<Departments>>((Departments value) {
              return DropdownMenuItem<Departments>(
                value: value,
                child: Center(
                  child: Text(
                    allWordsCapitilize(value.name),
                    style: TextStyle(
                      color: textColor,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  _buildHistoricMessage(
    bool isLast,
    String message,
    bool send,
    String date,
    String name,
    roomHist.Messages messages,
    String user,
    int index,
  ) {
    if (send) {
      return Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: Text(
                    "$user",
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 5.0),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  child: (messages.attachments != null
                          ? messages.attachments.isNotEmpty
                          : false)
                      ? messages.file.type.contains("image")
                          ? Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showImageZoom(
                                      "$globalurl${messages.attachments[0].titleLink}",
                                    );
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "$globalurl${messages.attachments[0].titleLink}",
                                    progressIndicatorBuilder: (
                                      context,
                                      url,
                                      downloadProgress,
                                    ) =>
                                        CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    width: 200,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Link(
                                    child: Icon(
                                      MdiIcons.cloudDownloadOutline,
                                      color: iconsColor,
                                    ),
                                    url:
                                        "$globalurl${messages.attachments[0].titleLink}"
                                        "?download",
                                  ),
                                ),
                              ],
                            )
                          : messages.file.type.contains("audio")
                              ? _playAudio(
                                  index,
                                  "$globalurl${messages.attachments[0].titleLink}",
                                )
                              : Link(
                                  child: Text(
                                    messages.attachments[0].title,
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  url:
                                      "$globalurl${messages.attachments[0].titleLink}"
                                      "?download",
                                )
                      : copyText(
                          message,
                          corText: textColor,
                        ),
                  padding: EdgeInsets.all(10),
                  width: 200,
                  decoration: BoxDecoration(
                    color: greyColor2,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            isLast
                ? Container(
                    child: Text(
                      DateFormat('dd/MM kk:mm').format(
                        DateTime.parse(date),
                      ),
                      style: TextStyle(
                        color: greyColor,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: 30.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                  )
                : Container()
          ],
        ),
        margin: EdgeInsets.only(
          bottom: 10.0,
          right: 10.0,
        ),
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: expandedChat ? 45 : 30.0,
                  height: expandedChat ? 45 : 30.0,
                  margin: EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    onTap: () {
                      _showImageZoom("");
                    },
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(),
                        padding: EdgeInsets.all(10.0),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                          color: Color(
                            (multiplicadorCor(rooms[selectedRoom].sId,
                                        rooms[selectedRoom].departmentId) *
                                    0xFFFFFF)
                                .toInt(),
                          ).withOpacity(1.0),
                        ),
                        child: Text(
                          '${(name == null || name == '') ? '' : name.substring(0, 1)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      imageUrl: "",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  child: messages.urls != null && !message.contains("Log:")
                      ? (messages.urls[messages.urls.length - 1].headers == null
                              ? false
                              : messages.urls[messages.urls.length - 1].headers
                                  .contentType
                                  .contains("image"))
                          ? Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _showImageZoom(
                                        "${message.replaceAll("]", '')}");
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: "${message.replaceAll("]", '')}",
                                    progressIndicatorBuilder: (
                                      context,
                                      url,
                                      downloadProgress,
                                    ) =>
                                        CircularProgressIndicator(
                                      value: downloadProgress.progress,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    width: 200,
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Link(
                                    child: Icon(
                                      MdiIcons.cloudDownloadOutline,
                                      color: iconsColor,
                                    ),
                                    url: "${message.replaceAll("]", '')}",
                                  ),
                                ),
                              ],
                            )
                          : (messages.urls[messages.urls.length - 1].headers ==
                                      null
                                  ? false
                                  : messages.urls[messages.urls.length - 1]
                                      .headers.contentType
                                      .contains("audio"))
                              ? _playAudio(
                                  index, "${message.replaceAll("]", '')}")
                              : Link(
                                  child: Text(
                                    message
                                        .replaceAll("\n", "")
                                        .replaceAll("]", ""),
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  url: "${message.replaceAll("]", '')}",
                                )
                      : copyText(
                          message,
                          corText: textColor,
                        ),
                  padding: EdgeInsets.all(10),
                  width: 200,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.only(left: 8.0),
                )
              ],
            ),
            isLast
                ? Container(
                    child: Text(
                      DateFormat('dd/MM kk:mm').format(
                        DateTime.parse(date),
                      ),
                      style: TextStyle(
                        color: greyColor,
                        fontSize: 12.0,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: 50.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  _loadAgents() async {
    blocAgentes.add(null);
    blocDepartamentos.add(null);
    List<Users> agents = await RocketChatApi.getAgents();
    Department departments = await RocketChatApi.getDepartments();
    blocDepartamentos.add(departments);
    blocAgentes.add(agents);
  }

  _formLogin() {
    return Container(
      height: heightChatBox,
      width: widthChatBox,
      child: Scaffold(
        key: _scaffoldKey,
        body: Card(
          elevation: 5,
          child: Form(
            key: _formValidator,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            showLoginForm = false;
                          });
                        },
                        child: Icon(
                          Icons.close,
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(
                      urlLogo,
                      width: 200,
                      height: 75,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          textInputForm(
                            context,
                            "Login",
                            "Digite Login",
                            controller: _userChatController,
                            auto: true,
                            focus: _userFocus,
                            action: TextInputAction.go,
                            colorInput: baseColor,
                            next: (term) {
                              fieldFocusChange(
                                  context, _userFocus, _passwordFocus);
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          textInputForm(context, "Senha", "Digite Senha",
                              obscureText: true,
                              controller: _passwordChatController,
                              obscure: true,
                              focus: _passwordFocus,
                              colorInput: baseColor,
                              action: TextInputAction.done, done: () {
                            if (_formValidator.currentState.validate()) {
                              _formValidator.currentState.save();
                              _loginApi();
                            }
                          }),
                          SizedBox(
                            height: 24,
                          ),
                          RaisedButton(
                            color: baseColor,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: mediaQuery(context, 0.012),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formValidator.currentState.validate()) {
                                _formValidator.currentState.save();
                                _loginApi();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showImageZoom(String s) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width - 16,
            height: MediaQuery.of(context).size.height - 16,
            child: Stack(
              children: [
                PhotoView(
                  imageProvider: NetworkImage(s),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                      ),
                      color: iconsColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PopupMenuItem> _optionsBuilder() {
    if (widget.options == null) return [];
    return widget.options
        .map(
          (e) => PopupMenuItem(
            child: ListTile(
              onTap: () {
                e.function(
                  CallbackData(
                    roomId: rooms[selectedRoom]?.sId ?? "",
                    contactName: rooms[selectedRoom]?.fName ?? "Contato",
                    number: "",
                    token: rooms[selectedRoom]?.v?.token ?? "",
                    agentName: rooms[selectedRoom]?.servedBy?.username ?? "",
                    department: rooms[selectedRoom]?.departmentId ?? "",
                    destinyAgentName: destinyAgents?.username ?? "",
                    destinyDepartment: department?.sId ?? "",
                    guestId: "",
                  ),
                );
                Navigator.pop(context);
              },
              title: Text(e.name),
            ),
          ),
        )
        .toList();
  }

  _checkUpdate(List<Update> rooms) async {
    if (globalRooms == null || globalRooms.length != rooms.length) {
      globalRooms = rooms;
      for (int k = 0; k < rooms.length; k++) {
        Guest guestInfo = await RocketChatApi.getDataGuest(rooms[k].v.token);
        roomHist.RoomMessages messages = await RocketChatApi.getRoomMessages(
          rooms[k].sId,
        );

        String storeAcronym = "";
        for (int f = 0; f < messages.messages.length; f++) {
          if (messages.messages[f].message.contains('Log:')) {
            storeAcronym = messages.messages[f].message.substring(
                messages.messages[f].message
                        .lastIndexOf("A opÃ§Ã£o escolhida foi a ") +
                    26,
                messages.messages[f].message
                        .lastIndexOf("A opÃ§Ã£o escolhida foi a ") +
                    29);
            break;
          }
        }

        if (widget.onUpdate != null)
          await widget.onUpdate(
            CallbackData(
              roomId: rooms[selectedRoom]?.sId ?? "",
              contactName: rooms[selectedRoom]?.fName ?? "Contato",
              number:
                  guestInfo?.visitor?.liveChatData?.whatsApp?.substring(2) ??
                      "",
              token: rooms[selectedRoom]?.v?.token ?? "",
              agentName: rooms[selectedRoom]?.servedBy?.username ?? "",
              department: rooms[selectedRoom]?.departmentId ?? "",
              destinyAgentName: destinyAgents?.username ?? "",
              destinyDepartment: department?.sId ?? "",
              guestId: guestInfo?.visitor?.sId ?? "",
              storeAcronym: storeAcronym,
            ),
          );
      }
    }
  }
}
