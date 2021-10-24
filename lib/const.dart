import 'dart:async';
import 'package:dart_meteor_web/dart_meteor_web.dart';
import 'package:flutter/material.dart';

import 'src/model/login.dart';
import 'src/model/socket_room.dart';

//Variavel Api
String globalurl = "";
String urlLogo = "";
String urlSound = "";
String globalRoomId;

//Usuario logado
MeteorClient meteor;
LoginClass rocketUser;

//Subs
SubscriptionHandler subscriptionHandler;
List<Update> rooms;
List<Update> liveRooms;
List<Update> globalRooms;

//Blocs
StreamController blocRooms = StreamController<dynamic>.broadcast();
StreamController blocMensagens = StreamController<dynamic>.broadcast();
StreamController blocAgentes = StreamController<dynamic>.broadcast();
StreamController blocWidgetMiniChats = StreamController<dynamic>.broadcast();
StreamController blocDepartamentos = StreamController<dynamic>.broadcast();
StreamController blocHistoricoConversas = StreamController<dynamic>.broadcast();
StreamController blocHistoricoMensagens = StreamController<dynamic>.broadcast();

//Cores
Color baseColor = Colors.blue[700].withOpacity(1.00);
Color textColor = Color(0xff203152).withOpacity(0.7);
Color iconsColor = Color(0xff203152).withOpacity(0.7);
Color buttonColor = Colors.blue[700].withOpacity(0.7);
Color audioColor = Colors.blue[700].withOpacity(0.75);
Color iconButtonColor = Colors.white;

//Color primaryColor = Color(0xff203152).withOpacity(0.7);
Color greyColor = Color(0xffaeaeae);
Color greyColor2 = Color(0xffE8E8E8);

bool playNotifier = false;
bool chatActive = false;
bool expandedChat = false;
bool agentOnline = true;
bool showLoginForm = false;
bool fistChat = true;
int selectedRoom = 0;
int waitingRooms = 0;

double sizeChatMensagens = 200;
double sizePadraoMensagem = 200;
double alturaPadraoChat = 375;
double heightChatBox = 375;
double larguraPadraoChat = 375;
double widthChatBox = 375;
