import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as mime;

import '../../const.dart';
import '../model/agents.dart';
import '../model/department.dart';
import '../model/guest.dart';
import '../model/login.dart';
import '../model/room_messages.dart';
import '../model/socket_room.dart';
import '../model/tags.dart';

final rocketHeaders = {
  "X-Auth-Token": "${rocketUser?.data?.authToken}",
  "X-User-Id": "${rocketUser?.data?.userId}",
  "Content-type": "application/json",
};

class RocketChatApi {
  static Future<LoginClass?> loginRocket(
    String login,
    String password, {
    String? resume = '',
  }) async {
    String url = '$globalurl'
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

    http.Response response = await http.post(
      Uri.parse(url),
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

  static Future<List<Update>> getLiveRooms(String? agent, String? token) async {
    try {
      var resp = await meteor?.call('rooms/get', [
        {"\$date": 0}
      ]);

      SocketRoom chats = SocketRoom.fromJson(resp);

      List<Update> liveRooms = [];
      chats.update?.forEach((element) {
        if (element.t == 'l') liveRooms.add(element);
      });

      return liveRooms;
    } catch (error) {
      print(error);
      return [];
    }
  }

  static Future<dynamic> sendMessage(String room, String message) async {
    String url = '$globalurl'
        '/api/v1/chat.postMessage';

    Map data = {
      "roomId": "$room",
      "text": "$message",
    };

    http.Response response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: rocketHeaders,
    );

    return json.decode(response.body);
  }

  static Future<dynamic> uploadFile(
    Uint8List img,
    String roomId,
    String nome,
    String type,
  ) async {
    String url = '$globalurl'
        '/api/v1/rooms.upload/$roomId';

    var splitType = type.split('/');
    var request = http.MultipartRequest('POST', Uri.parse("$url"));
    request.headers["X-Auth-Token"] = "${rocketUser?.data?.authToken}";
    request.headers["X-User-Id"] = "${rocketUser?.data?.userId}";
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        img,
        filename: nome,
        contentType: mime.MediaType("${splitType[0]}", "${splitType[1]}"),
      ),
    );
    var res = await request.send();
    return res.statusCode;
  }

  static Future<dynamic> uploadAudio(
    Uint8List audio,
    String room,
    String name,
  ) async {
    String url = '$globalurl'
        '/api/v1/rooms.upload/$room';

    var request = http.MultipartRequest('POST', Uri.parse("$url"));
    request.headers["X-Auth-Token"] = "${rocketUser?.data?.authToken}";
    request.headers["X-User-Id"] = "${rocketUser?.data?.userId}";
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        audio,
        filename: '$name',
        contentType: mime.MediaType("audio", "mpeg"),
      ),
    );
    var res = await request.send();
    return res.statusCode;
  }

  static Future<dynamic> closeRoom(
    String? roomId,
    String? visitorToken,
  ) async {
    String url = '$globalurl'
        '/api/v1/livechat/room.close';

    Map data = {
      "rid": "$roomId",
      "token": "$visitorToken",
    };

    http.Response response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: rocketHeaders,
    );

    return json.decode(response.body);
  }

  static Future<dynamic> transferRoom(
    String? roomId,
    String? userId, {
    String? department = '',
  }) async {
    String url = '$globalurl'
        '/api/v1/livechat/room.forward';

    Map data = {
      "roomId": "$roomId",
      "userId": "$userId",
      "departmentId": "$department",
    };

    var response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: rocketHeaders,
    );

    return json.decode(response.body);
  }

  ///Possible Status -> online, away, busy, offline
  static Future<dynamic> changeStatus(bool status) async {
    String url = '$globalurl'
        '/api/v1/users.setStatus';

    Map data = {
      "message": "Status: $status",
      "status": "${status ? 'online' : 'offline'}",
    };

    http.Response response = await http.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: rocketHeaders,
    );

    return json.decode(response.body);
  }

  static Future<List<Users>?> getAgents() async {
    try {
      String url = '$globalurl'
          '/api/v1/livechat/users/agent';

      http.Response response = await http.get(Uri.parse(url), headers: rocketHeaders);

      AgentsOnline agents = AgentsOnline.fromJson(json.decode(response.body));

      List<Users> users = [];
      agents.users?.forEach((element) {
        if (element.statusLiveChat == "available" && element.status == "online") {
          users.add(element);
        }
      });

      return users;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<Department?> getDepartments() async {
    try {
      String url = '$globalurl'
          '/api/v1/livechat/department';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: rocketHeaders,
      );

      Department departments = Department.fromJson(
        json.decode(response.body),
      );

      return departments;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<Guest?>? getDataGuest(String? tokenGuest) async {
    try {
      String url = '$globalurl'
          '/api/v1/livechat/visitor/'
          '$tokenGuest';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: rocketHeaders,
      );

      Guest? guestInfo;
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

  static Future<dynamic> getHistGuest(
    String? roomId,
    String? guestId,
  ) async {
    try {
      String url = '$globalurl'
          '/api/v1/livechat/visitors.chatHistory/room/'
          '$roomId'
          '/visitor/'
          '$guestId';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: rocketHeaders,
      );

      return json.decode(response.body);
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<RoomMessages?> getRoomMessages(String? roomId) async {
    try {
      String url = '$globalurl'
          '/api/v1/channels.messages?'
          'roomId=$roomId';

      http.Response response = await http.get(Uri.parse(url), headers: rocketHeaders);

      RoomMessages messagesRoom = RoomMessages.fromJson(
        json.decode(response.body),
      );

      return messagesRoom;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<Tag?> getListTags() async {
    try {
      String url = '$globalurl'
          '/api/v1/livechat/tags.list';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: rocketHeaders,
      );

      Tag tags = Tag.fromJson(
        json.decode(response.body),
      );

      return tags;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
