/// code : 100
/// message : "Información listada correctamente"
/// status : true
/// data : [{"count":"0"}]

class Notificationcount {
  int? _code;
  String? _message;
  bool? _status;
  List<DataNC>? _data;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;
  List<DataNC>? get data => _data;

  Notificationcount({
      int? code, 
      String? message, 
      bool? status, 
      List<DataNC>? data}){
    _code = code;
    _message = message;
    _status = status;
    _data = data;
}

  Notificationcount.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _status = json["status"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data?.add(DataNC.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["message"] = _message;
    map["status"] = _status;
    if (_data != null) {
      map["data"] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// count : "0"

class DataNC {
  String? _count;

  String? get count => _count;

  DataNC({
      String? count}){
    _count = count;
}

  DataNC.fromJson(dynamic json) {
    _count = json["count"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["count"] = _count;
    return map;
  }

}