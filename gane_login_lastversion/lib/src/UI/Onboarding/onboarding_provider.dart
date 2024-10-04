import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gane/src/Utils/share_preferences.dart';
import 'package:gane/src/Utils/singleton.dart';


class OnboardingProvider extends ChangeNotifier {

  Singleton singleton = Singleton();
  SharePreference _prefs = SharePreference();


  /// I have gane chip
  int _haveChip = -1;
  int get haveChip => _haveChip;
  set haveChip(int value) {
    _haveChip = value;
    notifyListeners();
  }


  /// keep your number
  int _keepNumber = -1;
  int get keepNumber => _keepNumber;
  set keepNumber(int value) {
    _keepNumber = value;
    notifyListeners();
  }


  /// Focus Name or Refear
  int _focusReferarOrName = 0;
  int get focusReferarOrName => _focusReferarOrName;
  set focusReferarOrName(int value) {
    _focusReferarOrName = value;
    notifyListeners();
  }

  /// App Lamguage
  String _appLanguage = "es";
  String get appLanguage => _appLanguage;
  set appLanguage(String value) {
    _appLanguage = value;
    notifyListeners();
  }


}