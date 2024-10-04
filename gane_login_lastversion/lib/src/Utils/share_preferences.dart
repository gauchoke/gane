import 'package:shared_preferences/shared_preferences.dart';

class SharePreference {

  static final SharePreference _instancia = new SharePreference._internal();

  factory SharePreference() {
    return _instancia;
  }

  SharePreference._internal();

  SharedPreferences? _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  clearPrefs()async{
    final pref = await SharedPreferences.getInstance();
    await pref.clear();
  }

  String  get token {
    return _prefs!.getString('token') ?? "0";
  }

  set token(String value) {
    _prefs!.setString('token', value);
  }

  String  get authToken {
    return _prefs!.getString('authToken') ?? "0";
  }

  set authToken(String value) {
    _prefs!.setString('authToken', value);
  }

  String  get countryCode {
    return _prefs!.getString('countryCode') ?? "0";
  }

  set countryCode(String value) {
    _prefs!.setString('countryCode', value);
  }

  String  get LanguageCode {
    return _prefs!.getString('LanguageCode') ?? "0";
  }

  set LanguageCode(String value) {
    _prefs!.setString('LanguageCode', value);
  }

  String  get permissionGallery {
    return _prefs!.getString('permissionGallery') ?? "0";
  }

  set permissionGallery(String value) {
    _prefs!.setString('permissionGallery', value);
  }


  String  get indiCountry {
    return _prefs!.getString('indiCountry') ?? "+57";
  }

  set indiCountry(String value) {
    _prefs!.setString('indiCountry', value);
  }

  String  get dataMessage {
    return _prefs!.getString('dataMessage') ?? "";
  }

  set dataMessage(String value) {
    _prefs!.setString('dataMessage', value);
  }

  String  get helCategories {
    return _prefs!.getString('helCategories') ?? "";
  }

  set helCategories(String value) {
    _prefs!.setString('helCategories', value);
  }

  String get imei {
    return _prefs!.getString('imei') ?? "0";
  }

  set imei(String value) {
    _prefs!.setString('imei', value);
  }

  String get countrySIMCOde {
    return _prefs!.getString('countrySIMCOde') ?? "0";
  }

  set countrySIMCOde(String value) {
    _prefs!.setString('countrySIMCOde', value);
  }

  String get phoneUserNumber {
    return _prefs!.getString('phoneUserNumber') ?? "0";
  }

  set phoneUserNumber(String value) {
    _prefs!.setString('phoneUserNumber', value);
  }

  String get flagWinCanje {
    return _prefs!.getString('flagWinCanje') ?? "0";
  }

  set flagWinCanje(String value) {
    _prefs!.setString('flagWinCanje', value);
  }


  String get imageOnline {
    return _prefs!.getString('imageOnline') ?? "0";
  }

  set imageOnline(String value) {
    _prefs!.setString('imageOnline', value);
  }

  String get splashOnline {
    return _prefs!.getString('splashOnline') ?? "0";
  }

  set splashOnline(String value) {
    _prefs!.setString('splashOnline', value);
  }

  String get colorOnline {
    return _prefs!.getString('colorOnline') ?? "0";
  }

  set colorOnline(String value) {
    _prefs!.setString('colorOnline', value);
  }


  String get homeOrAnswer {
    return _prefs!.getString('homeOrAnswer') ?? "home";
  }

  set homeOrAnswer(String value) {
    _prefs!.setString('homeOrAnswer', value);
  }





}


