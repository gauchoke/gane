/// code : 100
/// message : "Información listada correctamente"
/// status : true
/// data : {"id":13,"title":"title","message":"sub title messages","description":"description notification","ntImage":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/notification/c4ffe8e2261df6902a7aaf763384e3dbeba64720-1634496455432.png","type":"GN","options":{"status":"active","createdAt":"2021-10-17T18:47:37.437Z","updatedAt":"2021-10-17T18:47:37.437Z"}}

class Generalnotification {
  int? _code;
  String? _message;
  bool? _status;
  DataGN? _data;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;
  DataGN? get data => _data;

  Generalnotification({
      int? code, 
      String? message, 
      bool? status,
    DataGN? data}){
    _code = code;
    _message = message;
    _status = status;
    _data = data;
}

  Generalnotification.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _status = json["status"];
    _data = json["data"] != null ? DataGN.fromJson(json["data"]) : null;
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

/// id : 13
/// title : "title"
/// message : "sub title messages"
/// description : "description notification"
/// ntImage : "https://dev-kubo.s3-us-west-2.amazonaws.com/gn/notification/c4ffe8e2261df6902a7aaf763384e3dbeba64720-1634496455432.png"
/// type : "GN"
/// options : {"status":"active","createdAt":"2021-10-17T18:47:37.437Z","updatedAt":"2021-10-17T18:47:37.437Z"}

class DataGN {
  int? _id;
  String? _title;
  String? _message;
  String? _description;
  String? _ntImage;
  String? _type;
  Options? _options;
  String? _url;
  String? _points;
  String? _prices;

  int? get id => _id;
  String? get title => _title;
  String? get message => _message;
  String? get description => _description;
  String? get ntImage => _ntImage;
  String? get type => _type;
  Options? get options => _options;
  String? get url => _url;
  String? get points => _points;
  String? get prices => _prices;

  DataGN({
      int? id, 
      String? title, 
      String? message, 
      String? description, 
      String? ntImage, 
      String? type, 
      Options? options,
      String? url,
    String? points,
    String? prices
  }){
    _id = id;
    _title = title;
    _message = message;
    _description = description;
    _ntImage = ntImage;
    _type = type;
    _options = options;
    _url = url;
    _points = points;
    _prices = prices;
}

  DataGN.fromJson(dynamic json) {
    _id = json["id"];
    _title = json["title"];
    _message = json["message"];
    _description = json["description"];
    _ntImage = json["ntImage"];
    _type = json["type"];
    _options = json["options"] != null ? Options.fromJson(json["options"]) : null;
    _url = json["url"];
    _points = json["points"];
    _prices = json["prices"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["title"] = _title;
    map["message"] = _message;
    map["description"] = _description;
    map["ntImage"] = _ntImage;
    map["type"] = _type;
    if (_options != null) {
      map["options"] = _options?.toJson();
    }
    map["url"] = _url;
    map["points"] = _points;
    map["prices"] = _prices;
    return map;
  }

}

/// status : "active"
/// createdAt : "2021-10-17T18:47:37.437Z"
/// updatedAt : "2021-10-17T18:47:37.437Z"

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