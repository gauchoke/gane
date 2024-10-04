/// code : 100
/// message : "Información listada correctamente"
/// status : true
/// data : {"result":[{"id":11,"name":"Finanzas ","color":"#009CE0","pointsQuestion":1000,"cImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/category/c19127458f7c720727c79d806a38429e524799d2-1628094920144.png","categoryStatus":"incomplete"},{"id":12,"name":"Familia","color":"#9F0500","pointsQuestion":1100,"cImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/category/1e755ddd753a0b3c3f311bb243f947cbf1b6907a-1628095056411.png","categoryStatus":"incomplete"},{"id":13,"name":"Edad","color":"#194D33","pointsQuestion":20,"cImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/category/c09d5f9e8638dc7e2b220955e3f24e219845f83b-1628183285979.png","categoryStatus":"incomplete"},{"id":14,"name":"Relación","color":"#D33115","pointsQuestion":10,"cImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/category/b6af890fccc7827f35a68bfef336953be4b63a9c-1628265777261.png","categoryStatus":"incomplete"},{"id":15,"name":"Trabajo","color":"#0062B1","pointsQuestion":15,"cImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/category/50d3bf0ee9d75bcb6e10ea80f18705a689b0a47c-1628265981051.png","categoryStatus":"incomplete"}],"page":1}

class Profilecategories {
  int? _code;
  String? _message;
  bool? _status;
  DataPC? _data;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;
  DataPC? get data => _data;

  Profilecategories({
      int? code, 
      String? message, 
      bool? status,
    DataPC? data}){
    _code = code;
    _message = message;
    _status = status;
    _data = data;
}

  Profilecategories.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _status = json["status"];
    _data = json["data"] != null ? DataPC.fromJson(json["data"]) : null;
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

/// result : [{"id":11,"name":"Finanzas ","color":"#009CE0","pointsQuestion":1000,"cImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/category/c19127458f7c720727c79d806a38429e524799d2-1628094920144.png","categoryStatus":"incomplete"},{"id":12,"name":"Familia","color":"#9F0500","pointsQuestion":1100,"cImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/category/1e755ddd753a0b3c3f311bb243f947cbf1b6907a-1628095056411.png","categoryStatus":"incomplete"},{"id":13,"name":"Edad","color":"#194D33","pointsQuestion":20,"cImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/category/c09d5f9e8638dc7e2b220955e3f24e219845f83b-1628183285979.png","categoryStatus":"incomplete"},{"id":14,"name":"Relación","color":"#D33115","pointsQuestion":10,"cImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/category/b6af890fccc7827f35a68bfef336953be4b63a9c-1628265777261.png","categoryStatus":"incomplete"},{"id":15,"name":"Trabajo","color":"#0062B1","pointsQuestion":15,"cImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/category/50d3bf0ee9d75bcb6e10ea80f18705a689b0a47c-1628265981051.png","categoryStatus":"incomplete"}]
/// page : 1

class DataPC {
  List<Result>? _result;
  int? _page;

  List<Result>? get result => _result;
  int? get page => _page;

  DataPC({
      List<Result>? result, 
      int? page}){
    _result = result;
    _page = page;
}

  DataPC.fromJson(dynamic json) {
    if (json["result"] != null) {
      _result = [];
      json["result"].forEach((v) {
        _result?.add(Result.fromJson(v));
      });
    }
    _page = json["page"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_result != null) {
      map["result"] = _result?.map((v) => v.toJson()).toList();
    }
    map["page"] = _page;
    return map;
  }

}

/// id : 11
/// name : "Finanzas "
/// color : "#009CE0"
/// pointsQuestion : 1000
/// cImages : "https://dev-kubo.s3-us-west-2.amazonaws.com/gn/category/c19127458f7c720727c79d806a38429e524799d2-1628094920144.png"
/// categoryStatus : "incomplete"

class Result {
  int? id;
  String? name;
  String? color;
  int? pointsQuestion;
  int? points;
  String? cImages;
  String? categoryStatus;



  Result({
    this.id,
    this.name,
    this.color,
    this.pointsQuestion,
    this.points,
    this.cImages,
    this.categoryStatus,
  });

  /*int? get id => _id;
  String? get name => _name;
  String? get color => _color;
  int? get pointsQuestion => _pointsQuestion;
  String? get cImages => _cImages;
  String? get categoryStatus => _categoryStatus;

  Result({
      int? id, 
      String? name, 
      String? color, 
      int? pointsQuestion, 
      String? cImages, 
      String? categoryStatus}){
    _id = id;
    _name = name;
    _color = color;
    _pointsQuestion = pointsQuestion;
    _cImages = cImages;
    _categoryStatus = categoryStatus;*/
//}

  /*Result.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _color = json["color"];
    _pointsQuestion = json["pointsQuestion"];
    _cImages = json["cImages"];
    _categoryStatus = json["categoryStatus"];
  }*/



  Result.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    color = json["color"];
    pointsQuestion = json["pointsQuestion"];
    points = json["points"];
    cImages = json["cImages"];
    categoryStatus = json["categoryuser"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["color"] = color;
    map["pointsQuestion"] = pointsQuestion;
    map["points"] = points;
    map["cImages"] = cImages;
    map["categoryuser"] = categoryStatus;
    return map;
  }

}