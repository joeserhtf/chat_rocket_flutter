import 'callback_data.dart';

class ChatOption {
  String name;
  Function(CallbackData) function;

  ChatOption({
    this.name,
    this.function,
  });
}
