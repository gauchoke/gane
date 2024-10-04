/// code : 100
/// message : "Información creada correctamente"
/// status : true

class AnswersRes {
  int? _code;
  String? _message;
  bool? _status;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;

  AnswersRes({
      int? code, 
      String? message, 
      bool? status}){
    _code = code;
    _message = message;
    _status = status;
}

  AnswersRes.fromJson(dynamic json) {
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