import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart' as mime;
import '../classes/class_login.dart';
import '../const.dart';
import '../classes/AgentesClass.dart';
import '../classes/class_liveChatRooms.dart';

class RocketChatApi {
  static Future<LoginClass> loginRockt(String login, String senha, {String resume = ''}) async {
    var url = '$globalurl'
        '/api/v1/login';

    Map data;

    resume == ''
        ? data = {
            "user": "$login",
            "password": "$senha",
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
      LoginClass usuario = LoginClass.fromJson(json.decode(response.body));
      rocketUser = usuario;

      return usuario;
    }
  }

  static Future<LiveRoomsClass> getLiveRooms(String agent, String token) async {
    try {
      var url = '$globalurl'
          '/api/v1/livechat/rooms?'
          'open=true&'
          'agents[]=${rocketUser.data.userId}';

      var response = await http.get(url, headers: {
        "X-Auth-Token": "${rocketUser.data.authToken}",
        "X-User-Id": "${rocketUser.data.userId}",
      });

      LiveRoomsClass chats;
      try {
        chats = LiveRoomsClass.fromJson(json.decode(response.body));
      } on Exception catch (e) {
        print(e);
      }

      return chats;
    } catch (error) {
      print(error);
      return null;
    }
  }

  static Future<dynamic> enviarMensagem(String sala, String mensagem) async {
    var url = '$globalurl'
        '/api/v1/chat.postMessage';

    Map data = {
      "roomId": "$sala",
      "text": "$mensagem",
    };

    var body = json.encode(data);

    var response = await http.post(url, body: body, headers: {
      "X-Auth-Token": "${rocketUser.data.authToken}",
      "X-User-Id": "${rocketUser.data.userId}",
      "Content-type": "application/json",
    });

    return json.decode(response.body);
  }

  static Future<dynamic> uploadArquivo(Uint8List img, String sala, String nome, String type) async {
    var url = '$globalurl'
        '/api/v1/rooms.upload/$sala';

    var ltype = type.split('/');
    var request = http.MultipartRequest('POST', Uri.parse("$url"));
    request.headers["X-Auth-Token"] = "${rocketUser.data.authToken}";
    request.headers["X-User-Id"] = "${rocketUser.data.userId}";
    request.files
        .add(await http.MultipartFile.fromBytes('file', img, filename: nome, contentType: mime.MediaType("${ltype[0]}", "${ltype[1]}")));
    var res = await request.send();
    final bbb = await http.Response.fromStream(res);
    return res.statusCode;
  }

  static Future<dynamic> uploadAudio(Uint8List audio, String sala, String nome) async {
    var url = '$globalurl'
        '/api/v1/rooms.upload/$sala';

    var request = http.MultipartRequest('POST', Uri.parse("$url"));
    request.headers["X-Auth-Token"] = "${rocketUser.data.authToken}";
    request.headers["X-User-Id"] = "${rocketUser.data.userId}";
    request.files.add(await http.MultipartFile.fromBytes('file', audio, filename: '$nome', contentType: mime.MediaType("audio", "mpeg")));
    var res = await request.send();
    final bbb = await http.Response.fromStream(res);
    //*print(bbb.body);
    return res.statusCode;
  }

  static Future<dynamic> fecharConversa(String roomId, String visitorToken) async {
    var url = '$globalurl'
        '/api/v1/livechat/room.close';

    Map data = {
      "rid": "$roomId",
      "token": "$visitorToken",
    };

    var body = json.encode(data);

    var response = await http.post(url, body: body, headers: {
      "X-Auth-Token": "${rocketUser.data.authToken}",
      "X-User-Id": "${rocketUser.data.userId}",
      "Content-type": "application/json",
    });

    return json.decode(response.body);
  }

  static Future<dynamic> transferirConversa(String roomId, String userId, {String departamento = ''}) async {
    var url = '$globalurl';

    url += '/api/v1/livechat/room.forward';

    Map data = {
      "roomId": "$roomId",
      "userId": "$userId",
      "departmentId": "$departamento",
    };

    var body = json.encode(data);

    var response = await http.post(url, body: body, headers: {
      "X-Auth-Token": "${rocketUser.data.authToken}",
      "X-User-Id": "${rocketUser.data.userId}",
      "Content-type": "application/json",
    });

    return json.decode(response.body);
  }

  static Future<dynamic> atualizarStatus(bool status) async {
    var url = '$globalurl';
    //The user's status like online, away, busy, offline.
    url += '/api/v1/users.setStatus';

    Map data = {
      "message": "Status: $status",
      "status": "${status ? 'online' : 'offline'}",
    };

    var body = json.encode(data);

    var response = await http.post(url, body: body, headers: {
      "X-Auth-Token": "${rocketUser.data.authToken}",
      "X-User-Id": "${rocketUser.data.userId}",
      "Content-type": "application/json",
    });

    return json.decode(response.body);
  }

  static Future<List<Users>> getAgents() async {
    try {
      var url = '$globalurl'
          '/api/v1/livechat/users/agent';

      var response = await http.get(url, headers: {
        "X-Auth-Token": "${rocketUser.data.authToken}",
        "X-User-Id": "${rocketUser.data.userId}",
      });

      AgentsOnline agentes;
      try {
        agentes = AgentsOnline.fromJson(json.decode(response.body));
      } on Exception catch (e) {
        print(e);
      }

      List<Users> usuarios = [];
      agentes.users.forEach((element) {
        if (element.statusLivechat == "available" && element.status == "online") {
          usuarios.add(element);
        }
      });

      return usuarios;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
