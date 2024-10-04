/// code : 100
/// message : ""
/// status : true
/// data : {"user":{"id":"284bc740-636f-4639-ab93-1783840c1d3e","fullname":"Laura Pérez ","email":"lauperez26@gmail.com ","phoneNumber":"3217946324","phonePrefix":"+57","photoUrl":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/user/icon2.png","type":"lc","longitude":0,"latitude":0,"verificationCode":"97d2244a7046f7586a09c23c5c270591dfc00dbadcbe8a279d045825bd669d29","notificationStatus":0},"authToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjI4NGJjNzQwLTYzNmYtNDYzOS1hYjkzLTE3ODM4NDBjMWQzZSIsIm1vZGVsTmFtZSI6InVzZXIiLCJpYXQiOjE2MzgxMDc2ODZ9.yOWUNQAISJed7mHQ02YDLV4CrZ9gjHDKl8zu_OddEt8"}

class Getprofile {
  int? _code;
  String? _message;
  bool? _status;
  DataGP? _data;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;
  DataGP? get data => _data;

  Getprofile({
    int? code,
    String? message,
    bool? status,
    DataGP? data}){
    _code = code;
    _message = message;
    _status = status;
    _data = data;
  }

  Getprofile.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _status = json["status"];
    _data = json["data"] != null ? DataGP.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["message"] = _message;
    map["status"] = _status;
    if (_data != null) {
      map["data"] = _data?.toJson();
    }
    return map;
  }

}

/// user : {"id":"284bc740-636f-4639-ab93-1783840c1d3e","fullname":"Laura Pérez ","email":"lauperez26@gmail.com ","phoneNumber":"3217946324","phonePrefix":"+57","photoUrl":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/user/icon2.png","type":"lc","longitude":0,"latitude":0,"verificationCode":"97d2244a7046f7586a09c23c5c270591dfc00dbadcbe8a279d045825bd669d29","notificationStatus":0}
/// authToken : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjI4NGJjNzQwLTYzNmYtNDYzOS1hYjkzLTE3ODM4NDBjMWQzZSIsIm1vZGVsTmFtZSI6InVzZXIiLCJpYXQiOjE2MzgxMDc2ODZ9.yOWUNQAISJed7mHQ02YDLV4CrZ9gjHDKl8zu_OddEt8"

class DataGP {
  User? _user;
  String? _authToken;

  User? get user => _user;
  String? get authToken => _authToken;

  DataGP({
    User? user,
    String? authToken}){
    _user = user;
    _authToken = authToken;
  }

  DataGP.fromJson(dynamic json) {
    _user = json["user"] != null ? User.fromJson(json["user"]) : null;
    _authToken = json["authToken"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_user != null) {
      map["user"] = _user?.toJson();
    }
    map["authToken"] = _authToken;
    return map;
  }

}

/// id : "284bc740-636f-4639-ab93-1783840c1d3e"
/// fullname : "Laura Pérez "
/// email : "lauperez26@gmail.com "
/// phoneNumber : "3217946324"
/// phonePrefix : "+57"
/// photoUrl : "https://dev-kubo.s3-us-west-2.amazonaws.com/gn/user/icon2.png"
/// type : "lc"
/// longitude : 0
/// latitude : 0
/// verificationCode : "97d2244a7046f7586a09c23c5c270591dfc00dbadcbe8a279d045825bd669d29"
/// notificationStatus : 0

class User {
  String? _id;
  String? _fullname;
  String? _email;
  String? _phoneNumber;
  String? _phonePrefix;
  String? _photoUrl;
  String? _type;
  String? _verificationCode;
  String? _imei;
  bool? _userAltan;
  double? _days;
  bool? _verificationCodeSim;

  String? get id => _id;
  String? get fullname => _fullname;
  String? get email => _email;
  String? get phoneNumber => _phoneNumber;
  String? get phonePrefix => _phonePrefix;
  String? get photoUrl => _photoUrl;
  String? get type => _type;
  String? get verificationCode => _verificationCode;
  String? get imei => _imei;
  bool? get userAltan => _userAltan;
  double? get days => _days;
  bool? get verificationCodeSim => _verificationCodeSim;

  User({
    String? id,
    String? fullname,
    String? email,
    String? phoneNumber,
    String? phonePrefix,
    String? photoUrl,
    String? type,
    int? longitude,
    int? latitude,
    String? verificationCode,
    String? imei,
    bool? userAltan,
    double? days,
    bool? verificationCodeSim,
    int? notificationStatus}){
    _id = id;
    _fullname = fullname;
    _email = email;
    _phoneNumber = phoneNumber;
    _phonePrefix = phonePrefix;
    _photoUrl = photoUrl;
    _type = type;
    _verificationCode = verificationCode;
    _imei = imei;
    _userAltan = userAltan;
    _days = days;
    _verificationCodeSim = verificationCodeSim;
  }

  User.fromJson(dynamic json) {
    _id = json["id"];
    _fullname = json["fullname"];
    _email = json["email"];
    _phoneNumber = json["phoneNumber"];
    _phonePrefix = json["phonePrefix"];
    _photoUrl = json["photoUrl"];
    _type = json["type"];
    _verificationCode = json["verificationCode"];
    _imei = json["imei"];
    _userAltan = json["userAltan"]?? false;
    _verificationCodeSim= json["verificationCodeSim"]?? false;
    _days = json["days"].toDouble() ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["fullname"] = _fullname;
    map["email"] = _email;
    map["phoneNumber"] = _phoneNumber;
    map["phonePrefix"] = _phonePrefix;
    map["photoUrl"] = _photoUrl;
    map["type"] = _type;
    map["verificationCode"] = _verificationCode;
    map["imei"] = _imei;
    map["userAltan"] = _userAltan;
    map["verificationCodeSim"] = _verificationCodeSim;
    return map;
  }

}