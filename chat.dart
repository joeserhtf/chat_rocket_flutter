import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:io';
import 'dart:math';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_meteor_web/dart_meteor_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:link/link.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';
import 'classes/class_liveChatRooms.dart';
import 'classes/class_mensagens.dart';
import 'classes/AgentesClass.dart';
import 'classes/class_login.dart';
import 'components/chat_api.dart';
import 'components/input_bar.dart';
import 'components/widgets.dart';
import 'const.dart';

class WidgetChat extends StatefulWidget {
  @override
  _WidgetChatState createState() => _WidgetChatState();
}

class _WidgetChatState extends State<WidgetChat> {
  MeteorClient meteor = MeteorClient.connect(
    url: "wss://carajas.rocket.chat/websocket",
  );

  SubscriptionHandler subscriptionHandler;

  ClassMensagem mensagens;
  LiveRoomsClass rooms;

  StreamController _blocConversas = StreamController<dynamic>.broadcast();
  StreamController _blocMensagens = StreamController<dynamic>.broadcast();
  StreamController _blocAgentes = StreamController<dynamic>.broadcast();

  bool expandido = false;

  double sizeChatMensagens = 200;
  double sizePadraoMensagem = 200;
  double alturaPadraoChat = 375;
  double alturaChatBox = 375;
  double larguraPadraoChat = 375;
  double larguraChatBox = 375;

  LiveRoomsClass conversasLive;

  int pendencias = 0;

  bool transferindo = false;

  Users agenteDestino;
  ScrollController _controller = new ScrollController();

  bool usuarioOnline = true;

  bool digitarLogin = false;

  TextEditingController _userChatController = TextEditingController(text: '');
  TextEditingController _passworChatController = TextEditingController(text: '');

  final FocusNode _userFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final _formValidator = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
    //*print('Rebuild Chat');
    return SafeArea(
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
        child: Align(
          alignment: Alignment.bottomRight,
          child: _body(),
        ),
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
                    var savedToken = html.window.localStorage['Meteor.loginToken'];
                    _logarApi(resume: savedToken);
                  } else {
                    if (rocketUser.data != null) {
                      _streamAgente(rocketUser.data.userId);
                    }
                  }
                  return chatAtivo ? _chat() : _flatButton();
                }
                return digitarLogin ? _formLogin() : _telaLogin();
              },
            );
          }
          return _telaReconexao();
        }
        return Container();
      },
    );
  }

  _telaReconexao() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        backgroundColor: chatColor,
        child: Icon(Icons.refresh),
        onPressed: () {
          meteor.reconnect();
        },
      ),
    );
  }

  _flatButton() {
    return StreamBuilder(
        stream: meteor.collections['stream-notify-user'],
        builder: (context, snapshot) {
          if ((conversasLive == null || snapshot.hasData)) {
            _carregarConversas();
          }
          return StreamBuilder(
              stream: _blocConversas.stream,
              builder: (context, snapshot) {
                return Align(
                  alignment: Alignment.bottomRight,
                  child: Badge(
                    showBadge: true,
                    badgeContent: Text(
                      '$pendencias',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    shape: BadgeShape.circle,
                    animationType: BadgeAnimationType.scale,
                    child: FloatingActionButton(
                      backgroundColor: chatColor,
                      onPressed: () {
                        setState(() {
                          chatAtivo = !chatAtivo;
                        });
                      },
                      child: Icon(MdiIcons.chat),
                    ),
                  ),
                );
              });
        });
  }

  _chat() {
    return Container(
      width: larguraChatBox,
      child: _conversas(),
    );
  }

  _conversas() {
    return StreamBuilder(
      stream: meteor.collections['stream-room-messages'],
      builder: (context, snapshot) {
        _carregarConversas();
        return StreamBuilder(
          stream: _blocConversas.stream,
          builder: (context, snapshot) {
            rooms = snapshot.data;
            if (snapshot.hasData) {
              if (rooms.rooms.length == 0) {
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
                      backgroundColor: chatColor,
                      onPressed: () {},
                      child: Icon(MdiIcons.chat),
                    ),
                  ),
                );
              }
              if (selecionado > rooms.rooms.length) {
                selecionado = 0;
              }
              _streamSala(rooms.rooms[selecionado].sId);
              //_verificarTickets(rooms);
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  expandido ? Container() : _montarConversas(rooms),
                  Card(
                    elevation: 5,
                    child: Container(
                      height: alturaChatBox,
                      child: Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                _listaMensagens(),
                                expandido ? _barraSuperior() : _botoes(),
                              ],
                            ),
                          ),
                          InputBar(rooms.rooms[selecionado].sId ?? ''),
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
    );
  }

  _listaMensagens() {
    return StreamBuilder(
      stream: meteor.collections['stream-room-messages'],
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _carregarMensagens();
        } else {
          _carregarMensagens();
        }
        return StreamBuilder(
          stream: _blocMensagens.stream,
          builder: (context, snapshot) {
            ClassMensagem mensagens = snapshot.data;
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: mensagens.messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return _montaMensagem(
                    index == 0,
                    '${mensagens.messages[index].msg}',
                    !mensagens.messages[index].u.username.contains("guest"),
                    mensagens.messages[index].ts.date ?? 0,
                    mensagens.messages[index].u.name,
                    mensagens.messages[index],
                    index,
                  );
                },
              );
            }
            if (rooms == null || rooms.rooms.isEmpty) {
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
    );
  }

  _botoes() {
    return Container(
      color: transferindo
          ? expandido
              ? Colors.transparent
              : Colors.white
          : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Visibility(
            visible: transferindo,
            child: _dropAgentes(),
          ),
          Visibility(
            visible: transferindo,
            child: Row(
              children: [
                Material(
                  child: IconButton(
                    iconSize: 22,
                    color: Colors.green,
                    icon: Icon(
                      MdiIcons.check,
                    ),
                    onPressed: () {
                      _transferirConversa();
                    },
                  ),
                  color: Colors.transparent,
                ),
                Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.only(right: expandido ? 8 : 0),
                    child: IconButton(
                      iconSize: 22,
                      color: Colors.red,
                      icon: Icon(
                        MdiIcons.close,
                      ),
                      onPressed: () {
                        setState(() {
                          transferindo = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !transferindo,
            child: Tooltip(
              message: "Opções",
              child: PositionedTapDetector(
                onTap: (detais) {
                  _showPopupMenu(detais.global);
                },
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    MdiIcons.dotsHorizontal,
                    color: expandido ? Colors.white : primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !transferindo,
            child: Row(
              children: [
                IconButton(
                  tooltip: expandido ? "Reduzir" : 'Tela Cheia',
                  iconSize: 22,
                  color: expandido ? Colors.white : primaryColor,
                  icon: Icon(
                    expandido ? MdiIcons.arrowCollapse : MdiIcons.arrowExpand,
                  ),
                  onPressed: () {
                    setState(() {
                      expandido = !expandido;
                      sizeChatMensagens = expandido ? MediaQuery.of(context).size.width * 0.55 : sizePadraoMensagem;
                      alturaChatBox = expandido ? MediaQuery.of(context).size.height - 72 : alturaPadraoChat;
                      larguraChatBox = expandido ? MediaQuery.of(context).size.width - 72 : larguraPadraoChat;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(right: expandido ? 8 : 0),
                  child: IconButton(
                    tooltip: 'Minimizar',
                    iconSize: 22,
                    color: expandido ? Colors.white : primaryColor,
                    icon: Icon(
                      MdiIcons.arrowBottomRight,
                    ),
                    onPressed: () {
                      setState(() {
                        chatAtivo = !chatAtivo;
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

  _barraSuperior() {
    return Container(
      height: 50,
      color: chatColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _montarConversas(rooms),
          ),
          _botoes(),
        ],
      ),
    );
  }

  conversasMini(Rooms sala, int index) {
    bool ativo = selecionado == index;
    return GestureDetector(
      onTap: () {
        selecionado = index;
        _blocMensagens.add(null);
        _carregarConversas();
        _streamSala(sala.sId);
      },
      child: expandido
          ? _conversasExpandido(sala, ativo)
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Badge(
                showBadge: !ativo && sala.waitingResponse,
                badgeContent: Text(
                  '!',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                shape: BadgeShape.circle,
                animationType: BadgeAnimationType.scale,
                child: Card(
                  elevation: 5,
                  margin: ativo ? EdgeInsets.only(right: 0, left: 4) : EdgeInsets.all(4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                        bottomLeft: Radius.circular(ativo ? 0 : 32),
                        bottomRight: Radius.circular(ativo ? 0 : 32)),
                  ),
                  child: Container(
                    height: ativo ? 40 : 30,
                    width: ativo ? 40 : 30,
                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      imageUrl: "",
                      placeholder: (context, url) => Container(
                        child: CircularProgressIndicator(),
                        padding: EdgeInsets.all(10.0),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: ativo ? 40 : 30,
                        height: ativo ? 40 : 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                              bottomLeft: Radius.circular(ativo ? 0 : 32),
                              bottomRight: Radius.circular(ativo ? 0 : 32)),
                          color: Color((multiplicadorCor(sala.sId, sala.departmentId) * 0xFFFFFF).toInt()).withOpacity(1.0),
                        ),
                        child: Text(
                          '${sala == null ? '' : sala.fname.substring(0, 1)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  multiplicadorCor(String roomId, String depId) {
    return "$roomId".codeUnits.reduce((value, element) => value + element) * "$depId".codeUnits.reduce((value, element) => value + element);
  }

  _montaMensagem(
    bool ultimo,
    String mensagem,
    bool enviada,
    int date,
    String name,
    Messages mensage,
    int index,
  ) {
    // Enviada
    if (enviada) {
      return Container(
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Container(
                  child: (mensage.attachments != null ? mensage.attachments.isNotEmpty : false)
                      ? mensage.file.type.contains("image")
                          ? Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: "https://carajas.rocket.chat${mensage.attachments[0].titleLink}",
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      CircularProgressIndicator(value: downloadProgress.progress),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Link(
                                    child: Icon(
                                      MdiIcons.cloudDownloadOutline,
                                      color: primaryColor,
                                    ),
                                    url: "https://carajas.rocket.chat${mensage.attachments[0].titleLink}?download",
                                  ),
                                ),
                              ],
                            )
                          : mensage.file.type.contains("audio")
                              ? _playAudio(index, "https://carajas.rocket.chat${mensage.attachments[0].titleLink}")
                              : Link(
                                  child: Text(
                                    mensage.attachments[0].title,
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  url: "https://carajas.rocket.chat${mensage.attachments[0].titleLink}?download",
                                )
                      : Text(
                          mensagem,
                          style: TextStyle(color: primaryColor),
                        ),
                  padding: EdgeInsets.all(10),
                  width: sizeChatMensagens,
                  decoration: BoxDecoration(color: greyColor2, borderRadius: BorderRadius.circular(8.0)),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            ultimo
                ? Container(
                    child: Text(
                      DateFormat('dd/MM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(date)),
                      style: TextStyle(color: greyColor, fontSize: 12.0, fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 30.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
        ),
        margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
      );
    } else {
      // Recebida
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: expandido ? 45 : 30.0,
                  height: expandido ? 45 : 30.0,
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
                                (multiplicadorCor(rooms.rooms[selecionado].sId, rooms.rooms[selecionado].departmentId) * 0xFFFFFF).toInt())
                            .withOpacity(1.0),
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
                Container(
                  child: mensage.urls != null && !mensagem.contains("Log:")
                      ? (mensage.urls[mensage.urls.length - 1].headers == null
                              ? false
                              : mensage.urls[mensage.urls.length - 1].headers.contentType.contains("image"))
                          ? Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: "${mensagem.replaceAll("]", '')}",
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      CircularProgressIndicator(value: downloadProgress.progress),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Link(
                                    child: Icon(
                                      MdiIcons.cloudDownloadOutline,
                                      color: primaryColor,
                                    ),
                                    url: "${mensagem.replaceAll("]", '')}",
                                  ),
                                ),
                              ],
                            )
                          : (mensage.urls[mensage.urls.length - 1].headers == null
                                  ? false
                                  : mensage.urls[mensage.urls.length - 1].headers.contentType.contains("audio"))
                              ? _playAudio(index, "${mensagem.replaceAll("]", '')}")
                              : Link(
                                  child: Text(
                                    mensagem.replaceAll("\n", "").replaceAll("]", ""),
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  url: "${mensagem.replaceAll("]", '')}",
                                  //onError: _onErrorCallback
                                )
                      : Text(
                          mensagem,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                  padding: EdgeInsets.all(10),
                  width: sizeChatMensagens,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.only(left: 8.0),
                )
              ],
            ),
            ultimo
                ? Container(
                    child: Text(
                      DateFormat('dd/MM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(date, isUtc: false)),
                      style: TextStyle(color: greyColor, fontSize: 12.0, fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
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
              _fecharSala();
            },
            title: Text("Encerrar"),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              setState(() {
                transferindo = true;
                Navigator.pop(context);
              });
              _carregarAgentes();
              agenteDestino = null;
            },
            title: Text("Transferir"),
          ),
        ),
      ],
      elevation: 8.0,
    );
  }

  _telaLogin() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        backgroundColor: chatColor,
        child: Icon(MdiIcons.loginVariant),
        onPressed: () {
          setState(() {
            digitarLogin = true;
          });
          //_logarApi();
        },
      ),
    );
  }

  _mensagensLoad(String roomID) async {
    var resp = await meteor.call('loadHistory', [
      "$roomID",
      null,
      0,
      {"\$date": DateTime.now().millisecondsSinceEpoch}
    ]);
    //print(resp);
    mensagens = ClassMensagem.fromJson(resp);
    return mensagens;
  }

  _carregarConversas() async {
    conversasLive = await RocketChatApi.getLiveRooms(rocketUser.data.userId, rocketUser.data.authToken);
    pendencias = 0;
    conversasLive.rooms.forEach((element) {
      if (element.waitingResponse) pendencias++;
    });
    _blocConversas.add(conversasLive);
    return true;
  }

  _carregarMensagens() async {
    if (rooms == null) await Future.delayed(Duration(seconds: 1));
    ClassMensagem mensagens = await _mensagensLoad(rooms.rooms[selecionado].sId);
    _blocMensagens.add(mensagens);
  }

  _logarApi({String resume = ''}) async {
    LoginClass usuarioApi = await RocketChatApi.loginRockt(_userChatController.text, _passworChatController.text, resume: resume);
    if (usuarioApi == null) {
      _onError("Usuário ou senha incorreto(s)!");
    } else {
      rocketUser = usuarioApi;
      _streamAgente(rocketUser.data.userId);
      _logarSocketToken(rocketUser.data.authToken);
      RocketChatApi.atualizarStatus(true);
    }
  }

  void _onError(msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 3),
    ));
  }

  _logarSocketToken(String token) {
    meteor.loginWithToken(token: "$token");
  }

  _streamAgente(String agent) {
    //subscriptionHandler = meteor.subscribe('stream-notify-user', ["$agent/notification", false]);
    subscriptionHandler = meteor.subscribe('stream-notify-user', ["$agent/rooms-changed", false]);
  }

  _streamSala(String roomId) {
    globalRoomId = roomId;
    subscriptionHandler = meteor.subscribe('stream-room-messages', ["__my_messages__", false]);
  }

  _montarConversas(LiveRoomsClass rooms) {
    List<Widget> salas = [];

    for (int i = rooms.rooms.length - 1; i >= 0; i--) {
      Rooms sala = rooms.rooms[i];
      salas.add(conversasMini(sala, i));
    }

    return Container(
      width: expandido ? null : 375,
      child: Stack(
        children: [
          Container(
            height: expandido ? 50 : 40,
            padding: EdgeInsets.only(right: 8),
            child: ListView(
              controller: _controller,
              padding: EdgeInsets.only(left: 25, right: 35),
              scrollDirection: Axis.horizontal,
              children: salas,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(right: 8),
              height: 40,
              width: 35,
              child: Tooltip(
                message: 'Status',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await RocketChatApi.atualizarStatus(!usuarioOnline);
                      setState(() {
                        usuarioOnline = !usuarioOnline;
                      });
                    },
                    child: Icon(
                      Icons.circle,
                      color: usuarioOnline ? Colors.green : Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.only(right: 8),
              height: 40,
              width: 35,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _controller.animateTo((_controller.position.pixels + 50),
                        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
                  },
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: expandido ? Colors.white : primaryColor,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _fecharSala() async {
    await RocketChatApi.fecharConversa(rooms.rooms[selecionado].sId, rooms.rooms[selecionado].v.token);
    await _carregarConversas();
    setState(() {
      selecionado = 0;
    });
  }

  _transferirConversa() async {
    await RocketChatApi.transferirConversa(rooms.rooms[selecionado].sId, agenteDestino.sId, departamento: '');
    await _carregarConversas();
    setState(() {
      transferindo = false;
      agenteDestino = null;
      selecionado = 0;
    });
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
                if (processingState == ProcessingState.loading || processingState == ProcessingState.buffering) {
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
                    color: audioIconColor,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: Icon(Icons.pause),
                    iconSize: 28.0,
                    onPressed: player.pause,
                    color: audioIconColor,
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons.replay),
                    iconSize: 28.0,
                    color: audioIconColor,
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

  _conversasExpandido(Rooms sala, bool selecionado) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.white, width: 0.3),
        ),
      ),
      height: 50,
      width: MediaQuery.of(context).size.width * 0.08,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Center(
                child: Text(
                  allWordsCapitilize(sala.fname).split(' ')[0],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selecionado ? Colors.white : Colors.grey[300],
                    fontSize: selecionado ? 18 : 14,
                  ),
                ),
              ),
              selecionado
                  ? Container(
                      height: 2,
                      color: Colors.grey[400],
                      width: MediaQuery.of(context).size.width * 0.08,
                    )
                  : Container(),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 2),
              child: Badge(
                showBadge: sala.waitingResponse && !selecionado,
                badgeContent: Text(
                  '!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                shape: BadgeShape.circle,
                animationType: BadgeAnimationType.scale,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _dropAgentes() {
    return StreamBuilder(
      stream: _blocAgentes.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: 30,
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButton<Users>(
            disabledHint: Text('Agente'),
            value: agenteDestino,
            icon: Icon(Icons.arrow_downward),
            iconSize: 15,
            elevation: 14,
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (Users value) {
              setState(() {
                agenteDestino = value;
              });
            },
            items: snapshot.data.map<DropdownMenuItem<Users>>((Users value) {
              return DropdownMenuItem<Users>(
                value: value,
                child: Center(child: Text(allWordsCapitilize(value.name))),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _carregarAgentes() async {
    _blocAgentes.add(null);
    List<Users> agentes = await RocketChatApi.getAgents();
    _blocAgentes.add(agentes);
  }

  _formLogin() {
    return Container(
      height: alturaChatBox,
      width: 375,
      child: Scaffold(
        key: _scaffoldKey,
        body: Card(
          elevation: 5,
          child: Form(
            key: _formValidator,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  Image.network(
                    'https://carajas.rocket.chat/images/logo/logo.svg',
                    width: 200,
                    height: 80,
                  ),
                  textInputForm(
                    context,
                    "Login",
                    "Digite Login",
                    controller: _userChatController,
                    auto: true,
                    focus: _userFocus,
                    action: TextInputAction.go,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  textInputForm(context, "Senha", "Digite Senha",
                      obscureText: true,
                      controller: _passworChatController,
                      obscure: true,
                      focus: _passwordFocus,
                      action: TextInputAction.done, done: () {
                    if (_formValidator.currentState.validate()) {
                      _formValidator.currentState.save();
                      _logarApi();
                    }
                  }),
                  SizedBox(
                    height: 24,
                  ),
                  RaisedButton(
                    color: Colors.blue[700].withOpacity(0.7),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: mediaQuery(context, 0.012)),
                      ),
                    ),
                    onPressed: () {
                      if (_formValidator.currentState.validate()) {
                        _formValidator.currentState.save();
                        _logarApi();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*void _verificarTickets(LiveRoomsClass rooms) {
    for(int k = 0; k < rooms.rooms.length; k++){
      rooms.rooms
    }
  }*/
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Slider(
          min: 0.0,
          activeColor: audioIconColor,
          inactiveColor: audioIconColor,
          max: widget.duration.inMilliseconds.toDouble(),
          value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(), widget.duration.inMilliseconds.toDouble()),
          onChanged: (value) {
            setState(() {
              _dragValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd(Duration(milliseconds: value.round()));
            }
            _dragValue = null;
          },
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$').firstMatch("$_remaining")?.group(1) ?? '$_remaining',
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}
