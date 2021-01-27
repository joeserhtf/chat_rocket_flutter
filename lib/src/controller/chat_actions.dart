import 'dart:typed_data';

import '../../const.dart';
import '../model/room_messages.dart';
import 'chat_controller.dart';

class ChatActions {
  static Future<void> sendMessage(String text) async {
    if (chatActive) {
      await RocketChatApi.sendMessage(
        rooms[selectedRoom].sId ?? '',
        text,
      );
    }
  }

  static sendFile(
    Uint8List file,
    String fileName,
    String fileType,
  ) {
    if (chatActive) {
      RocketChatApi.uploadFile(
        file,
        rooms[selectedRoom].sId ?? '',
        fileName,
        fileType,
      );
    }
  }

  static void sendAudio(Uint8List audio) {
    if (chatActive) {
      RocketChatApi.uploadAudio(
        audio,
        rooms[selectedRoom].sId ?? '',
        'Audio record.mp3',
      );
    }
  }

  static void reActiveChat() {
    fistChat = true;
  }

  static void unableNotifier(Uint8List audio) {
    playNotifier = false;
  }

  static Future<RoomMessages> fetchRoomMessages(String roomId) async {
    return await RocketChatApi.getRoomMessages(roomId);
  }
}
