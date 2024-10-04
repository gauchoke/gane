/// code : 100
/// message : "Mensaje enviado correctamente"
/// status : true
/// data : {"user":{"id":"b7f66bc8-8bc8-483c-879f-65240d93baf8","fullname":"Kevin Peñaloza","email":"gauchok@hotmail.com","password":"23124","phoneNumber":"3186265632","phonePrefix":"+57","photoUrl":"","type":"lc","verificationCode":"d82e950a6d46a5846afae57c4f69ae3a40c08de1c258b11839e6587b90511e42","options":{"status":"active","createdAt":"2021-07-30T16:14:09.798Z","updatedAt":"2021-07-30T16:14:57.000Z"}},"authToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImI3ZjY2YmM4LThiYzgtNDgzYy04NzlmLTY1MjQwZDkzYmFmOCIsIm1vZGVsTmFtZSI6InVzZXIiLCJpYXQiOjE2Mjc2NjI5NjV9.eZMYgzom0M48H6nsUhP9sfDGKsE2EAtBPp2esIBvbJY"}
/// codeValidate : {"code":"8652"}

class Verifyphone {
  int? _code;
  String? _message;
  bool? _status;
  Data? _data;
  CodeValidate? _codeValidate;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;
  Data? get data => _data;
  CodeValidate? get codeValidate => _codeValidate;

  Verifyphone({
      int? code,
      String? message,
      bool? status,
      Data? data,
      CodeValidate? codeValidate}){
    _code = code;
    _message = message;
    _status = status;
    _data = data;
    _codeValidate = codeValidate;
}

  Verifyphone.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _status = json["status"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
    _codeValidate = json["codeValidate"] != null ? CodeValidate.fromJson(json["codeValidate"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["message"] = _message;
    map["status"] = _status;
    if (_data != null) {
      map["data"] = _data?.toJson();
    }
    if (_codeValidate != null) {
      map["codeValidate"] = _codeValidate?.toJson();
    }
    return map;
  }

}

/// code : "8652"

class CodeValidate {
  String? _code;

  String? get code => _code;

  CodeValidate({
      String? code}){
    _code = code;
}

  CodeValidate.fromJson(dynamic json) {
    _code = json["code"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    return map;
  }

}

/// user : {"id":"b7f66bc8-8bc8-483c-879f-65240d93baf8","fullname":"Kevin Peñaloza","email":"gauchok@hotmail.com","password":"23124","phoneNumber":"3186265632","phonePrefix":"+57","photoUrl":"","type":"lc","verificationCode":"d82e950a6d46a5846afae57c4f69ae3a40c08de1c258b11839e6587b90511e42","options":{"status":"active","createdAt":"2021-07-30T16:14:09.798Z","updatedAt":"2021-07-30T16:14:57.000Z"}}
/// authToken : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImI3ZjY2YmM4LThiYzgtNDgzYy04NzlmLTY1MjQwZDkzYmFmOCIsIm1vZGVsTmFtZSI6InVzZXIiLCJpYXQiOjE2Mjc2NjI5NjV9.eZMYgzom0M48H6nsUhP9sfDGKsE2EAtBPp2esIBvbJY"

class Data {
  User? _user;
  String? _authToken;

  User? get user => _user;
  String? get authToken => _authToken;

  Data({
      User? user,
      String? authToken}){
    _user = user;
    _authToken = authToken;
}

  Data.fromJson(dynamic json) {
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

/// id : "b7f66bc8-8bc8-483c-879f-65240d93baf8"
/// fullname : "Kevin Peñaloza"
/// email : "gauchok@hotmail.com"
/// password : "23124"
/// phoneNumber : "3186265632"
/// phonePrefix : "+57"
/// photoUrl : ""
/// type : "lc"
/// verificationCode : "d82e950a6d46a5846afae57c4f69ae3a40c08de1c258b11839e6587b90511e42"
/// options : {"status":"active","createdAt":"2021-07-30T16:14:09.798Z","updatedAt":"2021-07-30T16:14:57.000Z"}

class User {
  String? _id;
  String? _fullname;
  String? _email;
  String? _password;
  String? _phoneNumber;
  String? _phonePrefix;
  String? _photoUrl;
  String? _type;
  String? _verificationCode;
  String? _imei;
  bool? _userAltan;
  Options? _options;

  String? get id => _id;
  String? get fullname => _fullname;
  String? get email => _email;
  String? get password => _password;
  String? get phoneNumber => _phoneNumber;
  String? get phonePrefix => _phonePrefix;
  String? get photoUrl => _photoUrl;
  String? get type => _type;
  String? get verificationCode => _verificationCode;
  String? get imei => _imei;
  bool? get userAltan => _userAltan;
  Options? get options => _options;

  User({
      String? id,
      String? fullname,
      String? email,
      String? password,
      String? phoneNumber,
      String? phonePrefix,
      String? photoUrl,
      String? type,
      String? verificationCode,
      String? imei,
      bool? userAltan,
      Options? options}){
    _id = id;
    _fullname = fullname;
    _email = email;
    _password = password;
    _phoneNumber = phoneNumber;
    _phonePrefix = phonePrefix;
    _photoUrl = photoUrl;
    _type = type;
    _verificationCode = verificationCode;
    _imei = imei;
    _userAltan = userAltan;
    _options = options;
}

  User.fromJson(dynamic json) {
    _id = json["id"];
    _fullname = json["fullname"];
    _email = json["email"];
    _password = json["password"];
    _phoneNumber = json["phoneNumber"];
    _phonePrefix = json["phonePrefix"];
    _photoUrl = json["photoUrl"];
    _type = json["type"];
    _verificationCode = json["verificationCode"];
    _imei = json["imei"];
    _userAltan = json["userAltan"] ?? false;
    _options = json["options"] != null ? Options.fromJson(json["options"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["fullname"] = _fullname;
    map["email"] = _email;
    map["password"] = _password;
    map["phoneNumber"] = _phoneNumber;
    map["phonePrefix"] = _phonePrefix;
    map["photoUrl"] = _photoUrl;
    map["type"] = _type;
    map["verificationCode"] = _verificationCode;
    map["imei"] = _imei;
    if (_options != null) {
      map["options"] = _options?.toJson();
    }
    return map;
  }

}

/// status : "active"
/// createdAt : "2021-07-30T16:14:09.798Z"
/// updatedAt : "2021-07-30T16:14:57.000Z"

class Options {
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Options({
      String? status,
      String? createdAt,
      String? updatedAt}){
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Options.fromJson(dynamic json) {
    _status = json["status"];
    _createdAt = json["createdAt"];
    _updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["createdAt"] = _createdAt;
    map["updatedAt"] = _updatedAt;
    return map;
  }

}