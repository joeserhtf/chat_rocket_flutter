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

mediaQuery(BuildContext context, double value) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  Size size = mediaQuery.size;

  var result = size.width * value;
  return result;
}

textInputForm(context, String label, String hint,
    {bool obscureText = false,
    TextEditingController controller,
    bool obscure = false,
    FocusNode focus,
    TextInputAction action,
    Function done,
    Function next,
    bool auto = false}) {
  return TextFormField(
    controller: controller,
    focusNode: focus,
    textInputAction: action,
    autofocus: auto,
    style: TextStyle(fontSize: 14),
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
    ),
    onEditingComplete: done,
    onFieldSubmitted: next,
    obscureText: obscureText,
    validator: (String text) {
      if (text.isEmpty) {
        return "Favor informar $label!";
      } else {
        return null;
      }
    },
  );
}
