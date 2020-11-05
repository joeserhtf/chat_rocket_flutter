import 'package:flutter/material.dart';
import 'classes/class_login.dart';
//Variavel Api
var globalurl = "https://carajas.rocket.chat";
String globalRoomId;
//Usuario logado
LoginClass rocketUser;

//Cores
var primaryColor = Color(0xff203152).withOpacity(0.7);
var greyColor = Color(0xffaeaeae);
var greyColor2 = Color(0xffE8E8E8);
var chatColor = Colors.blue[700].withOpacity(1.00); //Colors.orange[700];
var audioIconColor = Colors.blue[700].withOpacity(0.75); //Colors.orange;

bool chatAtivo = false;
int selecionado = 0;
