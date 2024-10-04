/// code : 100
/// message : ""
/// status : true
/// data : {"point":3269,"totalUser":100}

class TotalpointProfileCategories {
  int? _code;
  String? _message;
  bool? _status;
  DataTPC? _data;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;
  DataTPC? get data => _data;

  TotalpointProfileCategories({
      int? code, 
      String? message, 
      bool? status,
    DataTPC? data}){
    _code = code;
    _message = message;
    _status = status;
    _data = data;
}

  TotalpointProfileCategories.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _status = json["status"];
    _data = json["data"] != null ? DataTPC.fromJson(json["data"]) : null;
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

/// point : 3269
/// totalUser : 100

class DataTPC {
  int? _point;
  int? _totalUser;

  int? get point => _point;
  int? get totalUser => _totalUser;

  DataTPC({
      int? point, 
      int? totalUser}){
    _point = point;
    _totalUser = totalUser;
}

  DataTPC.fromJson(dynamic json) {
    _point = json["point"];
    _totalUser = json["totalUser"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["point"] = _point;
    map["totalUser"] = _totalUser;
    return map;
  }

}