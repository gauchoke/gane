/// code : 100
/// message : "Información listada correctamente"
/// status : true
/// data : {"result":[{"id":332,"options":{"createdAt":"2021-11-02T13:57:32.451Z"},"notification":{"id":96,"title":"title","message":"sub title messages","ntImage":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","type":"SEQUENCE"}},{"id":320,"options":{"createdAt":"2021-11-02T13:32:20.144Z"},"notification":{"id":95,"title":"prueba 1 test","message":"este es un mensaje de prueba","ntImage":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","type":"SEQUENCE"}},{"id":308,"options":{"createdAt":"2021-11-02T13:29:55.705Z"},"notification":{"id":94,"title":"anuncio prueba","message":"este es un anuncio de prueba","ntImage":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","type":"SEQUENCE"}}],"page":1}

class Notificationslist {
  int? _code;
  String? _message;
  bool? _status;
  DataNL? _data;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;
  DataNL? get data => _data;

  Notificationslist({
      int? code, 
      String? message, 
      bool? status,
    DataNL? data}){
    _code = code;
    _message = message;
    _status = status;
    _data = data;
}

  Notificationslist.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _status = json["status"];
    _data = json["data"] != null ? DataNL.fromJson(json["data"]) : null;
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

/// result : [{"id":332,"options":{"createdAt":"2021-11-02T13:57:32.451Z"},"notification":{"id":96,"title":"title","message":"sub title messages","ntImage":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","type":"SEQUENCE"}},{"id":320,"options":{"createdAt":"2021-11-02T13:32:20.144Z"},"notification":{"id":95,"title":"prueba 1 test","message":"este es un mensaje de prueba","ntImage":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","type":"SEQUENCE"}},{"id":308,"options":{"createdAt":"2021-11-02T13:29:55.705Z"},"notification":{"id":94,"title":"anuncio prueba","message":"este es un anuncio de prueba","ntImage":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","type":"SEQUENCE"}}]
/// page : 1

class DataNL {
  List<ResultNL>? _result;
  int? _page;

  List<ResultNL>? get result => _result;
  int? get page => _page;

  DataNL({
      List<ResultNL>? result,
      int? page}){
    _result = result;
    _page = page;
}

  DataNL.fromJson(dynamic json) {
    if (json["result"] != null) {
      _result = [];
      json["result"].forEach((v) {
        _result?.add(ResultNL.fromJson(v));
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

/// id : 332
/// options : {"createdAt":"2021-11-02T13:57:32.451Z"}
/// notification : {"id":96,"title":"title","message":"sub title messages","ntImage":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","type":"SEQUENCE"}

class ResultNL {
  int? _id;
  //int? _notificationValue;
  int? notificationValue;
  Options? _options;
  Notification? _notification;

  int? get id => _id;
  //int? get notificationValue => _notificationValue;
  Options? get options => _options;
  Notification? get notification => _notification;

  ResultNL({
      int? id,
      //int? notificationValue,
      this.notificationValue,
      Options? options, 
      Notification? notification}){
    _id = id;
    //_notificationValue = notificationValue;
    _options = options;
    _notification = notification;
}

  ResultNL.fromJson(dynamic json) {
    _id = json["id"];
    //_notificationValue = json["notificationValue"];
    notificationValue = json["notificationValue"];
    _options = json["options"] != null ? Options.fromJson(json["options"]) : null;
    _notification = json["notification"] != null ? Notification.fromJson(json["notification"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    //map["notificationValue"] = _notificationValue;
    map["notificationValue"] = notificationValue;
    if (_options != null) {
      map["options"] = _options?.toJson();
    }
    if (_notification != null) {
      map["notification"] = _notification?.toJson();
    }
    return map;
  }

}

/// id : 96
/// title : "title"
/// message : "sub title messages"
/// ntImage : "https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png"
/// type : "SEQUENCE"

class Notification {
  int? _id;
  String? _title;
  String? _message;
  String? _ntImage;
  String? _type;

  int? get id => _id;
  String? get title => _title;
  String? get message => _message;
  String? get ntImage => _ntImage;
  String? get type => _type;

  Notification({
      int? id, 
      String? title, 
      String? message, 
      String? ntImage, 
      String? type}){
    _id = id;
    _title = title;
    _message = message;
    _ntImage = ntImage;
    _type = type;
}

  Notification.fromJson(dynamic json) {
    _id = json["id"];
    _title = json["title"];
    _message = json["message"];
    _ntImage = json["ntImage"];
    _type = json["type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["title"] = _title;
    map["message"] = _message;
    map["ntImage"] = _ntImage;
    map["type"] = _type;
    return map;
  }

}

/// createdAt : "2021-11-02T13:57:32.451Z"

class Options {
  String? _createdAt;

  String? get createdAt => _createdAt;

  Options({
      String? createdAt}){
    _createdAt = createdAt;
}

  Options.fromJson(dynamic json) {
    _createdAt = json["createdAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["createdAt"] = _createdAt;
    return map;
  }

}