/// code : 120
/// message : "Ha ocurrido un error al validar el token"
/// status : false

class Validatecodemail {
  int? _code;
  String? _message;
  bool? _status;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;

  Validatecodemail({
      int? code, 
      String? message, 
      bool? status}){
    _code = code;
    _message = message;
    _status = status;
}

  Validatecodemail.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["message"] = _message;
    map["status"] = _status;
    return map;
  }

}