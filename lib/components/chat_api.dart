import 'dart:convert';
import 'package:chat_rocket_flutter/classes/class_agents.dart';
import 'package:chat_rocket_flutter/classes/class_depart.dart';
import 'package:chat_rocket_flutter/classes/class_guest.dart';
import 'package:chat_rocket_flutter/classes/class_login.dart';
import 'package:chat_rocket_flutter/classes/class_roomMenssages.dart';
import 'package:chat_rocket_flutter/classes/class_socketRoom.dart';
import 'package:chat_rocket_flutter/const.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart' as mime;

final rocketHeaders = {
  "X-Auth-Token": "${rocketUser.data.authToken}",
  "X-User-Id": "${rocketUser.data.userId}",
  "Content-type": "application/json",
};

class RocketChatApi {
  static Future<LoginClass> loginRockt(String login, String password, {String resume = ''}) async {
    var url = '$globalurl'
        '/api/v1/login';

    Map data;

    resume == ''
        ? data = {
            "user": "$login",
            "password": "$password",
          }
        : data = {
            "resume": "$resume",
          };

    var response = await http.post(
      url,
      body: data,
    );

    if (json.decode(response.body)["status"] == "error") {
      return null;
    } else {
      LoginClass user = LoginClass.fromJson(json.decode(response.body));
      rocketUser = user;

      return user;
    }
  }

  static Future<List<Update>> getLiveRooms(String agent, String token) async {
    try {
      var resp = await meteor.call('rooms/get', [
        {"\$date": 0}
      ]);

      SocketRoom chats = SocketRoom.fromJson(resp);

      List<Update> liveRooms = [];
      chats.update.forEach((element) {
        if (element.t == 'l') liveRooms.add(element);
      });

      return liveRooms;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<dynamic> sendMessage(String room, String message) async {
    var url = '$globalurl'
        '/api/v1/chat.postMessage';

    Map data = {
      "roomId": "$room",
      "text": "$message",
    };

    var response = await http.post(url, body: json.encode(data), headers: rocketHeaders);

    return json.decode(response.body);
  }

  static Future<dynamic> uploadFile(Uint8List img, String roomId, String nome, String type) async {
    var url = '$globalurl'
        '/api/v1/rooms.upload/$roomId';

    var ltype = type.split('/');
    var request = http.MultipartRequest('POST', Uri.parse("$url"));
    request.headers["X-Auth-Token"] = "${rocketUser.data.authToken}";
    request.headers["X-User-Id"] = "${rocketUser.data.userId}";
    request.files.add(http.MultipartFile.fromBytes('file', img, filename: nome, contentType: mime.MediaType("${ltype[0]}", "${ltype[1]}")));
    var res = await request.send();
    return res.statusCode;
  }

  static Future<dynamic> uploadAudio(Uint8List audio, String room, String name) async {
    var url = '$globalurl'
        '/api/v1/rooms.upload/$room';

    var request = http.MultipartRequest('POST', Uri.parse("$url"));
    request.headers["X-Auth-Token"] = "${rocketUser.data.authToken}";
    request.headers["X-User-Id"] = "${rocketUser.data.userId}";
    request.files.add(http.MultipartFile.fromBytes('file', audio, filename: '$name', contentType: mime.MediaType("audio", "mpeg")));
    var res = await request.send();
    return res.statusCode;
  }

  static Future<dynamic> closeRoom(String roomId, String visitorToken) async {
    var url = '$globalurl'
        '/api/v1/livechat/room.close';

    Map data = {
      "rid": "$roomId",
      "token": "$visitorToken",
    };

    var response = await http.post(url, body: json.encode(data), headers: rocketHeaders);

    return json.decode(response.body);
  }

  static Future<dynamic> transferRoom(String roomId, String userId, {String departamento = ''}) async {
    var url = '$globalurl'
        '/api/v1/livechat/room.forward';

    Map data = {
      "roomId": "$roomId",
      "userId": "$userId",
      "departmentId": "$departamento",
    };

    var response = await http.post(url, body: json.encode(data), headers: rocketHeaders);

    return json.decode(response.body);
  }

  static Future<dynamic> changeStatus(bool status) async {
    var url = '$globalurl';
    //Possible Status -> online, away, busy, offline
    url += '/api/v1/users.setStatus';

    Map data = {
      "message": "Status: $status",
      "status": "${status ? 'online' : 'offline'}",
    };

    var response = await http.post(url, body: json.encode(data), headers: rocketHeaders);

    return json.decode(response.body);
  }

  static Future<List<Users>> getAgents() async {
    try {
      var url = '$globalurl'
          '/api/v1/livechat/users/agent';

      var response = await http.get(url, headers: rocketHeaders);

      AgentsOnline agents = AgentsOnline.fromJson(json.decode(response.body));

      List<Users> users = [];
      agents.users.forEach((element) {
        if (element.statusLivechat == "available" && element.status == "online") {
          users.add(element);
        }
      });

      return users;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<ClassDepartamento> getDeparts() async {
    try {
      var url = '$globalurl'
          '/api/v1/livechat/department';

      var response = await http.get(url, headers: rocketHeaders);

      ClassDepartamento deps = ClassDepartamento.fromJson(json.decode(response.body));

      return deps;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<Guest> getDataGuest(String tokenGuest) async {
    try {
      var url = '$globalurl'
          '/api/v1/livechat/visitor/'
          '$tokenGuest';

      var response = await http.get(url, headers: rocketHeaders);

      Guest guestInfo;
      try {
        guestInfo = Guest.fromJson(json.decode(response.body));
      } on Exception catch (e) {
        print(e);
      }

      return guestInfo;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<dynamic> getHistGuest(String roomId, String guestId) async {
    try {
      var url = '$globalurl'
          '/api/v1/livechat/visitors.chatHistory/room/'
          '$roomId'
          '/visitor/'
          '$guestId';

      var response = await http.get(url, headers: rocketHeaders);

      return json.decode(response.body);
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<RoomMenssages> getRoomMenssages(String roomId) async {
    try {
      var url = '$globalurl'
          '/api/v1/channels.messages?'
          'roomId=$roomId';

      var response = await http.get(url, headers: rocketHeaders);

      RoomMenssages menssagesRoom = RoomMenssages.fromJson(json.decode(response.body));

      return menssagesRoom;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
