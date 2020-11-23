import 'package:chat_rocket_flutter/const.dart';
import 'package:flutter/material.dart';

String allWordsCapitilize(String str) {
  if (str == '') {
    return '';
  }
  return str.replaceAll('   ', '  ').replaceAll('  ', ' ').toLowerCase().split(' ').map((word) {
    String leftText = (word.length > 1) ? word.substring(1, word.length) : '';
    return word[0].toUpperCase() + leftText;
  }).join(' ');
}

multiplicadorCor(String roomId, String depId) {
  return "$roomId".codeUnits.reduce((value, element) => value + element) * "$depId".codeUnits.reduce((value, element) => value + element);
}

mediaQuery(BuildContext context, double value) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  Size size = mediaQuery.size;

  var result = size.width * value;
  return result;
}

textInputForm(
  context,
  String label,
  String hint, {
  bool obscureText = false,
  TextEditingController controller,
  bool obscure = false,
  FocusNode focus,
  TextInputAction action,
  Function done,
  Function next,
  bool auto = false,
  Color colorInput = Colors.blue,
}) {
  return TextFormField(
    controller: controller,
    focusNode: focus,
    textInputAction: action,
    autofocus: auto,
    style: TextStyle(fontSize: 14),
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      focusColor: colorInput,
    ),
    onEditingComplete: done,
    onFieldSubmitted: next,
    obscureText: obscureText,
    validator: (String text) {
      if (text.isEmpty) {
        return "$label!";
      } else {
        return null;
      }
    },
  );
}

fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

copyText(String text, {Color corText = Colors.black}) {
  TextEditingController _text = TextEditingController(text: text);
  return TextFormField(
      controller: _text,
      readOnly: true,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        isCollapsed: true,
        isDense: true,
        focusColor: baseColor,
      ),
      style: TextStyle(
        color: corText,
      ));
}
