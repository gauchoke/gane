import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

    if(newValue.selection.baseOffset == 0){
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    //final formatter = new NumberFormat("#,###.##", "es_CO");
   //String newText = formatter.format(value);
    String newText = value as String;

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}